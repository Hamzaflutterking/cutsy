import 'dart:developer' as dev;
import 'dart:io';
import 'package:cutcy/auth/auth_controller.dart';
import 'package:cutcy/auth/login_screen.dart';
import 'package:cutcy/auth/user_model.dart';
import 'package:cutcy/constants/helper.dart';
import 'package:cutcy/main.dart';
import 'package:cutcy/services/api_configs.dart';
import 'package:cutcy/shared_preferences.dart';
import 'package:cutcy/widgets/Appdilogbox.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';

class ProfileController extends GetxController {
  // Permission states
  final RxBool pushNotificationsEnabled = false.obs;
  final RxBool locationEnabled = true.obs;

  // ✅ Updated user details to include first and last name separately
  final firstName = ''.obs;
  final lastName = ''.obs;
  final emailLocal = ''.obs;
  final phoneLocal = ''.obs;
  final genderLocal = 'Male'.obs;
  final userImageLocal = ''.obs;
  final Rx<File?> avatarFile = Rx<File?>(null);

  // For backward compatibility with existing UI
  final avatarPath = 'assets/images/young-hispanic-haidresser-and-hairstylist-standing-2024-10-18-17-47-23-utc 1.png'.obs;

  // Country/phone related
  final countryCode = '+1'.obs;
  final countryFlag = '🇺🇸'.obs;

