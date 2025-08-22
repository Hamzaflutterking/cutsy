// create_profile_controller.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cutcy/auth/auth_controller.dart';
import 'package:cutcy/auth/user_model.dart';
import 'package:cutcy/constants/constants.dart';
import 'package:cutcy/navbar/main_navbar.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';

import 'package:cutcy/constants/helper.dart'; // showCustomSnackbar()
import 'package:cutcy/services/api_configs.dart';
import 'package:cutcy/main.dart'; // apiService instance & colors (if placed there)

class Option {
  final String id;
  final String label;
  const Option({required this.id, required this.label});

  factory Option.fromMap(Map<String, dynamic> m) => Option(id: m['id'] as String, label: (m['name'] ?? '').toString());
}

class CreateProfileController extends GetxController {
  AuthController authC = Get.find<AuthController>();
  // Form fields
  final firstNameC = TextEditingController();
  final lastNameC = TextEditingController();
  final phoneC = TextEditingController();

  final addressNameC = TextEditingController(); // Display name / place name
  final addressLine1C = TextEditingController();
  final addressLine2C = TextEditingController();
  final cityC = TextEditingController();
  final stateC = TextEditingController();
  final countryC = TextEditingController();
  final postalC = TextEditingController();

  // Gender (MALE / FEMALE / OTHER)
  final gender = 'MALE'.obs;

  // Hair meta (IDs required by API) — seeded with your sample IDs

  // Lists + loading flags
  final hairTypes = <Option>[].obs;
  final hairLengths = <Option>[].obs;
  final hairTypeLoading = false.obs;
  final hairLengthLoading = false.obs;
  final selectedHairType = Rx<Option?>(null);
  final selectedHairLength = Rx<Option?>(null);

  // final hairTypes = <Option>[
  //   Option(id: '0359a7f8-2fbc-4535-b4c2-d7b75e6b80f4', label: 'Straight'),
  //   Option(id: '9b2f13cd-21c1-4d7c-8c7e-000000000001', label: 'Wavy'),
  //   Option(id: '9b2f13cd-21c1-4d7c-8c7e-000000000002', label: 'Curly'),
  //   Option(id: '9b2f13cd-21c1-4d7c-8c7e-000000000003', label: 'Coily'),
  // ].obs;

  // final hairLengths = <Option>[
  //   Option(id: '265d9ad8-92b7-483e-ba93-c8fa258fae3a', label: 'Medium'),
  //   Option(id: '00000000-0000-0000-0000-000000000011', label: 'Very Short'),
  //   Option(id: '00000000-0000-0000-0000-000000000012', label: 'Short'),
  //   Option(id: '00000000-0000-0000-0000-000000000013', label: 'Medium-Long'),
  //   Option(id: '00000000-0000-0000-0000-000000000014', label: 'Long'),
  //   Option(id: '00000000-0000-0000-0000-000000000015', label: 'Extra Long'),
  // ].obs;

  // final selectedHairType = Rx<Option?>(null);
  // final selectedHairLength = Rx<Option?>(null);

  // Map & location
  final selectedLatLng = const LatLng(24.8607, 67.0011).obs; // Karachi default
  final isLoading = false.obs;

  // Suggestions
  final addressQueryC = TextEditingController();
  final suggestions = <Map<String, dynamic>>[].obs;
  Timer? _debounce;
  @override
  void onInit() {
    super.onInit();
    // Optional prefetch so pickers open instantly:
    fetchHairTypes();
    fetchHairLengths();
  }

  @override
  void onClose() {
    firstNameC.dispose();
    lastNameC.dispose();
    phoneC.dispose();
    addressNameC.dispose();
    addressLine1C.dispose();
    addressLine2C.dispose();
    cityC.dispose();
    stateC.dispose();
    countryC.dispose();
    postalC.dispose();
    addressQueryC.dispose();
    _debounce?.cancel();
    super.onClose();
  }

  void setGender(String g) => gender.value = g;

  // Dropdown helpers (simple bottom sheets)
  Future<void> pickHairType() async {
    final pick = await _pickOption('Select Hair Type', hairTypes);
    if (pick != null) selectedHairType.value = pick;
  }

