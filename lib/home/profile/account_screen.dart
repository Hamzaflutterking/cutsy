// ignore_for_file: use_super_parameters, unused_element_parameter

import 'package:cutcy/constants/constants.dart';
import 'package:cutcy/home/appointment/appointment_history_screen.dart';
import 'package:cutcy/home/profile/aacounts/change_password_screen.dart'; // Make sure this screen is properly implemented
import 'package:cutcy/home/profile/aacounts/current_plans_screen.dart';
import 'package:cutcy/home/profile/aacounts/save_address_screen.dart';
import 'package:cutcy/widgets/Appdilogbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'profile_controller.dart';

class AccountScreen extends StatelessWidget {
  AccountScreen({Key? key}) : super(key: key);
  final ProfileController ctrl = Get.find();

  void _onTap(int index) {
    switch (index) {
      case 0:
        Get.to(() => CurrentPlanScreen());

        break;
      case 1:
        Get.to(() => AppointmentHistoryScreen()); // Ensure this screen is implemented
        break;
      case 2:
        Get.to(() => SavedAddressesScreen()); // Ensure this screen is implemented
        break;
      case 3:
        // Navigate to ResetPasswordScreen
        Get.to(() => ChangePasswordScreen()); // Ensure you're navigating to the actual widget
        break;
      case 4:
        Get.dialog(
          CustomConfirmDialog(
            backgroundColor: ksecondaryColor,
            topImage: Image.asset("assets/icons/Frame 71 (1).png", scale: 4), // Custom image, like the trash icon in the image
            title: "Are you sure?", // Title text
            message: "Deleting your account will make you lose all your data permanently", // Message text
            positiveButtonText: "Continue", // Positive button text
            negativeButtonText: "No, thanks", // Negative button text
            onPositive: () {
              Get.back();
            },
            onNegative: () => Get.back(), // Close the dialog
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final options = [
      _AccountOption(Icons.event_note, 'Current Plan', showTrailing: true),
      _AccountOption(Icons.history, 'Appointment History', showTrailing: true),
      _AccountOption(Icons.location_on_outlined, 'Saved Addresses', showTrailing: false),
      _AccountOption(Icons.lock_outline, 'Reset Password', showTrailing: true),
      _AccountOption(Icons.delete_outline, 'Delete Account', showTrailing: false),
    ];

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
        title: const Text('Account', style: TextStyle(color: white)),
      ),
      body: Column(
        children: [
          20.verticalSpace,
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Card(
              color: const Color(0xFF232323),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: options.length,
                separatorBuilder: (_, __) => const Divider(color: Colors.white12, height: 1),
                itemBuilder: (context, index) {
                  final opt = options[index];
                  return ListTile(
                    leading: Icon(opt.icon, color: opt.iconColor ?? white, size: 22),
                    title: Text(
                      opt.label,
                      style: TextStyle(color: opt.iconColor ?? white, fontSize: 15, fontWeight: FontWeight.w400),
                    ),
                    trailing: opt.showTrailing ? Icon(Icons.chevron_right, color: white, size: 22) : null,
                    onTap: () => _onTap(index),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    tileColor: Colors.transparent,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AccountOption {
  final IconData icon;
  final String label;
  final Color? iconColor;
  final bool showTrailing;
  _AccountOption(this.icon, this.label, {this.iconColor, this.showTrailing = true});
}
