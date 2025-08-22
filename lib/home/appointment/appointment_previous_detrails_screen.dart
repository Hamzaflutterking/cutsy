// ignore_for_file: depend_on_referenced_packages

import 'dart:ui';
import 'package:cutcy/constants/constants.dart';

import 'package:cutcy/home/bookings/checkout_screen.dart';
import 'package:cutcy/home/profile/aacounts/%20receipt_screen.dart';
import 'package:cutcy/widgets/AppButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AppointmentPriviousDetailsScreen extends StatelessWidget {
  AppointmentPriviousDetailsScreen({Key? key}) : super(key: key);

  // Sample data for the appointment
  final appt = Appointment(
    name: 'Richard Anderson',
    price: '\$123.00',
    date: DateTime(2025, 8, 25, 15, 0),
    services: [
      Service(name: 'Hair Cut', qty: 1, price: 20.50),
      Service(name: 'Hair Styling', qty: 1, price: 20.50),
      Service(name: 'Hair Treatment', qty: 1, price: 20.50),
    ],
    location: '134 North Square, Toronto, ON M5S 2E5, Canada',
  );

  String _formatDate(DateTime dt) => DateFormat('EEEE, MMMM d').format(dt).toUpperCase();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: ksecondaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              Get.back();
            },
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
        padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 24.h),
        child: SizedBox(
          height: 130.h,
          child: Column(
            children: [
              20.verticalSpace,

              AuthButton(
                text: "Reschedule Appointment",
                onTap: () {
                  Get.to(() => CheckoutScreen());
                },
              ),
              10.verticalSpace,
              AuthButton(
                text: "View Receipt",
                onTap: () {
                  Get.to(() => ReceiptScreen());
                },
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset('assets/images/young-hispanic-haidresser-and-hairstylist-standing-2024-10-18-17-47-23-utc 1.png', fit: BoxFit.cover),
          ),
          SafeArea(
            child: Column(
              children: [
                70.verticalSpace,
                // Appointment Details
                SizedBox(height: 16.h),
                // Appointment details card
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
                                    backgroundImage: AssetImage(
                                      'assets/images/young-hispanic-haidresser-and-hairstylist-standing-2024-10-18-17-47-23-utc 1.png',
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          appt.name,
                                          style: TextStyle(color: white, fontSize: 16.sp),
                                        ),
                                        Text(
                                          appt.location,
                                          style: TextStyle(color: Colors.white70, fontSize: 12.sp),
                                        ),
                                        Row(
                                          children: [
                                            Icon(Icons.star, color: kprimaryColor, size: 14.sp),
                                            SizedBox(width: 4.w),
                                            Text(
                                              '4.3 (65)',
                                              style: TextStyle(color: Colors.white70, fontSize: 12.sp),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
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
                                          _formatDate(appt.date),
                                          style: TextStyle(color: kprimaryColor, fontSize: 12.sp),
                                        ),
                                        SizedBox(height: 4.h),
                                        Text(
                                          '15:00–16:00',
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
                                  children: [
                                    _serviceRow('assets/icons/012-scissors.png', 'Hair Cut', 1, 20.50),
                                    Divider(color: Colors.white24),
                                    _serviceRow('assets/icons/011-hair dryer.png', 'Hair Styling', 1, 20.50),
                                    Divider(color: Colors.white24),
                                    _serviceRow('assets/icons/034-shampoo.png', 'Hair Treatment', 1, 20.50),
                                  ],
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
                                    _locationRow('Check-Inn Hotel', '130 St George St, Toronto, ON M5S 1A5, Canada'),
                                    SizedBox(height: 12.h),
                                    _locationRow('Your Location', '75 St George St, Toronto, ON M5S 2E5, Canada'),
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
                                    _totalRow('Sub Total:', 128),
                                    SizedBox(height: 4.h),
                                    _totalRow('Discount:', -10),
                                    SizedBox(height: 4.h),
                                    _totalRow('Platform Fee:', 5),
                                    Divider(color: Colors.white24),
                                    _totalRow('Total:', 123, isBold: true, valueColor: kprimaryColor),
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
  }

  Widget _serviceRow(String assetPath, String name, int qty, double price) {
    return Row(
      children: [
        Image.asset(assetPath, width: 20.sp, height: 20.sp),
        SizedBox(width: 12.w),
        Text(
          '\$$qty x \$$name',
          style: TextStyle(color: white, fontSize: 14.sp),
        ),
        Spacer(),
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

class Appointment {
  final String name;
  final String price;
  final DateTime date;
  final List<Service> services;
  final String location;

  Appointment({required this.name, required this.price, required this.date, required this.services, required this.location});
}

class Service {
  final String name;
  final int qty;
  final double price;

  Service({required this.name, required this.qty, required this.price});
}
