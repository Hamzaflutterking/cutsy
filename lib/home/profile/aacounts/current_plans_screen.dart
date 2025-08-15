// ignore_for_file: use_key_in_widget_constructors, deprecated_member_use

import 'package:cutcy/constants/constants.dart';
import 'package:cutcy/home/profile/aacounts/get_membership_screen.dart';
import 'package:cutcy/home/profile/aacounts/plan_controller.dart';
import 'package:cutcy/widgets/AppButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CurrentPlanScreen extends StatelessWidget {
  final PlanController _controller = Get.put(PlanController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text('Current Plan', style: TextStyle(color: white)),
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
            // Plan info
            Text(
              'Current Plan',
              style: TextStyle(color: white, fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.h),
            Obx(
              () => Text(
                '${_controller.currentPlan.value} ${_controller.planPrice.value}',
                style: TextStyle(color: white, fontSize: 16.sp),
              ),
            ),
            SizedBox(height: 20.h),

            // Plan features
            Container(
              height: 230,
              decoration: BoxDecoration(color: ksecondaryColor, borderRadius: BorderRadius.circular(20.r)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Enjoy these great features in Cutsy with the Free Plan:',
                      style: TextStyle(color: white, fontSize: 14.sp),
                    ),
                    SizedBox(height: 10.h),
                    Obx(
                      () => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _controller.planFeatures.map((feature) {
                          return Row(
                            children: [
                              Icon(Icons.check_circle, color: kprimaryColor, size: 18),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: Text(
                                  feature,
                                  style: TextStyle(color: white, fontSize: 14.sp),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            10.verticalSpace,
            Text(
              'Have any trouble? Please contact ',
              style: TextStyle(color: white.withOpacity(0.6), fontSize: 12.sp),
            ),
            GestureDetector(
              onTap: () {
                // Add navigation to support screen here
              },
              child: Text(
                'support',
                style: TextStyle(color: kprimaryColor, fontSize: 12.sp, fontWeight: FontWeight.bold),
              ),
            ),
            Spacer(),

            // Trouble link
            SizedBox(height: 20.h),

            // Change Plan Button
            SizedBox(
              width: double.infinity,
              child: AuthButton(
                text: "Change Plan",
                onTap: () {
                  Get.to(() => GetMembershipScreen());
                },
              ),
            ),
            SizedBox(height: 50.h),
          ],
        ),
      ),
    );
  }
}
