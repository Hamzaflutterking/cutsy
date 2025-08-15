// ignore_for_file: use_key_in_widget_constructors, sized_box_for_whitespace

import 'package:cutcy/constants/constants.dart';
import 'package:cutcy/home/profile/aacounts/plan_controller.dart';
import 'package:cutcy/widgets/AppButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class GetMembershipScreen extends StatelessWidget {
  final MembershipController _controller = Get.put(MembershipController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text('Get Membership', style: TextStyle(color: white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 0.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Title
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Get more with ',
                    style: TextStyle(color: white, fontSize: 40.sp, fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: ' Cutsy Pro!',
                    style: TextStyle(color: kprimaryColor, fontSize: 35.sp, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),

            Container(
              width: 140.w,
              child: Text(
                textAlign: TextAlign.center,
                'More benefits. More value. More for you.',
                style: TextStyle(
                  color: white, // Subtext in white
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10.h),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(color: white, borderRadius: BorderRadius.circular(12.r)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(
                    () => ListView.builder(
                      shrinkWrap: true, // Makes it scrollable if needed
                      itemCount: _controller.benefits.length,
                      itemBuilder: (context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 6.h),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      _controller.benefits[index],
                                      style: TextStyle(color: Colors.black, fontSize: 12.sp),
                                    ),
                                  ),
                                  Icon(Icons.check_circle, color: kprimaryColor, size: 18),
                                ],
                              ),
                            ),
                            // Divider between items
                            Divider(color: Colors.grey.shade300, thickness: 1),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            // Continue Button
            SizedBox(
              width: double.infinity,
              child: AuthButton(
                text: "Continue",
                onTap: () {
                  Get.back();
                },
              ),
            ),
            SizedBox(height: 80.h),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(GetMaterialApp(home: GetMembershipScreen()));
}
