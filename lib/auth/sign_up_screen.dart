import 'package:cutcy/auth/auth_controller.dart';
import 'package:cutcy/constants/constants.dart';
import 'package:cutcy/widgets/AppButton.dart';
import 'package:cutcy/widgets/AppTextFiled.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});
  final AuthController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 36.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Sign Up",
                  style: TextStyle(color: white, fontSize: 32.sp, fontWeight: FontWeight.bold),
                ),
                32.verticalSpace,

                Row(
                  children: [
                    Expanded(
                      child: AuthTextField(controller: controller.firstNameController, hintText: 'Luna'),
                    ),
                    12.horizontalSpace,
                    Expanded(
                      child: AuthTextField(controller: controller.lastNameController, hintText: 'Woods'),
                    ),
                  ],
                ),

                16.verticalSpace,
                AuthTextField(controller: controller.emailController, hintText: 'Email', keyboardType: TextInputType.emailAddress),
                16.verticalSpace,
                AuthTextField(controller: controller.phoneController, hintText: 'Phone', keyboardType: TextInputType.phone),
                16.verticalSpace,
                Obx(
                  () => AuthTextField(
                    controller: controller.passwordController,
                    hintText: 'Password',
                    obscureText: !controller.passwordVisible.value,
                    enableVisibilityToggle: true,
                    suffix: IconButton(
                      icon: Icon(controller.passwordVisible.value ? Icons.visibility : Icons.visibility_off, color: kprimaryColor),
                      onPressed: controller.togglePasswordVisibility,
                    ),
                  ),
                ),
                16.verticalSpace,
                Obx(
                  () => AuthTextField(
                    controller: controller.confirmPasswordController,
                    hintText: 'Confirm Password',
                    obscureText: !controller.confirmPasswordVisible.value,
                    enableVisibilityToggle: true,
                    suffix: IconButton(
                      icon: Icon(controller.confirmPasswordVisible.value ? Icons.visibility : Icons.visibility_off, color: kprimaryColor),
                      onPressed: controller.toggleConfirmPasswordVisibility,
                    ),
                  ),
                ),

                20.verticalSpace,
                Obx(
                  () => GestureDetector(
                    onTap: () => controller.toggleAgreeToTerms(),
                    child: Row(
                      children: [
                        Checkbox(
                          value: controller.agreeToTerms.value,
                          onChanged: (_) => controller.toggleAgreeToTerms(),
                          activeColor: kprimaryColor,
                          checkColor: black,
                        ),
                        Expanded(
                          child: Text(
                            'I agree to the Terms and Conditions',
                            style: TextStyle(color: white, fontSize: 14.sp),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                20.verticalSpace,
                // AuthButton(text: 'Sign Up', onTap: controller.signup, textColor: black),
                Obx(
                  () => AuthButton(
                    text: 'Sign Up',
                    onTap: controller.signup,
                    textColor: black,
                    isLoading: controller.isLoading.value, // NEW
                  ),
                ),

                20.verticalSpace,
                Center(
                  child: TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: RichText(
                      text: TextSpan(
                        text: "Already have an account? ",
                        style: TextStyle(color: white),
                        children: [
                          TextSpan(
                            text: "Sign In Now.",
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
