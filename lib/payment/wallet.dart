// lib/screens/wallet\_screen.dart

// ignore_for_file: use_super_parameters, deprecated_member_use

import 'package:cutcy/constants/constants.dart';
import 'package:cutcy/payment/add_payment_method.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// Controller for Wallet data
class WalletController extends GetxController {
  /// Current balance
}

class WalletScreen extends StatelessWidget {
  WalletScreen({Key? key}) : super(key: key);

  // Instantiate the controller (or find if already put)
  final WalletController controller = Get.put<WalletController>(WalletController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: Center(
                child: Text(
                  'Wallet',
                  style: TextStyle(color: white, fontSize: 20.sp, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            SizedBox(height: 24.h),

            // Payment Methods
            GestureDetector(
              onTap: () {
                Get.to(() => AddCardScreen());
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                  decoration: BoxDecoration(color: Colors.grey[850], borderRadius: BorderRadius.circular(12.r)),
                  child: Row(
                    children: [
                      Icon(Icons.credit_card, color: white, size: 20.sp),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Text(
                          'Payment Methods',
                          style: TextStyle(color: white, fontSize: 14.sp),
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios, color: white, size: 16.sp),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
