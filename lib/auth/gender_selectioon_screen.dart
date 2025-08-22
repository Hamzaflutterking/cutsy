// ignore_for_file: deprecated_member_use

import 'package:cutcy/auth/auth_controller.dart';
import 'package:cutcy/constants/constants.dart';
import 'package:cutcy/widgets/AppButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class GenderSelectionScreen extends StatelessWidget {
  GenderSelectionScreen({super.key});
  final AuthController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BackButton(color: white),
              Text(
                "Select your gender",
                style: TextStyle(color: white, fontSize: 22.sp, fontWeight: FontWeight.bold),
              ),
              40.verticalSpace,

              // Female Option
              GestureDetector(
                onTap: () => controller.selectGender('female'),
                child: Obx(
                  () => Container(
                    padding: EdgeInsets.all(30.w),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: controller.selectedGender.value == 'female' ? kprimaryColor : Colors.transparent, width: 2),
                    ),
                    child: Image.asset('assets/images/Group 1000000932.png', height: 130.h),
                  ),
                ),
              ),

              Text(
                'OR',
                style: TextStyle(color: Colors.white70, fontSize: 16.sp),
              ),

              // Male Option
              GestureDetector(
                onTap: () => controller.selectGender('male'),
                child: Obx(
                  () => Container(
                    padding: EdgeInsets.all(30.w),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: controller.selectedGender.value == 'male' ? kprimaryColor : Colors.transparent, width: 2),
                    ),
                    child: Image.asset('assets/images/Group 1000000933.png', height: 130.h),
                  ),
                ),
              ),
              40.verticalSpace,
              // Continue Button
              AuthButton(
                textColor: black,
                text: "Continue",
                onTap: controller.continueFromGenderSelection,
                width: 220.w,

                margin: EdgeInsets.symmetric(horizontal: 24.w),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
