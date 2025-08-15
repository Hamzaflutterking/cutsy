// ignore_for_file: use_key_in_widget_constructors

import 'package:cutcy/constants/constants.dart';
import 'package:cutcy/home/appointment/appointment_history_controller.dart';
import 'package:cutcy/home/appointment/appointment_previous_detrails_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AppointmentHistoryScreen extends StatelessWidget {
  final AppointmentHistoryController _controller = Get.put(AppointmentHistoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text('Appointment History', style: TextStyle(color: white)),
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
            // Title and description
            Text(
              'Easily view your past appointments and keep track of your visits.',
              style: TextStyle(color: Colors.yellow, fontSize: 16.sp),
            ),
            SizedBox(height: 20.h),

            // Appointment list
            Obx(
              () => ListView.builder(
                shrinkWrap: true, // Ensures the ListView takes only as much space as it needs
                itemCount: _controller.appointments.length,
                itemBuilder: (context, index) {
                  final appointment = _controller.appointments[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 6.h),
                    child: GestureDetector(
                      onTap: () {
                        Get.to(() => AppointmentPriviousDetailsScreen());
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
                        decoration: BoxDecoration(color: Colors.grey[850], borderRadius: BorderRadius.circular(12.r)),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    appointment.name,
                                    style: TextStyle(color: white, fontSize: 14.sp),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    appointment.date,
                                    style: TextStyle(color: Colors.white54, fontSize: 12.sp),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              appointment.price,
                              style: TextStyle(color: white, fontSize: 14.sp),
                            ),
                            Icon(Icons.arrow_forward_ios, color: white, size: 18.sp),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
