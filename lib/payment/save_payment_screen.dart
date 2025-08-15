// views/saved_payment_method_screen.dart
// ignore_for_file: deprecated_member_use

import 'package:cutcy/constants/constants.dart';
import 'package:cutcy/navbar/bottom_nav_controller.dart';
import 'package:cutcy/navbar/main_navbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cutcy/widgets/AppButton.dart';

class SavedPaymentMethodScreen extends StatelessWidget {
  const SavedPaymentMethodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add\nPayment Method',
                style: TextStyle(color: white, fontSize: 28, fontWeight: FontWeight.bold, height: 1.2),
              ),
              const SizedBox(height: 16),
              const Text(
                'Easily update your card details or add a new payment option anytime.',
                style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.5),
              ),
              const SizedBox(height: 40),

              // Add Payment Method Tile
              GestureDetector(
                onTap: () {
                  // Navigate to add card form screen
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(color: Colors.grey[900], borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    children: const [
                      Icon(Icons.credit_card, color: kprimaryColor),
                      SizedBox(width: 12),
                      Text('Add Payment Method', style: TextStyle(color: white, fontSize: 16)),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Saved Card List Tile
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(color: Colors.grey[900], borderRadius: BorderRadius.circular(12)),
                child: Row(
                  children: const [
                    CircleAvatar(
                      backgroundColor: kprimaryColor,
                      radius: 16,
                      child: Text('L', style: TextStyle(color: black)),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text('Luna Woods\nxxxx - xxxx - xxxx - xxxx', style: TextStyle(color: white, fontSize: 14)),
                    ),
                    Icon(Icons.arrow_forward_ios, color: white, size: 16),
                  ],
                ),
              ),

              const Spacer(),

              // Continue Button
              AuthButton(
                text: "Continue",
                onTap: () {
                  // Navigate to the next screen when tapped
                  final navC = Get.isRegistered<BottomNavController>() ? Get.find<BottomNavController>() : Get.put(BottomNavController());

                  navC.changeIndex(0);
                  Get.offAll(() => MainScreen());
                },
                textColor: Colors.black,
              ),

              const SizedBox(height: 12),

              Center(
                child: TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text('Skip for now', style: TextStyle(color: kprimaryColor, fontSize: 14)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
