import 'dart:async';
import 'dart:developer' as dev;

import 'package:cutcy/auth/create_profile/create_profile_screen.dart';
import 'package:cutcy/auth/gender_selectioon_screen.dart';
import 'package:cutcy/auth/hair_selection_screen.dart';
import 'package:cutcy/auth/login_screen.dart';
import 'package:cutcy/auth/otp_screen.dart';
import 'package:cutcy/auth/reset_password_screen.dart';
import 'package:cutcy/auth/user_model.dart';
import 'package:cutcy/constants/helper.dart';
import 'package:cutcy/home/profile/aacounts/change_password_screen.dart';
import 'package:cutcy/locations/map_screen.dart';
import 'package:cutcy/main.dart';
import 'package:cutcy/navbar/bottom_nav_controller.dart';
import 'package:cutcy/navbar/main_navbar.dart';
import 'package:cutcy/services/api_configs.dart';
import 'package:cutcy/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  // ✅ LOGIN
  final emailController = TextEditingController(text: "zz@yopmail.com");
  final passwordController = TextEditingController(text: "Appa@123");
  final rememberMe = false.obs;
  UserModel? userModel;

  // ✅ SIGN UP
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final agreeToTerms = false.obs;
  final passwordVisible = false.obs;
  final confirmPasswordVisible = false.obs;
  final isLoading = false.obs;

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

  final otpController = TextEditingController();

  // 2 minutes = 120 seconds
  final secondsLeft = 60.obs;
  Timer? _timer;

  String get mmss {
    final m = (secondsLeft.value ~/ 60).toString().padLeft(2, '0');
    final s = (secondsLeft.value % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  bool get canResend => secondsLeft.value == 0;

  void startTimer() {
    _timer?.cancel();
    secondsLeft.value = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (secondsLeft.value == 0) {
        t.cancel();
      } else {
        secondsLeft.value--;
      }
    });
  }

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    // Basic validation
    if (email.isEmpty || password.isEmpty) {
      showCustomSnackbar(title: 'Error', message: 'Email and password cannot be empty.', icon: Icons.warning_amber_rounded);
      return;
    }

    try {
      isLoading.value = true;

      final res = await apiService.request(
        ApiConfig.userLogin, // POST /user/auth/login
        method: "POST",
        body: {"email": email, "password": password},
      );
      userModel = UserModel.fromJson(res);
      // Store token for subsequent authed requests
      apiService.setToken(userModel?.data?.userToken ?? ""); // uses your existing setter from ApiService
      StorageService.to.saveString("token", userModel?.data?.userToken ?? "");

      // (Optional) persist to local storage if you have it
      // await LocalStorage.saveToken(token);

      showCustomSnackbar(title: 'Welcome back', message: 'Logged in as $email', icon: Icons.check_circle);

      // Route based on profile completion
      if (!userModel!.data!.isCreatedProfile!) {
        // Go to your onboarding / create profile flow
        // Get.offAll(() => GenderSelectionScreen());
        Get.offAll(() => CreateProfileScreen());
      } else {
        Get.offAll(() => MainScreen());
      }
    } catch (e) {
      showCustomSnackbar(title: 'Login failed', message: e.toString(), icon: Icons.error_outline);
    } finally {
      isLoading.value = false;
    }
  }

  void signup() async {
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
    isLoading.value = true; // start spinner
    try {
      await apiService.request(ApiConfig.userSignUp, method: "POST", body: {"email": emailController.text.trim()});
      startTimer(); // <-- start initial cooldown
      Get.to(() => VerifyOtpScreen(isFromForgetPassword: false));

      showCustomSnackbar(title: 'Success', message: 'Signed up successfully as $firstName $lastName', icon: Icons.check_circle);
    } catch (e) {
      showCustomSnackbar(title: 'Error', message: 'An error occurred during signup: $e', icon: Icons.error);
      return;
    } finally {
      isLoading.value = false; // stop spinner
    }

    // Get.to(() => GenderSelectionScreen());
    // Get.to(() => VerifyOtpScreen(isFromForgetPassword: false));
  }

  Future<void> verifyOtp() async {
    if (otpController.text.trim().length < 4) {
      showCustomSnackbar(title: 'Invalid OTP', message: 'Please enter the 4-digit code.', icon: Icons.pin);
      return;
    }
    try {
      isLoading.value = true;
      final res = await apiService.request(
        ApiConfig.userVerifyOtp,
        method: "POST",

        body: {"email": emailController.text.trim(), "otp": otpController.text.trim(), "password": confirmPasswordController.text.trim()},
      );

      showCustomSnackbar(title: 'Verified', message: 'Your email has been verified.', icon: Icons.verified_outlined);
    } catch (e) {
      showCustomSnackbar(title: 'Verification failed', message: e.toString(), icon: Icons.error_outline);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyOtpForgetPassword() async {
    if (otpController.text.trim().length < 4) {
      showCustomSnackbar(title: 'Invalid OTP', message: 'Please enter the 4-digit code.', icon: Icons.pin);
      return;
    }
    try {
      isLoading.value = true;
      final res = await apiService.request(
        ApiConfig.userVerifyOtp,
        method: "POST",

        body: {"email": emailController.text.trim(), "otp": otpController.text.trim()},
      );
      StorageService.to.saveString("token", res['data']['userToken']);
      Get.to(() => ResetPasswordScreen());

      showCustomSnackbar(title: 'Verified', message: 'Your Otp has been Verified', icon: Icons.verified_outlined);
    } catch (e) {
      showCustomSnackbar(title: 'Verification failed', message: e.toString(), icon: Icons.error_outline);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> forgetPassword() async {
    final email = emailController.text.trim();

    // Basic email validation
    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (email.isEmpty || !emailRegex.hasMatch(email)) {
      showCustomSnackbar(title: 'Invalid email', message: 'Please enter a valid email address.', icon: Icons.alternate_email);
      return;
    }

    try {
      isLoading.value = true;

      await apiService.request(
        ApiConfig.userForgetPassword, // should resolve to /user/auth/forgetPassword
        method: "POST",
        body: {"email": email},
      );
      startTimer(); // <-- start initial cooldown

      Get.to(() => VerifyOtpScreen(isFromForgetPassword: true)); // Navigate to Reset Password Screen

      // Optional: inspect res if you need to branch on status/message
      // e.g., if (res['success'] == true) { ... }

      showCustomSnackbar(
        title: 'Email sent',
        message: 'If an account exists, we\'ve sent a reset code to $email.',
        icon: Icons.mark_email_read_outlined,
      );

      // Optional: keep email for next step (reset/verify flow)
      // resetEmail.value = email;
    } catch (e) {
      showCustomSnackbar(title: 'Request failed', message: e.toString(), icon: Icons.error_outline);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resendOtp() async {
    final email = emailController.text.trim();

    // Basic email validation
    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (email.isEmpty || !emailRegex.hasMatch(email)) {
      showCustomSnackbar(title: 'Invalid email', message: 'Please enter a valid email address.', icon: Icons.alternate_email);
      return;
    }
    // ⏱️ Start cooldown right away
    startTimer();
    try {
      isLoading.value = true;

      await apiService.request(
        ApiConfig.userResendOtp, // maps to /user/auth/resendOtp (POST)
        method: "POST",
        body: {"email": email},
      );

      showCustomSnackbar(title: 'OTP re-sent', message: 'We\'ve sent a new 4-digit code to $email.', icon: Icons.mark_email_unread_outlined);
    } catch (e) {
      // ❌ Undo cooldown on failure so user can retry
      secondsLeft.value = 0;
      showCustomSnackbar(title: 'Resend failed', message: e.toString(), icon: Icons.error_outline);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resetPassword() async {
    final newPwd = passwordController.text.trim();
    final confirmPwd = confirmPasswordController.text.trim();

    // Basic validations
    if (newPwd.isEmpty || confirmPwd.isEmpty) {
      showCustomSnackbar(title: 'Missing fields', message: 'Please enter and confirm your new password.', icon: Icons.lock);
      return;
    }
    if (newPwd != confirmPwd) {
      showCustomSnackbar(title: 'Password mismatch', message: 'New password and confirm password do not match.', icon: Icons.error_outline);
      return;
    }

    // Optional: strength check (8+ chars, upper, lower, digit, special)
    final strong = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z0-9]).{8,}$');
    if (!strong.hasMatch(newPwd)) {
      showCustomSnackbar(title: 'Weak password', message: 'Use 8+ chars with upper, lower, number, and symbol.', icon: Icons.security);
      return;
    }
    apiService.setToken(StorageService.to.getString("token") ?? ""); // Set token for authenticated requests

    try {
      isLoading.value = true;

      await apiService.request(
        ApiConfig.userResetPassword, // PUT /user/auth/resetPassword
        method: "PUT",
        body: {"password": newPwd},
      );

      showCustomSnackbar(title: 'Password updated', message: 'Your password has been reset successfully.', icon: Icons.lock_open);

      // Optionally clear OTP + cooldown and take user to Login
      otpController.clear();
      secondsLeft.value = 0;
      Get.offAll(() => LoginScreen());
    } catch (e) {
      showCustomSnackbar(title: 'Reset failed', message: e.toString(), icon: Icons.error_outline);
    } finally {
      isLoading.value = false;
    }
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