  // Loading states
  final isLoading = false.obs;
  final isUpdating = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserProfile();
    _loadPermissionPreferences();
  }

  // ✅ Updated loadUserProfile to handle name splitting
  void loadUserProfile() {
    try {
      isLoading.value = true;

      // Get data from AuthController if available
      final authC = Get.find<AuthController>();
      if (authC.userModel?.data != null) {
        final user = authC.userModel!.data!;

        // ✅ Handle name splitting
        String fullName = user.firstName ?? '';
        if (fullName.isNotEmpty) {
          List<String> nameParts = fullName.split(' ');
          firstName.value = nameParts.first;
          lastName.value = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
        } else {
          firstName.value = '';
          lastName.value = '';
        }

        emailLocal.value = user.email ?? '';
        phoneLocal.value = user.phoneNumber ?? '';

        // ✅ Normalize gender value to match dropdown options
        String userGender = user.gender ?? 'Male';
        switch (userGender.toUpperCase()) {
          case 'MALE':
            genderLocal.value = 'Male';
            break;
          case 'FEMALE':
            genderLocal.value = 'Female';
            break;
          case 'OTHER':
            genderLocal.value = 'Other';
            break;
          default:
            genderLocal.value = 'Male';
        }

        userImageLocal.value = user.image ?? '';

        // Parse country code from phone if available
        if (phoneLocal.value.isNotEmpty) {
          _parsePhoneNumber(phoneLocal.value);
        }
      } else {
        // Set default values if no auth data
        firstName.value = 'Luna';
        lastName.value = 'Woods';
        emailLocal.value = 'lunawoods@gmail.com';
        phoneLocal.value = '+1 (416) 555-0199';
        genderLocal.value = 'Male';
      }
    } catch (e) {
      dev.log('Error loading profile: $e');
      // Set default values on error
      firstName.value = 'Luna';
      lastName.value = 'Woods';
      emailLocal.value = 'lunawoods@gmail.com';
      phoneLocal.value = '+1 (416) 555-0199';
      genderLocal.value = 'Male';
    } finally {
      isLoading.value = false;
    }
  }

  // Parse phone number to extract country code
  void _parsePhoneNumber(String fullPhone) {
    if (fullPhone.startsWith('+1')) {
      countryCode.value = '+1';
      countryFlag.value = '🇺🇸';
    } else if (fullPhone.startsWith('+44')) {
      countryCode.value = '+44';
      countryFlag.value = '🇬🇧';
    } else if (fullPhone.startsWith('+91')) {
      countryCode.value = '+91';
      countryFlag.value = '🇮🇳';
    }
    // Add more country codes as needed
  }

  // ✅ Updated method to use the real API
  Future<void> updateProfile({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String gender,
  }) async {
    try {
      isUpdating.value = true;

      // Set token from storage
      apiService.setToken(StorageService.to.getString("token") ?? "");

      // Prepare the body for multipart request
      final body = <String, dynamic>{
        'firstName': firstName.trim(),
        'lastName': lastName.trim(),
        'phoneNumber': phone.trim(),
        'gender': gender.toUpperCase(),
      };

      // Make the API call using your ApiService
      final response = await apiService.request(
        ApiConfig.userEditProfile,
        method: "PATCH",
        body: body,
        singleImage: avatarFile.value,
        mediaKey: 'image',
      );

      if (response != null && (response['success'] == true || response is Map)) {
        // ✅ Update local observable values
        this.firstName.value = firstName.trim();
        this.lastName.value = lastName.trim();

        phoneLocal.value = phone.trim();
        genderLocal.value = gender;

        // Completely update AuthController UserModel
        try {
          final authC = Get.find<AuthController>();
          if (response['data'] != null) {
            // ✅ Create new UserModel from complete API response
            final updatedUserModel = UserModel.fromJson(response);

            // Replace the entire UserModel
            authC.userModel = updatedUserModel;

            // Update local image URL if changed
            if (response['data']['image'] != null) {
              userImageLocal.value = response['data']['image'];
            }

            // ✅ Save updated user data to local storage
            StorageService.to.saveString('userModel', authC.userModel!.toJson().toString());

            dev.log('✅ Complete UserModel recreated from API response');
          }
        } catch (e) {
          dev.log('Error recreating UserModel: $e');
        }

        // Clear the selected file since it's now uploaded
        avatarFile.value = null;

        showCustomSnackbar(title: 'Success', message: response['message'] ?? 'Profile updated successfully', icon: Icons.check_circle);

        Get.back(); // Go back to profile screen
      } else {
        throw Exception('Update failed: Invalid response');
      }
    } catch (e) {
      showCustomSnackbar(title: 'Error', message: 'Failed to update profile: ${e.toString()}', icon: Icons.error);
      print('Profile update error: $e');
    } finally {
      isUpdating.value = false;
    }
  }

  // ✅ Getter for full name (for backward compatibility)
  String get fullName => '${firstName.value} ${lastName.value}'.trim();

  // Permission states

  void togglePushNotifications(bool value) {
    pushNotificationsEnabled.value = value;

    // Optional: Save to local storage for persistence
    StorageService.to.saveBool('push_notifications_enabled', value);

    // Optional: Show feedback to user
    showCustomSnackbar(
      title: 'Notifications',
      message: value ? 'Push notifications enabled' : 'Push notifications disabled',
      icon: value ? Icons.notifications_active : Icons.notifications_off,
    );

    // Optional: Make API call to update server-side preference
    // _updateNotificationPreference(value);
  }

  void toggleLocation(bool value) {
    locationEnabled.value = value;

    // Optional: Save to local storage for persistence
    StorageService.to.saveBool('location_enabled', value);

    // Optional: Show feedback to user
    showCustomSnackbar(
      title: 'Location',
      message: value ? 'Location access enabled' : 'Location access disabled',
      icon: value ? Icons.location_on : Icons.location_off,
    );

    // Optional: Handle actual device permission if needed
    if (value) {
      _requestLocationPermission();
    }

    // Optional: Make API call to update server-side preference
    // _updateLocationPreference(value);
  }

  // Logout logic with confirm dialog
  void logout() {
    Get.dialog(
      CustomConfirmDialog(
        topImage: Image.asset("assets/icons/037-log out 1 (1).png", scale: 4),
        title: 'Do you want to log out?',
        message: "You'll need to log in again to access your account.",
        positiveButtonText: 'Log Out',
        negativeButtonText: 'Cancel',
        onPositive: () {
          // Clear stored data
          StorageService.to.clearAll();

          // Reset controllers
          try {
            final authC = Get.find<AuthController>();
            authC.userModel = null;
          } catch (e) {
            dev.log('AuthController not found during logout: $e');
          }

          // Navigate to login
          Get.offAll(() => LoginScreen());
        },
        onNegative: () => Get.back(),
      ),
    );
  }

  // Pick profile image
  void pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source, imageQuality: 80);
    if (picked != null) {
      avatarFile.value = File(picked.path);
    }
  }

  // Country picker
  void pickCountry(BuildContext context) {
    showCountryPicker(
      context: context,
      showPhoneCode: true,
      onSelect: (Country country) {
        countryCode.value = '+${country.phoneCode}';
        countryFlag.value = country.flagEmoji;
      },
    );
  }

  // Refresh profile data
  Future<void> refreshProfile() async {
    loadUserProfile();
  }

  // Load saved permission preferences from local storage
  void _loadPermissionPreferences() {
    pushNotificationsEnabled.value = StorageService.to.getBool('push_notifications_enabled');
    locationEnabled.value = StorageService.to.getBool('location_enabled');
  }

  // ✅ Optional: Update notification preference on server
  // Future<void> _updateNotificationPreference(bool enabled) async {
  //   try {
  //     apiService.setToken(StorageService.to.getString("token") ?? "");

  //     await apiService.request(
  //       ApiConfig.updateNotificationSettings, // You'll need to add this endpoint
  //       method: "PATCH",
  //       body: {'pushNotificationsEnabled': enabled},
  //     );

  //     print('✅ Notification preference updated on server: $enabled');
  //   } catch (e) {
  //     print('Error updating notification preference: $e');
  //   }
  // }

  // ✅ Optional: Update location preference on server
  // Future<void> _updateLocationPreference(bool enabled) async {
  //   try {
  //     apiService.setToken(StorageService.to.getString("token") ?? "");

  //     await apiService.request(
  //       ApiConfig.updateLocationSettings, // You'll need to add this endpoint
  //       method: "PATCH",
  //       body: {'locationEnabled': enabled},
  //     );

  //     print('✅ Location preference updated on server: $enabled');
  //   } catch (e) {
  //     print('Error updating location preference: $e');
  //   }
  // }

  // ✅ Optional: Request actual device location permission
  Future<void> _requestLocationPermission() async {
    try {
      // You can use permission_handler package for this
      // For now, this is a placeholder
      print('Requesting device location permission...');

      // Example with permission_handler:
      /*
    import 'package:permission_handler/permission_handler.dart';
    
    final status = await Permission.location.request();
    if (status.isGranted) {
      print('Location permission granted');
    } else {
      print('Location permission denied');
      locationEnabled.value = false;
    }
    */
    } catch (e) {
      print('Error requesting location permission: $e');
    }
  }
}
