// ignore_for_file: deprecated_member_use
import 'package:cutcy/home/profile/account_screen.dart';
import 'package:cutcy/home/profile/edit_profile_screen.dart';
import 'package:cutcy/home/profile/permissions_screen.dart';
import 'package:cutcy/home/profile/privacy_screen.dart';
import 'package:cutcy/home/profile/profile_controller.dart';
import 'package:cutcy/home/profile/support_screen.dart';
import 'package:cutcy/home/profile/terms_and_conditions_screen.dart';
import 'package:cutcy/widgets/AppButton.dart';
import 'package:cutcy/widgets/profile/ProfileManuwidget.dart';
import 'package:cutcy/widgets/profile/SectionTitlewidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:cutcy/constants/constants.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key? key}) : super(key: key);

  final ProfileController ctrl = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      extendBody: true,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: Center(
                child: Text(
                  'My Profile',
                  style: TextStyle(color: white, fontSize: 20.sp, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            // Avatar & Name
            Center(
              child: Obx(
                () => Container(
                  width: 80.r,
                  height: 80.r,
                  decoration: BoxDecoration(color: Colors.grey[700], borderRadius: BorderRadius.circular(18.r)),
                  clipBehavior: Clip.hardEdge,
                  child: ctrl.avatarFile.value != null
                      ? Image.file(ctrl.avatarFile.value!, width: 80.r, height: 80.r, fit: BoxFit.cover)
                      : Image.asset(ctrl.avatarPath.value, width: 80.r, height: 80.r, fit: BoxFit.cover),
                ),
              ),
            ),

            SizedBox(height: 24.h),

            // Sections
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Using SectionTitle for 'General' section
                    SectionTitle(title: 'General'),

                    // Using ProfileMenu for each menu item
                    ProfileMenu(
                      title: 'Edit Profile',
                      subtitle: 'Adjust your preferences and personal details.',
                      onTap: () {
                        Get.to(() => EditProfileScreen());
                      },
                    ),
                    ProfileMenu(
                      title: 'Account',
                      subtitle: 'Manage your profile and preferences.',
                      onTap: () {
                        Get.to(() => AccountScreen());
                      },
                    ),
                    ProfileMenu(
                      title: 'Permissions',
                      subtitle: 'Manage what you share and how we protect it.',
                      onTap: () {
                        Get.to(() => PermissionsScreen());
                      },
                    ),

                    SizedBox(height: 18.h),

                    // Using SectionTitle for 'Help' section
                    SectionTitle(title: 'Help'),

                    ProfileMenu(
                      title: 'Support',
                      subtitle: 'Reach out for assistance anytime.',
                      onTap: () {
                        Get.to(() => SupportScreen());
                      },
                    ),
                    ProfileMenu(
                      title: 'Privacy Policy',
                      subtitle: 'Learn how we protect your information.',
                      onTap: () {
                        Get.to(() => PrivacyPolicyScreen());
                      },
                    ),
                    ProfileMenu(
                      title: 'Terms and Conditions',
                      subtitle: 'Understand the terms of using Ollie.',
                      onTap: () {
                        Get.to(() => TermsAndConditionsScreen());
                      },
                    ),

                    10.verticalSpace,

                    Padding(
                      padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 24.h),
                      child: AuthButton(text: 'Logout', onTap: ctrl.logout),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
