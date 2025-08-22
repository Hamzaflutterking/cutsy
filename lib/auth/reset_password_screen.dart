import 'package:cutcy/auth/auth_controller.dart';
import 'package:cutcy/constants/constants.dart';
import 'package:cutcy/widgets/AppButton.dart';
import 'package:cutcy/widgets/AppTextFiled.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResetPasswordScreen extends StatelessWidget {
  ResetPasswordScreen({super.key});
  final AuthController controller = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: const Text('Reset Password', style: TextStyle(color: white)),
        centerTitle: true,
        leading: BackButton(color: white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Enter New Password",
                  style: TextStyle(color: white, fontSize: 32.sp, fontWeight: FontWeight.bold),
                ),
                32.verticalSpace,

                // New Password Field with suffix icon
                AuthTextField(controller: controller.passwordController, hintText: 'New Password', obscureText: true, enableVisibilityToggle: true),
                16.verticalSpace,

                // Confirm New Password Field with suffix icon
                AuthTextField(
                  controller: controller.confirmPasswordController,
                  hintText: 'Confirm New Password',
                  // obscureText: !controller.showConfirmPassword.value,
                  obscureText: true,
                  enableVisibilityToggle: true,
                ),
                16.verticalSpace,

                Obx(
                  () => AuthButton(
                    text: controller.isLoading.value ? 'Please wait…' : 'Reset Password',
                    onTap: controller.isLoading.value ? null : controller.resetPassword,
                    textColor: black,
                  ),
                ),
                20.verticalSpace,

                // Already Have Account Link
              ],
            ),
          ),
        ),
      ),
    );
  }
}
