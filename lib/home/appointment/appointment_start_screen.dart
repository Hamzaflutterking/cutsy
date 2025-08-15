// ignore_for_file: avoid_unnecessary_containers, unnecessary_import

import 'package:cutcy/home/appointment/appointment_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cutcy/widgets/AppButton.dart';
import 'package:cutcy/constants/constants.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';

class AppointmentStartedScreen extends StatelessWidget {
  const AppointmentStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset('assets/images/young-hispanic-haidresser-and-hairstylist-standing-2024-10-18-17-47-23-utc 1.png', fit: BoxFit.cover),
          ),

          // Content in a Curved Container
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 0.w),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(40.r)),
                child: Container(
                  color: backgroundColor,
                  padding: EdgeInsets.all(20.w),
                  width: double.infinity,
                  height: 450.h,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        20.verticalSpace,
                        Row(
                          children: [
                            Text(
                              "Your appointment has started!",
                              textAlign: TextAlign.left,
                              style: TextStyle(color: Colors.yellow, fontWeight: FontWeight.bold, fontSize: 18.sp),
                            ),
                          ],
                        ),
                        20.verticalSpace,
                        // Barber's Image (Circular)
                        Image.asset("assets/images/Frame.png"),
                        SizedBox(height: 30.h),

                        Row(
                          children: [
                            Container(
                              width: 70.w,
                              height: 70.h,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(16.r),
                                image: DecorationImage(
                                  image: AssetImage('assets/images/young-hispanic-haidresser-and-hairstylist-standing-2024-10-18-17-47-23-utc 1.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            20.horizontalSpace,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Richard Anderson",
                                  style: TextStyle(color: Colors.white, fontSize: 18.sp),
                                ),
                                SizedBox(height: 10.w),

                                Row(
                                  children: [
                                    Icon(Icons.star, color: Colors.yellow, size: 18.sp),
                                    SizedBox(width: 5.w),
                                    Text(
                                      "4.3 (65)",
                                      style: TextStyle(color: Colors.white70, fontSize: 14.sp),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        10.verticalSpace,
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 0.w),
                          child: Container(
                            padding: EdgeInsets.all(16.r),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.r)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Payment Text
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Payment",
                                      style: TextStyle(color: Colors.white70, fontSize: 14.sp),
                                    ),
                                    SizedBox(height: 8.h),
                                    Row(
                                      children: [
                                        Icon(Icons.payment, color: Colors.yellow, size: 20.sp),
                                        SizedBox(width: 8.w),
                                        Text(
                                          "\$123.00",
                                          style: TextStyle(color: Colors.white, fontSize: 16.sp),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                                // Payment Button Icon
                                Container(child: Image.asset("assets/icons/Button.png", scale: 4)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: ksecondaryColor, // Set the background color for the bottom navigation bar
        padding: EdgeInsets.fromLTRB(24.w, 20, 24.w, 65.h),
        child: SizedBox(
          height: 56.h,
          child: AuthButton(
            text: "View Appointment Details",
            onTap: () {
              Get.to(() => AppointmentDetailsScreen());
              // Handle navigation to the appointment details page
            },
          ),
        ),
      ),
    );
  }
}
