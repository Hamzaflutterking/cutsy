// ignore_for_file: deprecated_member_use

import 'package:cutcy/auth/auth_controller.dart';
import 'package:cutcy/auth/forget_password.dart';
import 'package:cutcy/auth/sign_up_screen.dart';
import 'package:cutcy/constants/constants.dart';
import 'package:cutcy/widgets/AppButton.dart';
import 'package:cutcy/widgets/AppTextFiled.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final AuthController controller = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: true, // ✅ allow screen to adjust on keyboard open
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 36.0),
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height - 72),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Log into\nyour account",
                    style: TextStyle(color: white, fontSize: 32.sp, fontWeight: FontWeight.bold, height: 1),
                  ),
                  36.verticalSpace,

                  // Email Field
                  AuthTextField(controller: controller.emailController, hintText: 'Username/Email'),

                  16.verticalSpace,

                  // Password Field
                  AuthTextField(
                    controller: controller.passwordController,
                    hintText: 'Password',
                    obscureText: true,
                    enableVisibilityToggle: true,
                    suffix: Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(color: Colors.grey.shade400, fontSize: 13.sp),
                      ),
                    ),
                  ),

                  16.verticalSpace,

                  // Remember Me Checkbox
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(
                        () => GestureDetector(
                          onTap: () => controller.toggleRememberMe(),
                          behavior: HitTestBehavior.opaque,
                          child: Row(
                            children: [
                              Checkbox(
                                value: controller.rememberMe.value,
                                onChanged: (_) => controller.toggleRememberMe(),
                                activeColor: Colors.yellow,
                              ),
                              Text('Remember Me', style: TextStyle(color: white)),
                            ],
                          ),
                        ),
                      ),

                      GestureDetector(
                        onTap: () => Get.to(() => ForgotPasswordScreen()), // Navigate to Forget Password Screen
                        child: Text(
                          'Forgot Password?',

                          style: TextStyle(color: white, fontSize: 13.sp, decoration: TextDecoration.underline, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),

                  16.verticalSpace,

                  // Login Button
                  AuthButton(textColor: black, text: "Log in", onTap: controller.login),

                  20.verticalSpace,

                  // Divider
                  Row(
                    children: [
                      Expanded(child: Divider(color: Colors.grey.shade700)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text("or", style: TextStyle(color: grey)),
                      ),
                      Expanded(child: Divider(color: Colors.grey.shade700)),
                    ],
                  ),

                  20.verticalSpace,

                  // Google Button
                  OutlinedButton.icon(
                    onPressed: controller.continueWithGoogle,
                    icon: Icon(Icons.g_mobiledata, color: white),
                    label: Text('Continue with Google', style: TextStyle(color: white)),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: white),
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      minimumSize: Size(double.infinity, 0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // 👈 Set your radius here
                      ),
                    ),
                  ),

                  12.verticalSpace,

                  // Apple Button
                  OutlinedButton.icon(
                    onPressed: controller.continueWithApple,
                    icon: Icon(Icons.apple, color: white),
                    label: Text('Continue with Apple', style: TextStyle(color: white)),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: white),
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      minimumSize: Size(double.infinity, 0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // 👈 Set your radius here
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Sign Up Navigation
                  Center(
                    child: TextButton(
                      onPressed: () => Get.to(() => SignUpScreen()),
                      child: RichText(
                        text: TextSpan(
                          text: "Don’t have an account? ",
                          style: TextStyle(color: white),
                          children: [
                            TextSpan(
                              text: "Sign Up Now.",
                              style: TextStyle(color: Colors.yellow),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  50.verticalSpace,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
