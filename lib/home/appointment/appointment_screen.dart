// ignore_for_file: use_super_parameters, depend_on_referenced_packages, deprecated_member_use

import 'package:cutcy/constants/constants.dart';
import 'package:cutcy/home/appointment/appointment_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AppointmentScreen extends StatelessWidget {
  AppointmentScreen({Key? key}) : super(key: key);
  final AppointmentController ctrl = Get.put(AppointmentController());

  String _formatDate(DateTime dt) {
    // e.g. Friday, August 25, 2025
    return DateFormat('EEEE, MMMM d, yyyy').format(dt);
  }

  Widget _buildTab(String title, int idx) {
    return Expanded(
      child: GestureDetector(
        onTap: () => ctrl.changeTab(idx),
        child: Obx(() {
          final selected = ctrl.selectedTab.value == idx;
          return Container(
            height: 40.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected ? kprimaryColor : Colors.transparent,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.transparent),
            ),
            child: Text(
              title,
              style: TextStyle(color: selected ? black : white, fontSize: 14.sp, fontWeight: FontWeight.w500),
            ),
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Appointments',
                  style: TextStyle(color: white, fontSize: 20.sp, fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(height: 16.h),

              /// Tab bar
              Container(
                padding: EdgeInsets.all(4.r),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: white),
                ),
                child: Row(
                  children: [
                    _buildTab('Upcoming', 0),
                    SizedBox(width: 4.w),
                    _buildTab('Ongoing', 1),
                    SizedBox(width: 4.w),
                    _buildTab('Past', 2),
                  ],
                ),
              ),

              SizedBox(height: 16.h),

              /// Appointment list
              Expanded(
                child: Obx(() {
                  final tab = ctrl.selectedTab.value;
                  final list = tab == 1
                      ? ctrl.ongoing
                      : tab == 2
                      ? ctrl.past
                      : ctrl.upcoming;

                  return ListView.separated(
                    itemCount: list.length,
                    separatorBuilder: (_, __) => Divider(color: Colors.white24),
                    itemBuilder: (_, i) {
                      final appt = list[i];
                      return InkWell(
                        // <-- here: call controller to select & navigate
                        onTap: () => ctrl.selectAppointment(appt),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          child: Row(
                            children: [
                              // Details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      appt.name,
                                      style: TextStyle(color: white, fontSize: 16.sp, fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      _formatDate(appt.date),
                                      style: TextStyle(color: Colors.white70, fontSize: 14.sp),
                                    ),
                                  ],
                                ),
                              ),

                              // Price
                              Text(
                                '\$${appt.price.toStringAsFixed(2)}',
                                style: TextStyle(color: const Color(0xFFF4C419), fontSize: 16.sp, fontWeight: FontWeight.w500),
                              ),

                              SizedBox(width: 8.w),
                              Icon(Icons.arrow_forward_ios, size: 16.sp, color: Colors.white70),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
