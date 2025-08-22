import 'package:cutcy/auth/auth_controller.dart';
import 'package:cutcy/auth/gender_selectioon_screen.dart';
import 'package:cutcy/constants/constants.dart';
import 'package:cutcy/widgets/AppButton.dart';
import 'package:cutcy/widgets/AppTextFiled.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class VerifyOtpScreen extends StatelessWidget {
  final bool isFromForgetPassword;
  VerifyOtpScreen({super.key, required this.isFromForgetPassword});

  final AuthController authC = Get.find(); // email & password already filled from sign up

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
                BackButton(color: white),

                // Title
                Text(
                  "Verify OTP",
                  style: TextStyle(color: white, fontSize: 32.sp, fontWeight: FontWeight.bold),
                ),
                12.verticalSpace,
                Text(
                  "Enter the 4-digit code we sent to",
                  style: TextStyle(color: white.withValues(alpha: 0.8), fontSize: 14.sp),
                ),
                4.verticalSpace,
                Text(
                  authC.emailController.text,
                  style: TextStyle(color: kprimaryColor, fontSize: 14.sp, fontWeight: FontWeight.w600),
                ),

                32.verticalSpace,

                // OTP field (uses your AuthTextField typography & paddings)
                AuthTextField(controller: authC.otpController, hintText: 'Enter 4-digit code', keyboardType: TextInputType.number),

                12.verticalSpace,

                // Timer + Resend Row
                Obx(
                  () => Row(
                    children: [
                      Icon(Icons.timer_outlined, size: 18.sp, color: white.withValues(alpha: 0.9)),
                      6.horizontalSpace,
                      Text(
                        authC.canResend ? 'You can resend a new code.' : 'Resend in ${authC.mmss}',
                        style: TextStyle(color: white.withValues(alpha: 0.9), fontSize: 13.sp),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: authC.canResend && !authC.isLoading.value
                            ? authC.resendOtp
                            : null, //authC.canResend && !authC.isLoading.value ? () => authC.resendOtp(email) : null,
                        child: Text(
                          'Resend OTP',
                          style: TextStyle(
                            color: authC.canResend ? kprimaryColor : white.withValues(alpha: 0.4),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                24.verticalSpace,

                // Verify button
                Obx(
                  () => AuthButton(
                    text: authC.isLoading.value ? 'Please wait…' : 'Verify & Continue',
                    onTap: authC.isLoading.value ? null : () => isFromForgetPassword ? authC.verifyOtpForgetPassword() : authC.verifyOtp(),
                    textColor: black,
                  ),
                ),

                20.verticalSpace,

                // Change email
                Center(
                  child: TextButton(
                    onPressed: () => Get.back(),
                    child: RichText(
                      text: TextSpan(
                        text: "Entered the wrong email? ",
                        style: TextStyle(color: white),
                        children: [
                          TextSpan(
                            text: "Change it.",
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
