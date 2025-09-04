// lib/screens/wallet\_screen.dart

import 'package:cutcy/constants/constants.dart';

import 'package:cutcy/payment/wallet_controller.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

/// Controller for Wallet data

class WalletScreen extends StatelessWidget {
  WalletScreen({Key? key}) : super(key: key);

  // Instantiate the controller (or find if already put)
  final WalletController controller = Get.put(WalletController());

  @override
  Widget build(BuildContext context) {
    // controller.loadPaymentMethods(); // Load payment methods on screen load
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

            // Add New Card Button
            Obx(
              () => GestureDetector(
                onTap: controller.isAddingCard.value
                    ? null
                    : () async {
                        await controller.addPaymentMethod();
                      },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                    decoration: BoxDecoration(
                      color: controller.isAddingCard.value ? Colors.grey[700] : kprimaryColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: kprimaryColor),
                    ),
                    child: Row(
                      children: [
                        controller.isAddingCard.value
                            ? SizedBox(
                                width: 20.w,
                                height: 20.h,
                                child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(kprimaryColor)),
                              )
                            : Icon(Icons.add, color: kprimaryColor, size: 20.sp),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Text(
                            controller.isAddingCard.value ? 'Adding Card...' : 'Add New Card',
                            style: TextStyle(color: kprimaryColor, fontSize: 14.sp, fontWeight: FontWeight.w600),
                          ),
                        ),
                        if (!controller.isAddingCard.value) Icon(Icons.arrow_forward_ios, color: kprimaryColor, size: 16.sp),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 16.h),

            // Payment Methods List
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(kprimaryColor)));
                }

                if (controller.paymentMethods.isEmpty) {
                  return _buildNoCardsUI();
                }

                return _buildPaymentMethodsList();
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoCardsUI() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.credit_card_off, size: 80.sp, color: Colors.grey[600]),
            SizedBox(height: 24.h),
            Text(
              'No Cards Attached',
              style: TextStyle(color: white, fontSize: 18.sp, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8.h),
            Text(
              'Add a payment method to get started',
              style: TextStyle(color: Colors.grey[400], fontSize: 14.sp),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodsList() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      itemCount: controller.paymentMethods.length,
      itemBuilder: (context, index) {
        final method = controller.paymentMethods[index];
        return _buildPaymentMethodCard(method);
      },
    );
  }

  Widget _buildPaymentMethodCard(Map<String, dynamic> method) {
    final brand = method['brand'] ?? 'card';
    final last4 = method['last4'] ?? '****';
    final expMonth = method['expMonth'] ?? 0;
    final expYear = method['expYear'] ?? 0;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: ksecondaryColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey[700]!),
      ),
      child: Row(
        children: [
          // Card icon
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(color: kprimaryColor.withOpacity(0.2), borderRadius: BorderRadius.circular(8.r)),
            child: Icon(_getCardIcon(brand), color: kprimaryColor, size: 24.r),
          ),
          SizedBox(width: 16.w),

          // Card details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${brand.toUpperCase()} •••• $last4",
                  style: TextStyle(color: white, fontSize: 16.sp, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 4.h),
                Text(
                  "Expires ${expMonth.toString().padLeft(2, '0')}/${expYear.toString().substring(2)}",
                  style: TextStyle(color: Colors.grey[400], fontSize: 14.sp),
                ),
              ],
            ),
          ),

          // Delete button
          GestureDetector(
            onTap: () => _showDeleteConfirmation(method),
            child: Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(6.r)),
              child: Icon(Icons.delete_outline, color: Colors.red[400], size: 20.r),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCardIcon(String brand) {
    switch (brand.toLowerCase()) {
      case 'visa':
        return Icons.credit_card;
      case 'mastercard':
        return Icons.credit_card;
      case 'amex':
        return Icons.credit_card;
      default:
        return Icons.credit_card;
    }
  }

  void _showDeleteConfirmation(Map<String, dynamic> method) {
    final brand = method['brand'] ?? 'card';
    final last4 = method['last4'] ?? '****';

    Get.dialog(
      AlertDialog(
        backgroundColor: ksecondaryColor,
        title: Text('Remove Card', style: TextStyle(color: white)),
        content: Text('Are you sure you want to remove ${brand.toUpperCase()} •••• $last4?', style: TextStyle(color: Colors.grey[300])),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel', style: TextStyle(color: Colors.grey[400])),
          ),
          TextButton(
            onPressed: () async {
              Get.back();
              // await controller.deletePaymentMethod(method['id']);
            },
            child: Text('Remove', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
