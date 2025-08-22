import 'package:cutcy/auth/auth_controller.dart';
import 'package:cutcy/constants/constants.dart';
import 'package:cutcy/widgets/AppButton.dart';
import 'package:cutcy/widgets/AppTextFiled.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController controller = Get.put(AuthController());

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: const Text('Forgot Password', style: TextStyle(color: white)),
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
                  "Enter Your Email",
                  style: TextStyle(color: white, fontSize: 32.sp, fontWeight: FontWeight.bold),
                ),
                32.verticalSpace,

                // Email Field for Password Reset
                AuthTextField(controller: controller.emailController, hintText: 'Enter your Email', keyboardType: TextInputType.emailAddress),
                16.verticalSpace,

                // Send OTP Button
                Obx(
                  () => AuthButton(
                    text: 'Send OTP',
                    isLoading: controller.isLoading.value,
                    onTap: () {
                      controller.forgetPassword();
                    },
                    textColor: black,
                  ),
                ),
                20.verticalSpace,

                // Already Have Account Link
                Center(
                  child: TextButton(
                    onPressed: () {
                      Get.back(); // Navigate back to the previous screen (Login)
                    },
                    child: RichText(
                      text: TextSpan(
                        text: "Remembered your password? ",
                        style: TextStyle(color: white),
                        children: [
                          TextSpan(
                            text: "Login Now.",
                            style: TextStyle(color: kprimaryColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
