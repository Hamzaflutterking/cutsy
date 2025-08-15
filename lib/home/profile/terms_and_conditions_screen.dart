// ignore_for_file: use_super_parameters

import 'package:cutcy/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: white),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: const Text('Terms and Conditions', style: TextStyle(color: white)),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
          child: SingleChildScrollView(
            child: Text('''
Welcome to Cutsy!

These Terms and Conditions govern your use of our mobile application and related services provided by us. By using the App, you agree to be bound by these Terms.

1. Use of the App
Cutsy allows users to create, manage, and receive reminders for personal tasks and events. You agree to use the App only for lawful purposes and in accordance with these Terms.

2. User Accounts
You may be required to create an account to access certain features. You are responsible for maintaining the confidentiality of your login credentials and for all activities that occur under your account.

3. Privacy
We care about your privacy. Our collection and use of your personal information is governed by our Privacy Policy, which is incorporated into these Terms by reference.

4. Intellectual Property
All content and materials in the App, including but not limited to text, graphics, logos, and software, are the property of Cutsy and are protected by applicable intellectual property laws.

5. Prohibited Conduct
You agree not to:

Use the App for any illegal or unauthorized purpose.

Interfere with or disrupt the App or its servers.

Attempt to gain unauthorized access to the App or other user accounts.

... (continue with the rest of your terms as needed)
              ''', style: TextStyle(color: white, fontSize: 15.sp, height: 1.6, fontFamily: "SF Pro Display")),
          ),
        ),
      ),
    );
  }
}
