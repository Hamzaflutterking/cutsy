// ignore_for_file: depend_on_referenced_packages, use_key_in_widget_constructors, avoid_print

import 'package:cutcy/constants/constants.dart';
import 'package:cutcy/home/bookings/date_and_time_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DateTimeScreen extends StatelessWidget {
  final DateTimeController ctrl = Get.put(DateTimeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 12.h),
            _buildHeader(),
            SizedBox(height: 12.h),
            _buildDateSelector(),
            SizedBox(height: 10.h),
            _buildWarning(),
            SizedBox(height: 10.h),
            Expanded(child: _buildTimeSlots()),
            _buildButton(),
            SizedBox(height: 12.h),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.arrow_back_ios, color: Colors.white),
          Text(
            "MAY 2025",
            style: TextStyle(color: Colors.white, fontSize: 16.sp),
          ),
          Icon(Icons.arrow_forward_ios, color: Colors.white),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    return SizedBox(
      height: 60.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        itemCount: ctrl.availableDates.length,
        itemBuilder: (_, index) {
          final date = ctrl.availableDates[index];
          return Obx(() {
            final isSelected = ctrl.selectedDateIndex.value == index;
            return GestureDetector(
              onTap: () => ctrl.selectedDateIndex.value = index,
              child: Container(
                width: 60.w,
                margin: EdgeInsets.symmetric(horizontal: 6.w),
                decoration: BoxDecoration(color: isSelected ? Colors.yellow : Colors.grey[900], borderRadius: BorderRadius.circular(12.r)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat('dd').format(date),
                      style: TextStyle(color: isSelected ? Colors.black : Colors.white, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      DateFormat('E').format(date),
                      style: TextStyle(color: isSelected ? Colors.black : Colors.white70, fontSize: 12.sp),
                    ),
                  ],
                ),
              ),
            );
          });
        },
      ),
    );
  }

  Widget _buildWarning() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.yellow, size: 16.sp),
          SizedBox(width: 6.w),
          Expanded(
            child: Text(
              "Based on your selected services, please book 02 hours.",
              style: TextStyle(color: Colors.yellow, fontSize: 12.sp),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSlots() {
    return Obx(
      () => GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 3.5,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        children: ctrl.timeSlots.map((slot) {
          final isSelected = ctrl.selectedTimeSlots.contains(slot);
          return GestureDetector(
            onTap: () => ctrl.toggleTimeSlot(slot),
            child: Container(
              decoration: BoxDecoration(color: isSelected ? Colors.yellow : Colors.grey[900], borderRadius: BorderRadius.circular(12.r)),
              alignment: Alignment.center,
              child: Text(
                slot,
                style: TextStyle(color: isSelected ? Colors.black : Colors.white, fontWeight: FontWeight.w600, fontSize: 12.sp),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: SizedBox(
        width: double.infinity,
        height: 48.h,
        child: ElevatedButton(
          onPressed: () {
            print("Selected slots: ${ctrl.selectedTimeSlots}");
            Get.back();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.yellow,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
          ),
          child: Text(
            "Save and Continue",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
