// ignore_for_file: unnecessary_import, file_names

import 'dart:ui';
import 'package:cutcy/constants/constants.dart';
import 'package:cutcy/widgets/AppButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'support_chat_screen.dart'; // Import the SupportChatScreen

class ReceiptController extends GetxController {
  var services = [
    Service(name: 'Hair Cut', qty: 1, price: 20.50),
    Service(name: 'Hair Styling', qty: 1, price: 20.50),
    Service(name: 'Hair Treatment', qty: 1, price: 20.50),
  ];

  double subTotal = 128.00;
  double discount = 10.00;
  double platformFee = 5.00;

  double get total => subTotal - discount + platformFee;
  double amountPaid = 123.00;

  // Barber information
  final barberName = 'Richard Anderson';
  final barberRating = 4.3;
}

class Service {
  final String name;
  final int qty;
  final double price;

  Service({required this.name, required this.qty, required this.price});
}

class ReceiptScreen extends StatelessWidget {
  ReceiptScreen({Key? key}) : super(key: key);
  final ReceiptController _controller = Get.put(ReceiptController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ksecondaryColor,
      appBar: AppBar(
        backgroundColor: ksecondaryColor,
        title: Text('Receipt', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Invoice header
            Text(
              'Invoice no.: 0001',
              style: TextStyle(color: Colors.white, fontSize: 14.sp),
            ),
            SizedBox(height: 4.h),
            Text(
              'FRIDAY, AUGUST 25, 2025',
              style: TextStyle(color: Colors.white70, fontSize: 12.sp),
            ),
            SizedBox(height: 20.h),

            // Barber info
            Row(
              children: [
                CircleAvatar(radius: 24.r, backgroundImage: AssetImage('assets/images/Frame 567 (1).png')),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _controller.barberName,
                        style: TextStyle(color: white, fontSize: 16.sp),
                      ),
                      Row(
                        children: [
                          Icon(Icons.star, color: kprimaryColor, size: 14.sp),
                          SizedBox(width: 4.w),
                          Text(
                            '${_controller.barberRating} (65)',
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
                children: _controller.services.map((service) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 6.h),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${service.qty}x ${service.name}',
                            style: TextStyle(color: white, fontSize: 14.sp),
                          ),
                        ),
                        Text(
                          '\$${(service.price * service.qty).toStringAsFixed(2)}',
                          style: TextStyle(color: white, fontSize: 14.sp),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 24.h),

            // Pricing breakdown
            _pricingRow('Sub Total:', _controller.subTotal),
            _pricingRow('Discount:', -_controller.discount),
            _pricingRow('Platform Fee:', _controller.platformFee),
            Divider(color: Colors.white24),
            _pricingRow('Total:', _controller.total, isBold: true, valueColor: kprimaryColor),
            SizedBox(height: 24.h),

            // Amount Paid
            Text(
              'Amount Paid: \$${_controller.amountPaid.toStringAsFixed(2)}',
              style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20.h),

            // Contact support text
            Text(
              'Have any trouble? Please contact support.',
              style: TextStyle(color: Colors.white70, fontSize: 12.sp),
            ),
            Spacer(),

            // Button to continue
            Padding(
              padding: EdgeInsets.only(bottom: 70.h),
              child: SizedBox(
                width: double.infinity,
                child: AuthButton(
                  text: "Continue",
                  onTap: () {
                    Get.back();
                  },
                ),
              ),
            ),
          ],
        ),
      ),

      // Floating Action Button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => SupportChatScreen()); // Navigate to the SupportChatScreen
        },
        backgroundColor: Colors.yellow,
        child: Icon(Icons.headset_mic, color: Colors.black),
      ),
    );
  }

  Widget _pricingRow(String label, double value, {bool isBold = false, Color? valueColor}) {
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
