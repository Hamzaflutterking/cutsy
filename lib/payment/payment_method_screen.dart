// views/add_payment_method_screen.dart
// ignore_for_file: deprecated_member_use

import 'package:cutcy/constants/constants.dart';
import 'package:cutcy/payment/add_payment_method.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddPaymentMethodScreen extends StatelessWidget {
  const AddPaymentMethodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 40, 24, 16),
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
              GestureDetector(
                onTap: () {
                  Get.to(() => AddCardScreen());
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(color: ksecondaryColor, borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    children: const [
                      Icon(Icons.credit_card, color: kprimaryColor),
                      SizedBox(width: 12),
                      Text('Add Payment Method', style: TextStyle(color: white, fontSize: 16)),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              Center(
                child: TextButton(
                  onPressed: () {
                    Get.back(); // or navigate forward
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
