// ignore_for_file: use_key_in_widget_constructors, avoid_print

import 'package:cutcy/constants/constants.dart';
import 'package:cutcy/widgets/AppButton.dart';
import 'package:cutcy/widgets/border_text_field.dart'; // Import the BorderTextField
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ResetPasswordController extends GetxController {
  var currentPassword = ''.obs;
  var newPassword = ''.obs;
  var confirmPassword = ''.obs;

  void resetPassword() {
    // Implement reset password logic here
    print('Password Reset: ${currentPassword.value}, ${newPassword.value}, ${confirmPassword.value}');
  }
}

class ChangePasswordScreen extends StatelessWidget {
  final ResetPasswordController _controller = Get.put(ResetPasswordController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text('Reset Password', style: TextStyle(color: white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current Password field
            BorderTextField(
              controller: TextEditingController(text: _controller.currentPassword.value),
              hint: 'Current Password',
              obscureText: true,
              enableVisibilityToggle: true,
              onChanged: (value) => _controller.currentPassword.value = value,
            ),
            SizedBox(height: 20.h),

            // New Password field
            BorderTextField(
              controller: TextEditingController(text: _controller.newPassword.value),
              hint: 'New Password',
              obscureText: true,
              enableVisibilityToggle: true,
              onChanged: (value) => _controller.newPassword.value = value,
            ),
            SizedBox(height: 20.h),

            // Confirm New Password field
            BorderTextField(
              controller: TextEditingController(text: _controller.confirmPassword.value),
              hint: 'Confirm New Password',
              obscureText: true,
              enableVisibilityToggle: true,
              onChanged: (value) => _controller.confirmPassword.value = value,
            ),
            Spacer(),

            // Save button
            AuthButton(
              text: 'Save',
              onTap: () {
                Get.back();
                _controller.resetPassword();
              },
            ),
          ],
        ),
      ),
    );
  }
}