  Future<void> pickHairLength() async {
    final pick = await _pickOption('Select Hair Length', hairLengths);
    if (pick != null) selectedHairLength.value = pick;
  }
  // =============== FETCHERS ===============

  Future<void> fetchHairTypes({bool force = false}) async {
    if (!force && hairTypes.isNotEmpty) return;
    try {
      hairTypeLoading.value = true;
      final res = await apiService.request(
        ApiConfig.adminShowHairType, // GET /admin/hair/adminShowHairType
        method: "GET",
      );
      final data = (res?['data'] as List?) ?? const [];
      hairTypes
        ..clear()
        ..addAll(data.map((e) => Option.fromMap(Map<String, dynamic>.from(e))));
    } catch (e) {
      showCustomSnackbar(title: 'Hair types', message: e.toString(), icon: Icons.error_outline);
    } finally {
      hairTypeLoading.value = false;
    }
  }

  Future<void> fetchHairLengths({bool force = false}) async {
    if (!force && hairLengths.isNotEmpty) return;
    try {
      hairLengthLoading.value = true;
      final res = await apiService.request(
        ApiConfig.adminShowHairLength, // GET /admin/hair/adminShowHairLength
        method: "GET",
      );
      final data = (res?['data'] as List?) ?? const [];
      hairLengths
        ..clear()
        ..addAll(data.map((e) => Option.fromMap(Map<String, dynamic>.from(e))));
    } catch (e) {
      showCustomSnackbar(title: 'Hair lengths', message: e.toString(), icon: Icons.error_outline);
    } finally {
      hairLengthLoading.value = false;
    }
  }

  // =============== SHOW & SELECT HELPERS ===============

  /// Ensures data is loaded, then opens the picker and saves the selection.
  Future<void> openHairTypePicker() async {
    if (hairTypes.isEmpty) await fetchHairTypes(force: true);
    final pick = await _pickOption('Select Hair Type', hairTypes);
    if (pick != null) selectedHairType.value = pick;
  }

  Future<void> openHairLengthPicker() async {
    if (hairLengths.isEmpty) await fetchHairLengths(force: true);
    final pick = await _pickOption('Select Hair Length', hairLengths);
    if (pick != null) selectedHairLength.value = pick;
  }

