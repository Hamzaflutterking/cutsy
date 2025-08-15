// views/add_card_screen.dart
// ignore_for_file: deprecated_member_use

import 'package:cutcy/constants/constants.dart';
import 'package:cutcy/payment/save_payment_screen.dart';
import 'package:cutcy/widgets/border_text_field.dart';
import 'package:cutcy/widgets/AppButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AddCardScreen extends StatelessWidget {
  AddCardScreen({super.key});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController expiryController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();
  final TextEditingController line1Controller = TextEditingController();
  final TextEditingController line2Controller = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController zipController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: const Text('Add Payment Method', style: TextStyle(color: white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: white),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Icon(Icons.shield_outlined, color: kprimaryColor, size: 18),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text('All payment information is stored securely.', style: TextStyle(color: kprimaryColor, fontSize: 13)),
                  ),
                ],
              ),
              SizedBox(height: 20.h),

              BorderTextField(label: "Card Holder's Name", hint: "Luna Woods", controller: nameController),
              SizedBox(height: 12.h),

              BorderTextField(label: "Card Number", hint: "**** **** **** 1234", controller: numberController, keyboardType: TextInputType.number),
              SizedBox(height: 12.h),

              Row(
                children: [
                  Expanded(
                    child: BorderTextField(label: "Expiry Date", hint: "MM/YY", controller: expiryController, keyboardType: TextInputType.datetime),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: BorderTextField(label: "CVV", hint: "123", controller: cvvController, keyboardType: TextInputType.number),
                  ),
                ],
              ),
              SizedBox(height: 12.h),

              BorderTextField(label: "Address Line 1", hint: "Street Address", controller: line1Controller),
              SizedBox(height: 12.h),

              BorderTextField(label: "Address Line 2", hint: "Apt, Suite, etc.", controller: line2Controller),
              SizedBox(height: 12.h),

              Row(
                children: [
                  Expanded(
                    child: BorderTextField(label: "State", hint: "ON", controller: stateController),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: BorderTextField(label: "City", hint: "Toronto", controller: cityController),
                  ),
                ],
              ),
              SizedBox(height: 12.h),

              BorderTextField(label: "Zip Code", hint: "123456", controller: zipController, keyboardType: TextInputType.number),
              SizedBox(height: 24.h),

              AuthButton(
                text: "Save",
                onTap: () {
                  Get.to(() => const SavedPaymentMethodScreen());
                },

                textColor: black,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
