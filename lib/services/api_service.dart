import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cutcy/auth/login_screen.dart';
import 'package:cutcy/services/Exceptions/AppExceptions.dart';
import 'package:cutcy/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class ApiService extends GetxService {
  final String baseUrl;
  RxString token = "".obs; // Observable token

  ApiService({required this.baseUrl});

  // Function to set/update token
  void setToken(String newToken) {
    token.value = newToken;
  }

  Future<bool> checkInternetConnectionWithRedirect(VoidCallback onRetry) async {
    final result = await Connectivity().checkConnectivity();
    if (result.contains(ConnectivityResult.none) || result.isEmpty) {
      Get.offAll(() => NoConnectionScreen(onRetry: onRetry));
      return false;
    }
    return true;
  }

  // Function to make API requests
  Future<dynamic> request(
    String endpoint, {
    String mediaKey = 'image',
    String method = 'GET',
    Map<String, String>? headers,
    dynamic body,
    List<File>? files,
    List<File>? images,
    File? singleImage,
    File? video,
  }) async {
    // 🔌 Step 1: Check internet connectivity
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none) || connectivityResult.isEmpty) {
      Get.snackbar("No Internet", "Please check your internet connection.", backgroundColor: Colors.red, colorText: Colors.white);
      return;
      // return {'error': true, 'message': 'No internet connection'};
    }
    headers ??= {};

    if (token.value.isNotEmpty) {
      // headers['Accept'] = 'application/json';
      headers['Authorization'] = 'Bearer ${token.value}';
    }

    // try {
    final url = Uri.parse('$baseUrl$endpoint');

    if (files != null || images != null || singleImage != null || video != null) {
      // Handle multipart request for files/images/video
      return await multipartRequest(
        mediaKey: mediaKey,
        url: url,
        method: method,
        headers: headers,
        body: body,
        files: files,
        images: images,
        singleImage: singleImage,
        video: video,
      );
    } else {
      // Handle regular JSON request
      headers['Content-Type'] = 'application/json';
      if (token.value.isNotEmpty) {
        headers['Accept'] = 'application/json';
        headers['Authorization'] = 'Bearer ${token.value}';
        // headers['Authorization'] = 'Bearer ${token.value}';

        // headers['Authorization'] = "x-access-token ${token.value}";
      }
      log('URL: ${url.toString()} Headers: ${headers.toString()}');
      http.Response response;

      switch (method.toUpperCase()) {
        case 'POST':
          log("Request URL: $url");
          // response = await http.post(url, headers: headers, body: jsonEncode(body));
          if (body != null) {
            response = await http.post(url, headers: headers, body: jsonEncode(body));
          } else {
            // NO BODY: do not set Content-Type, just send headers

            response = await http.post(url, headers: headers);
          }
          break;
        case 'PUT':
          log("Put URL: $url");
          response = await http.put(url, headers: headers, body: jsonEncode(body));
          break;
        case 'PATCH':
          log("Patch URL: $url");
          response = await http.patch(url, headers: headers, body: jsonEncode(body));
          break;
        case 'DELETE':
          log("Delete URL: $url");
          response = await http.delete(url, headers: headers);
          break;
        case 'GET':
        default:
          log("Get URL: $url");
          response = await http.get(url, headers: headers);
      }
      log("headers: $headers");
      log("Request URL: $url");
      log("Api Response:  ${response.body}");

      return _handleResponse(response);

      // response;
    }
  }
  // on SocketException catch (_) {
  //   // 🔴  No internet connection
  //   Get.snackbar(
  //     "Connection Error",
  //     "No internet connection. Please check your connection and try again.",
  //     backgroundColor: Colors.red,
  //     colorText: Colors.white,
  //   );
  //   return {'error': true, 'message': 'No internet connection'};
  // }
  // catch (e) {
  //   // Get.back();
  //   Navigator.pop(Get.context!);

  //   Get.snackbar("Error", e.toString(), backgroundColor: Colors.red, colorText: Colors.white);

  //   return {'error': true, 'message': e.toString()};
  // }

  // {
  //   //
  //   Get.back();
  // }
  // }

  // Function to handle multipart requests
  Future<dynamic> multipartRequest({
    required Uri url,
    required String method,
    required Map<String, String> headers,
    required String mediaKey,
    dynamic body,
    List<File>? files,
    List<File>? images,
    File? singleImage,
    File? video,
  }) async {
    try {
      var request = http.MultipartRequest(method.toUpperCase(), url);

      // Add headers
      request.headers.addAll(headers);

      // Add body fields if provided
      if (body != null) {
        body.forEach((key, value) {
          request.fields[key] = value.toString();
        });
      }

      // Add files
      if (files != null) {
        for (var file in files) {
          request.files.add(await http.MultipartFile.fromPath(mediaKey, file.path));
        }
      }

      // Add images
      if (images != null) {
        for (var image in images) {
          request.files.add(await http.MultipartFile.fromPath(mediaKey, image.path));
        }
      }

      // Add single image
      if (singleImage != null) {
        request.files.add(await http.MultipartFile.fromPath(mediaKey, singleImage.path));
      }

      // Add video
      if (video != null) {
        request.files.add(await http.MultipartFile.fromPath(mediaKey, video.path));
      }

      // Send request
      var response = await request.send();

      // Handle response
      var responseData = await response.stream.bytesToString();
      return _handleResponse(http.Response(responseData, response.statusCode));
    } catch (e) {
      return {'error': true, 'message': e.toString()};
    }
  }

  // Function to handle API responses
  dynamic _handleResponse(http.Response response) {
    final decoded = jsonDecode(response.body);

    switch (response.statusCode) {
      case 200:
      case 201:
        return decoded;
      case 400:
        throw BadRequestException(decoded["message"] ?? "Invalid input. Please check your data.");
      // return decoded;
      case 401:
        _handleSessionExpired();
        throw UnauthorizedException("Unauthorized: ${decoded["message"] ?? "Session expired"}");
      case 403:
        throw AppException("Forbidden: ${decoded["message"] ?? "Access denied"}");
      case 404:
        throw NotFoundException("Not Found: ${decoded["message"] ?? "Invalid endpoint"}");
      case 500:
        throw ServerException("Server error: ${decoded["message"] ?? "Try again later"}");
      default:
        throw AppException("Unexpected error: ${decoded["message"] ?? "Something went wrong"}");
    }
  }

  // Add this method to handle session expiration
  void _handleSessionExpired() {
    // Clear token from API service
    token.value = "";

    // Clear all stored preferences
    StorageService.to.clearAll();

    // Show session expired message
    Get.snackbar(
      "Session Expired",
      "Your session has expired. Please login again.",
      backgroundColor: Colors.orange,
      colorText: Colors.white,
      duration: Duration(seconds: 3),
    );

    // Navigate to login screen and clear all previous routes
    Get.offAll(() => LoginScreen()); // If using named routes
    // OR
    // Get.offAll(() => LoginScreen()); // If using direct navigation
  }
}

class NoConnectionScreen extends StatelessWidget {
  final VoidCallback onRetry;

  const NoConnectionScreen({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.wifi_off, size: 80, color: Colors.redAccent),
              const SizedBox(height: 16),
              const Text("No Internet Connection", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text("Please check your connection and try again.", textAlign: TextAlign.center),
              const SizedBox(height: 24),
              ElevatedButton.icon(onPressed: onRetry, icon: const Icon(Icons.refresh), label: const Text("Retry")),
            ],
          ),
        ),
      ),
    );
  }
}