  Future<Option?> _pickOption(String title, List<Option> data) async {
    return await Get.bottomSheet<Option>(
      Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: const BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                ...data.map(
                  (o) => ListTile(
                    title: Text(o.label, style: const TextStyle(color: Colors.white)),
                    onTap: () => Get.back(result: o),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // =============== Location / Map ===============

  Future<void> centerOnGps() async {
    final perm = await Permission.location.request();
    if (!perm.isGranted) {
      showCustomSnackbar(
        title: 'Location blocked',
        message: 'Permission denied. You can still type your address manually.',
        icon: Icons.location_disabled,
      );
      return;
    }

    try {
      final pos = await Geolocator.getCurrentPosition(locationSettings: LocationSettings(accuracy: LocationAccuracy.best));
      final latLng = LatLng(pos.latitude, pos.longitude);
      selectedLatLng.value = latLng;
      await reverseGeocode(latLng);
    } catch (e) {
      showCustomSnackbar(title: 'GPS failed', message: e.toString(), icon: Icons.gps_off);
    }
  }

  Future<void> reverseGeocode(LatLng latLng) async {
    try {
      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?lat=${latLng.latitude}&lon=${latLng.longitude}&format=json&addressdetails=1',
      );
      final resp = await http.get(url, headers: {'User-Agent': 'cutcy-app/1.0'});
      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body) as Map<String, dynamic>;
        final addr = (data['address'] ?? {}) as Map<String, dynamic>;

        addressNameC.text = (data['display_name'] ?? '') as String;
        addressLine1C.text = _firstNonEmpty([addr['road'], addr['pedestrian'], addr['neighbourhood'], addr['suburb']]);
        addressLine2C.text = _firstNonEmpty([addr['house_number'], addr['hamlet']]);
        cityC.text = _firstNonEmpty([addr['city'], addr['town'], addr['village']]);
        stateC.text = _firstNonEmpty([addr['state'], addr['province']]);
        countryC.text = (addr['country'] ?? '') as String;
        postalC.text = (addr['postcode'] ?? '') as String;
      }
    } catch (_) {
      /* ignore reverse failures silently */
    }
  }

  String _firstNonEmpty(List<dynamic> parts) {
    for (final p in parts) {
      final s = (p ?? '').toString();
      if (s.trim().isNotEmpty) return s;
    }
    return '';
  }

  void onAddressQueryChanged(String q) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () async {
      if (q.trim().isEmpty) {
        suggestions.clear();
        return;
      }
      try {
        final url = Uri.parse('https://nominatim.openstreetmap.org/search?q=${Uri.encodeQueryComponent(q)}&format=json&addressdetails=1&limit=8');
        final resp = await http.get(url, headers: {'User-Agent': 'cutcy-app/1.0'});
        if (resp.statusCode == 200) {
          final list = jsonDecode(resp.body) as List<dynamic>;
          suggestions.value = list.cast<Map<String, dynamic>>();
        }
      } catch (_) {
        /* ignore */
      }
    });
  }

  void selectSuggestion(Map<String, dynamic> s) {
    try {
      final lat = double.tryParse((s['lat'] ?? '').toString()) ?? selectedLatLng.value.latitude;
      final lon = double.tryParse((s['lon'] ?? '').toString()) ?? selectedLatLng.value.longitude;
      selectedLatLng.value = LatLng(lat, lon);

      final addr = (s['address'] ?? {}) as Map<String, dynamic>;
      addressNameC.text = (s['display_name'] ?? '') as String;
      addressLine1C.text = _firstNonEmpty([addr['road'], addr['pedestrian'], addr['neighbourhood'], addr['suburb']]);
      addressLine2C.text = _firstNonEmpty([addr['house_number'], addr['hamlet']]);
      cityC.text = _firstNonEmpty([addr['city'], addr['town'], addr['village']]);
      stateC.text = _firstNonEmpty([addr['state'], addr['province']]);
      countryC.text = (addr['country'] ?? '') as String;
      postalC.text = (addr['postcode'] ?? '') as String;
      suggestions.clear();
    } catch (_) {
      /* ignore */
    }
  }

  // =============== Submit ===============

  Future<void> submitProfile() async {
    final first = firstNameC.text.trim();
    final last = lastNameC.text.trim();
    final phone = phoneC.text.trim();

    if ([first, last, phone].any((e) => e.isEmpty)) {
      showCustomSnackbar(title: 'Missing info', message: 'First name, last name and phone are required.', icon: Icons.error_outline);
      return;
    }
    if (selectedHairType.value == null || selectedHairLength.value == null) {
      showCustomSnackbar(title: 'Hair details', message: 'Please select hair type and hair length.', icon: Icons.content_cut);
      return;
    }

    try {
      isLoading.value = true;

      final body = {
        "firstName": first,
        "lastName": last,
        "phoneNumber": phone,
        "gender": gender.value, // "MALE" | "FEMALE" | "OTHER"
        "hairTypeId": selectedHairType.value!.id,
        "hairLengthId": selectedHairLength.value!.id,
        "latitude": selectedLatLng.value.latitude,
        "longitude": selectedLatLng.value.longitude,
        "address": addressNameC.text.trim(),
        "addressLine1": addressLine1C.text.trim(),
        "addressLine2": addressLine2C.text.trim(),
        "city": cityC.text.trim(),
        "state": stateC.text.trim(),
        "country": countryC.text.trim(),
        "postalcode": postalC.text.trim(),
        "deviceToken": "abcd", // fill from FCM if you have it
        "deviceType": Platform.isAndroid ? "ANDROID" : "IOS",
      };

      final res = await apiService.request(
        ApiConfig.userCreateProfile, // POST /user/auth/userCreateProfile
        method: "POST",
        body: body,
      );

      showCustomSnackbar(title: 'Profile created', message: 'Your profile has been set up.', icon: Icons.check_circle_outline);
      authC.userModel = UserModel.fromJson(res);

      Get.offAll(() => MainScreen());
      // Get.back();
    } catch (e) {
      showCustomSnackbar(title: 'Create failed', message: e.toString(), icon: Icons.error_outline);
    } finally {
      isLoading.value = false;
    }
  }
}
