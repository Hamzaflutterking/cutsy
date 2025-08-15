import 'dart:io';
import 'package:cutcy/auth/login_screen.dart';
import 'package:cutcy/widgets/Appdilogbox.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';

class ProfileController extends GetxController {
  // User details
  final userName = 'Luna Woods'.obs;
  final avatarPath = 'assets/images/young-hispanic-haidresser-and-hairstylist-standing-2024-10-18-17-47-23-utc 1.png'.obs;
  final Rx<File?> avatarFile = Rx<File?>(null);

  final email = 'lunawoods@gmail.com'.obs;
  final phone = '+1 (416) 555-0199'.obs;
  final countryCode = '+1'.obs;
  final countryFlag = '🇨🇦'.obs;
  final gender = 'Female'.obs;

  // Permission states
  final RxBool pushNotificationsEnabled = false.obs;
  final RxBool locationEnabled = true.obs;

  // Toggle methods for permissions
  void togglePushNotifications(bool value) {
    pushNotificationsEnabled.value = value;
    // Add actual push notification permission handling here if needed
  }

  void toggleLocation(bool value) {
    locationEnabled.value = value;
    // Add actual location permission handling here if needed
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
          Get.to(() => LoginScreen());
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
}
