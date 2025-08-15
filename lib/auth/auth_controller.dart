import 'package:cutcy/auth/gender_selectioon_screen.dart';
import 'package:cutcy/auth/hair_selection_screen.dart';
import 'package:cutcy/constants/helper.dart';
import 'package:cutcy/locations/map_screen.dart';
import 'package:cutcy/navbar/bottom_nav_controller.dart';
import 'package:cutcy/navbar/main_navbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  // ✅ LOGIN
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final rememberMe = false.obs;

  // ✅ SIGN UP
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final agreeToTerms = false.obs;
  final passwordVisible = false.obs;
  final confirmPasswordVisible = false.obs;

  // ✅ Gender
  final selectedGender = ''.obs;

  // ✅ Hair Type & Length
  final selectedHairType = ''.obs;
  final selectedHairLength = ''.obs;

  final hairTypes = ['Straight', 'Wavy', 'Curly', 'Coily'];
  final hairLengths = [
    'Very Short (Buzz / Tapered)',
    'Short (Above Ears / Crop Cut)',
    'Medium (Ear to Chin Length)',
    'Medium-Long (Chin to Shoulders)',
    'Long (Shoulders to Mid-Back)',
    'Extra Long (Below Mid-Back)',
  ];

  void toggleRememberMe() => rememberMe.toggle();
  void toggleAgreeToTerms() => agreeToTerms.toggle();
  void togglePasswordVisibility() => passwordVisible.toggle();
  void toggleConfirmPasswordVisibility() => confirmPasswordVisible.toggle();
  void selectGender(String gender) => selectedGender.value = gender;

  void login() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showCustomSnackbar(title: 'Error', message: 'Email and password cannot be empty', icon: Icons.warning_amber_rounded);
      return;
    }

    showCustomSnackbar(title: 'Success', message: 'Logged in as $email', icon: Icons.check_circle);

    // ensure nav controller exists
    final navC = Get.isRegistered<BottomNavController>() ? Get.find<BottomNavController>() : Get.put(BottomNavController());

    navC.changeIndex(0);
    Get.offAll(() => MainScreen());
  }

  void signup() {
    if (!agreeToTerms.value) {
      showCustomSnackbar(title: 'Terms Required', message: 'You must agree to the terms and conditions.', icon: Icons.info_outline);
      return;
    }

    final firstName = firstNameController.text.trim();
    final lastName = lastNameController.text.trim();
    final email = emailController.text.trim();
    final phone = phoneController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if ([firstName, lastName, email, phone, password, confirmPassword].any((e) => e.isEmpty)) {
      showCustomSnackbar(title: 'Error', message: 'All fields are required.', icon: Icons.error);
      return;
    }

    if (password != confirmPassword) {
      showCustomSnackbar(title: 'Error', message: 'Passwords do not match.', icon: Icons.lock);
      return;
    }

    Get.to(() => GenderSelectionScreen());
  }

  void continueWithGoogle() {
    showCustomSnackbar(title: 'Google', message: 'Google login tapped', icon: Icons.g_mobiledata);
  }

  void continueWithApple() {
    showCustomSnackbar(title: 'Apple', message: 'Apple login tapped', icon: Icons.apple);
  }

  void continueFromGenderSelection() {
    if (selectedGender.value.isEmpty) {
      showCustomSnackbar(title: 'Error', message: 'Please select a gender', icon: Icons.transgender);
      return;
    }

    Get.to(() => HairSelectionScreen());
  }

  void saveHairSelection() {
    if (selectedHairType.value.isEmpty || selectedHairLength.value.isEmpty) {
      showCustomSnackbar(title: 'Error', message: 'Please select both hair type and length.', icon: Icons.warning);
      return;
    }

    showCustomSnackbar(title: 'Saved', message: 'Hair type: ${selectedHairType.value}\nHair length: ${selectedHairLength.value}', icon: Icons.check);

    // Navigate to Map screen after a short delay (optional)
    Future.delayed(const Duration(milliseconds: 300), () {
      Get.to(() => MapScreen());
    });
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
