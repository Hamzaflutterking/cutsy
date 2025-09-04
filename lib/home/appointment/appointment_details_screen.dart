// ignore_for_file: depend_on_referenced_packages, use_super_parameters, deprecated_member_use

import 'dart:ui';
import 'package:cutcy/constants/constants.dart';
import 'package:cutcy/home/appointment/appointment_chat_screen.dart';
import 'package:cutcy/home/appointment/appointment_controller.dart';
import 'package:cutcy/home/appointment/track_your_barber_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AppointmentDetailsScreen extends StatelessWidget {
  AppointmentDetailsScreen({Key? key}) : super(key: key);
  final AppointmentController ctrl = Get.find();

  String _formatDate(DateTime dt) => DateFormat('EEEE, MMMM d').format(dt).toUpperCase();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final appt = ctrl.selectedAppointment.value;

      if (appt == null) {
        return Scaffold(
          backgroundColor: backgroundColor,
          body: Center(
            child: Text('No appointment selected', style: TextStyle(color: white)),
          ),
        );
      }

      return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: ksecondaryColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          automaticallyImplyLeading: false,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                width: 50.w,
                height: 50.h,
                decoration: BoxDecoration(color: ksecondaryColor, borderRadius: BorderRadius.circular(10)),
                child: Icon(Icons.arrow_back_ios_new, color: white),
              ),
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.fromLTRB(24.w, 20, 24.w, 60.h),
          child: SizedBox(
            height: 56.h,
            child: ElevatedButton(
              onPressed: () => Get.to(() => TrackBarberScreen()),
              style: ElevatedButton.styleFrom(
                backgroundColor: kprimaryColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
              ),
              child: Text(
                'Track your Barber',
                style: TextStyle(color: black, fontSize: 16.sp),
              ),
            ),
          ),
        ),
        body: Stack(
          children: [
            // Background image
            Positioned.fill(
              child: appt.barber?.image != null
                  ? Image.network(appt.barber!.image!, fit: BoxFit.cover)
                  : Image.asset('assets/images/young-hispanic-haidresser-and-hairstylist-standing-2024-10-18-17-47-23-utc 1.png', fit: BoxFit.cover),
            ),

            SafeArea(
              child: Column(
                children: [
                  70.verticalSpace,
                  SizedBox(height: 16.h),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(24.w),
                          decoration: BoxDecoration(
                            color: backgroundColor,
                            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Title
                                Text(
                                  'Appointment Details',
                                  style: TextStyle(color: white, fontSize: 20.sp, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 16.h),

                                // Barber info
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 24.r,
                                      backgroundImage: appt.barber?.image != null
                                          ? NetworkImage(appt.barber!.image!)
                                          : AssetImage(
                                                  'assets/images/young-hispanic-haidresser-and-hairstylist-standing-2024-10-18-17-47-23-utc 1.png',
                                                )
                                                as ImageProvider,
                                    ),
                                    SizedBox(width: 12.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            appt.barber?.name ?? 'Unknown Barber',
                                            style: TextStyle(color: white, fontSize: 16.sp),
                                          ),
                                          Text(
                                            appt.locationName ?? 'Location not specified',
                                            style: TextStyle(color: Colors.white70, fontSize: 12.sp),
                                          ),
                                          Text(
                                            appt.barber?.experience ?? 'Experience not specified',
                                            style: TextStyle(color: Colors.white70, fontSize: 12.sp),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        Container(
                                          width: 50.w,
                                          height: 40.h,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(color: white),
                                          ),
                                          child: IconButton(
                                            icon: Icon(Icons.near_me, color: kprimaryColor, size: 24.r),
                                            onPressed: () {
                                              showModalBottomSheet(
                                                context: context,
                                                isScrollControlled: true,
                                                backgroundColor: Colors.transparent,
                                                builder: (_) => DraggableScrollableSheet(
                                                  expand: false,
                                                  initialChildSize: 0.9,
                                                  minChildSize: 0.5,
                                                  maxChildSize: 0.95,
                                                  builder: (_, controller) => Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey[900],
                                                      borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
                                                    ),
                                                    child: ChatContent(controller: controller),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        10.verticalSpace,
                                        Container(
                                          width: 50.w,
                                          height: 40.h,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(color: white),
                                          ),
                                          child: IconButton(
                                            icon: Icon(Icons.call, color: kprimaryColor, size: 24.r),
                                            onPressed: () {},
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 24.h),

                                // Date & Time
                                Text(
                                  'DATE & TIME',
                                  style: TextStyle(color: Colors.white70, fontSize: 12.sp),
                                ),
                                SizedBox(height: 8.h),
                                Container(
                                  padding: EdgeInsets.all(16.w),
                                  decoration: BoxDecoration(
                                    color: ksecondaryColor,
                                    borderRadius: BorderRadius.circular(12.r),
                                    border: Border.all(color: Colors.white24),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.calendar_today, color: kprimaryColor, size: 20.sp),
                                      SizedBox(width: 12.w),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            appt.day ?? 'Day not specified',
                                            style: TextStyle(color: kprimaryColor, fontSize: 12.sp),
                                          ),
                                          SizedBox(height: 4.h),
                                          Text(
                                            '${appt.startTime ?? '--:--'}–${appt.endTime ?? '--:--'}',
                                            style: TextStyle(color: white, fontSize: 14.sp),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 24.h),

                                // Services
                                Text(
                                  'SERVICES',
                                  style: TextStyle(color: Colors.white70, fontSize: 12.sp),
                                ),
                                SizedBox(height: 8.h),
                                Container(
                                  padding: EdgeInsets.all(16.w),
                                  decoration: BoxDecoration(
                                    color: ksecondaryColor,
                                    borderRadius: BorderRadius.circular(12.r),
                                    border: Border.all(color: Colors.white24),
                                  ),
                                  child: Column(
                                    children:
                                        appt.services
                                            ?.map(
                                              (service) => Padding(
                                                padding: EdgeInsets.symmetric(vertical: 4.h),
                                                child: _serviceRow(
                                                  'assets/icons/012-scissors.png',
                                                  'Service ${service.serviceCategoryId ?? 'Unknown'}',
                                                  1,
                                                  service.price ?? 0.0,
                                                ),
                                              ),
                                            )
                                            .toList() ??
                                        [_serviceRow('assets/icons/012-scissors.png', 'No services specified', 1, 0.0)],
                                  ),
                                ),
                                SizedBox(height: 24.h),

                                // Location
                                Text(
                                  'LOCATION',
                                  style: TextStyle(color: Colors.white70, fontSize: 12.sp),
                                ),
                                SizedBox(height: 8.h),
                                Container(
                                  padding: EdgeInsets.all(16.w),
                                  decoration: BoxDecoration(
                                    color: ksecondaryColor,
                                    borderRadius: BorderRadius.circular(12.r),
                                    border: Border.all(color: Colors.white24),
                                  ),
                                  child: Column(
                                    children: [
                                      _locationRow('Barber Location', appt.barber?.addressLine1 ?? 'Address not specified'),
                                      SizedBox(height: 12.h),
                                      _locationRow('Your Location', appt.locationName ?? 'Location not specified'),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 24.h),

                                // Total Summary
                                Text(
                                  'TOTAL',
                                  style: TextStyle(color: Colors.white70, fontSize: 12.sp),
                                ),
                                SizedBox(height: 8.h),
                                Container(
                                  padding: EdgeInsets.all(16.w),
                                  decoration: BoxDecoration(
                                    color: ksecondaryColor,
                                    borderRadius: BorderRadius.circular(12.r),
                                    border: Border.all(color: Colors.white24),
                                  ),
                                  child: Column(
                                    children: [
                                      _totalRow('Sub Total:', appt.amount ?? 0),
                                      SizedBox(height: 4.h),
                                      _totalRow('Platform Fee:', 0), // You might want to add this field to your model
                                      Divider(color: Colors.white24),
                                      _totalRow('Total:', appt.totalAmount ?? appt.amount ?? 0, isBold: true, valueColor: kprimaryColor),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 32.h),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _serviceRow(String assetPath, String name, int qty, double price) {
    return Row(
      children: [
        Image.asset(assetPath, width: 20.sp, height: 20.sp),
        SizedBox(width: 12.w),
        Text(
          '\$$qty x $name',
          style: TextStyle(color: white, fontSize: 14.sp),
        ),
        // Spacer(),
        Text(
          '\$${price.toStringAsFixed(2)}',
          style: TextStyle(color: white, fontSize: 14.sp),
        ),
      ],
    );
  }

  Widget _locationRow(String title, String subtitle) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.circle, color: kprimaryColor, size: 10.sp),
        SizedBox(width: 8.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(color: white, fontSize: 14.sp),
              ),
              Text(
                subtitle,
                style: TextStyle(color: Colors.white70, fontSize: 12.sp),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _totalRow(String label, double value, {bool isBold = false, Color? valueColor}) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(color: white, fontSize: 14.sp),
        ),
        Spacer(),
        Text(
          value < 0 ? '-\$${(-value).toStringAsFixed(2)}' : '\$${value.toStringAsFixed(2)}',
          style: TextStyle(color: valueColor ?? white, fontSize: 14.sp, fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
        ),
      ],
    );
  }
}
