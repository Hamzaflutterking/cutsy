// ignore_for_file: use_super_parameters

import 'package:cutcy/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,

        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: white),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: const Text('Privacy Policy', style: TextStyle(color: white)),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
          child: SingleChildScrollView(
            child: Text('''
Privacy Policy for Cutsy

This Privacy Policy explains how Cutsy collects, uses, and protects your information when you use our mobile application.

By using the App, you consent to the practices described in this policy.

1. Information We Collect
We may collect the following types of information:

Personal Information: Such as your name, email address, and any other details you provide when signing up or contacting us.

Reminder Data: Information you input into the app, like tasks, events, notes, and your notification preferences.

Usage Data: Anonymous analytics about how you interact with the app, including screen views and actions.

Device Information: Details like your device type, operating system, and crash reports — used to help us improve the app.

2. How We Use Your Information
We use the information we collect to:
• Provide and maintain the app’s core features
• Personalize your experience
• Send you reminders and helpful notifications
• Improve our app and user experience
• Respond to your questions or support requests
• We do not sell your personal information to third parties.

3. Data Storage and Security
We take appropriate steps to protect your data from unauthorized access, alteration, or disclosure. However, no...
              ''', style: TextStyle(color: white, fontSize: 15.sp, height: 1.6, fontFamily: "SF Pro Display")),
          ),
        ),
      ),
    );
  }
}
