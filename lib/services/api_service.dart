import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cutcy/auth/login_screen.dart';
import 'package:cutcy/services/Exceptions/app_exceptions.dart';
import 'package:cutcy/services/api_configs.dart';
import 'package:cutcy/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class ApiService extends GetxService {
  final String baseUrl;
  RxString token = "".obs;

  ApiService({this.baseUrl = ApiConfig.baseUrl});

  void setToken(String newToken) => token.value = newToken;

  // ------------ public ------------
  Future<dynamic> request(
    String endpoint, {
    String method = 'GET',
    Map<String, String>? headers,
    Map<String, dynamic>? query,
    dynamic body,
    Duration timeout = const Duration(seconds: 25),
    int maxRetries = 2,
    // multipart
    List<File>? files,
    List<File>? images,
    File? singleImage,
    File? video,
    String mediaKey = 'image',
  }) async {
    // Build URI first (so we can decide how to check connectivity)
    final uri = _buildUri(endpoint, query);

    // 1) connectivity / reachability gate
    if (!await _hasInternet()) {
      _goOffline(
        onRetry: () {
          // close offline screen and retry the exact same call
          Get.back();
          request(
            endpoint,
            method: method,
            headers: headers,
            query: query,
            body: body,
            timeout: timeout,
            maxRetries: maxRetries,
            files: files,
            images: images,
            singleImage: singleImage,
            video: video,
            mediaKey: mediaKey,
          );
        },
      );
      throw FetchDataException("No internet connection");
    }

    // 2) headers
    final hdrs = <String, String>{};
    if (headers != null) hdrs.addAll(headers);

    // Your API uses x-access-token (per Postman collection)
    if (token.value.isNotEmpty && !hdrs.containsKey('x-access-token')) {
      hdrs['x-access-token'] = token.value;
    }

    // content-type for non-multipart
    final isMultipart = files != null || images != null || singleImage != null || video != null;
    if (!isMultipart) {
      hdrs.putIfAbsent('Content-Type', () => 'application/json');
      hdrs.putIfAbsent('Accept', () => 'application/json');
    }

    // 3) retries with simple exponential backoff
    int attempt = 0;
    while (true) {
      attempt++;
      try {
        http.Response response;

        if (isMultipart) {
          response = await _sendMultipart(
            uri: uri,
            method: method,
            headers: hdrs,
            body: body,
            files: files,
            images: images,
            singleImage: singleImage,
            video: video,
            mediaKey: mediaKey,
          ).timeout(timeout);
        } else {
          response = await _sendJson(uri: uri, method: method, headers: hdrs, body: body).timeout(timeout);
        }

        log("[$method] $uri\nH: $hdrs\nB: ${isMultipart ? '[multipart]' : body}");
        log("Status: ${response.statusCode} Body: ${response.body}");

        final parsed = _handleResponse(response);
        return parsed;
      } on TimeoutException {
        if (attempt <= maxRetries) {
          await Future.delayed(Duration(milliseconds: 400 * attempt));
          continue;
        }
        throw FetchDataException("Request timeout. Please try again.");
      } on SocketException {
        if (attempt <= maxRetries) {
          await Future.delayed(Duration(milliseconds: 400 * attempt));
          continue;
        }
        _goOffline(onRetry: () => Get.back());
        throw FetchDataException("No internet connection");
      } on HandshakeException {
        throw FetchDataException("Secure connection failed (SSL).");
      } on FormatException catch (e) {
        throw AppException("Invalid response format: ${e.message}");
      } on http.ClientException catch (e) {
        throw FetchDataException("Network error: ${e.message}");
      }
    }
  }

  // ------------ internals ------------
  Uri _buildUri(String endpoint, Map<String, dynamic>? query) {
    // Allow absolute endpoints (e.g. http://192.168.1.12:4000/...)
    Uri baseUri;
    if (endpoint.startsWith('http://') || endpoint.startsWith('https://')) {
      baseUri = Uri.parse(endpoint);
    } else {
      final base = baseUrl.endsWith('/') ? baseUrl : "$baseUrl/";
      baseUri = Uri.parse("$base$endpoint");
    }

    if (query == null || query.isEmpty) return baseUri;

    // Preserve any existing query in the baseUri and merge
    return baseUri.replace(queryParameters: {...baseUri.queryParameters, ...query.map((k, v) => MapEntry(k, v?.toString()))});
  }

  Future<http.Response> _sendJson({required Uri uri, required String method, required Map<String, String> headers, dynamic body}) {
    switch (method.toUpperCase()) {
      case 'POST':
        return body == null ? http.post(uri, headers: headers) : http.post(uri, headers: headers, body: jsonEncode(body));
      case 'PUT':
        return http.put(uri, headers: headers, body: jsonEncode(body ?? {}));
      case 'PATCH':
        return http.patch(uri, headers: headers, body: jsonEncode(body ?? {}));
      case 'DELETE':
        return http.delete(uri, headers: headers);
      case 'GET':
      default:
        return http.get(uri, headers: headers);
    }
  }

  Future<http.Response> _sendMultipart({
    required Uri uri,
    required String method,
    required Map<String, String> headers,
    dynamic body,
    List<File>? files,
    List<File>? images,
    File? singleImage,
    File? video,
    required String mediaKey,
  }) async {
    final req = http.MultipartRequest(method.toUpperCase(), uri);
    req.headers.addAll(headers);

    if (body != null && body is Map) {
      body.forEach((k, v) => req.fields[k] = v.toString());
    }

    Future<void> addPath(String key, File f) async => req.files.add(await http.MultipartFile.fromPath(key, f.path));

    if (files != null) {
      for (final f in files) {
        await addPath(mediaKey, f);
      }
    }
    if (images != null) {
      for (final f in images) {
        await addPath(mediaKey, f);
      }
    }
    if (singleImage != null) {
      await addPath(mediaKey, singleImage);
    }
    if (video != null) {
      await addPath(mediaKey, video);
    }

    final streamed = await req.send();
    final text = await streamed.stream.bytesToString();
    return http.Response(text, streamed.statusCode, headers: streamed.headers);
  }

  dynamic _handleResponse(http.Response response) {
    final status = response.statusCode;

    dynamic decoded;
    if (response.body.isEmpty) {
      decoded = null;
    } else {
      try {
        decoded = jsonDecode(response.body);
      } catch (_) {
        decoded = response.body; // tolerate non-JSON success
      }
    }

    switch (status) {
      case 200:
      case 201:
        return decoded;
      case 400:
        throw BadRequestException(_msg(decoded, fallback: "Invalid input."));
      case 401:
        _handleSessionExpired();
        throw UnauthorizedException(_msg(decoded, fallback: "Unauthorized / session expired."));
      case 403:
        throw AppException(_msg(decoded, fallback: "Forbidden."));
      case 404:
        throw NotFoundException(_msg(decoded, fallback: "Not found."));
      case 408:
        throw FetchDataException("Request timeout.");
      case 409:
        throw AppException(_msg(decoded, fallback: "Conflict."));
      case 422:
        throw BadRequestException(_msg(decoded, fallback: "Unprocessable entity."));
      case 429:
        throw AppException(_msg(decoded, fallback: "Too many requests."));
      case 500:
      case 502:
      case 503:
      case 504:
        throw ServerException(_msg(decoded, fallback: "Server error. Try again later."));
      default:
        throw AppException(_msg(decoded, fallback: "Unexpected error ($status)."));
    }
  }

  String _msg(dynamic decoded, {required String fallback}) {
    if (decoded == null) return fallback;
    if (decoded is Map) {
      return (decoded["message"] ?? decoded["error"] ?? decoded["msg"] ?? fallback).toString();
    }
    if (decoded is String && decoded.trim().isNotEmpty) return decoded;
    return fallback;
  }

  /// Smarter reachability:
  /// - For local/LAN hosts → TCP probe to host:port
  /// - Otherwise → connectivity_plus (none/some)
  Future<bool> _hasInternet() async {
    final result = await Connectivity().checkConnectivity();
    if (result.contains(ConnectivityResult.none) || result.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  void _goOffline({required VoidCallback onRetry}) {
    // Use Get.to so Get.back() from onRetry returns to previous page
    Get.to(() => NoConnectionScreen(onRetry: onRetry));
  }

  void _handleSessionExpired() {
    token.value = "";
    StorageService.to.clearAll();

    Get.snackbar(
      "Session Expired",
      "Please log in again.",
      backgroundColor: Colors.orange,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );

    Get.offAll(() => LoginScreen());
  }
}

/// no_connection_screen.dart
class NoConnectionScreen extends StatelessWidget {
  final VoidCallback onRetry;
  const NoConnectionScreen({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.wifi_off, size: 80),
              const SizedBox(height: 16),
              const Text("No Internet Connection", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              const Text("Please check your connection and try again.", textAlign: TextAlign.center),
              const SizedBox(height: 24),
              FilledButton.icon(onPressed: onRetry, icon: const Icon(Icons.refresh), label: const Text("Retry")),
            ],
          ),
        ),
      ),
    );
  }
}
