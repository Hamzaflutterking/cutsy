// ignore_for_file: use_super_parameters

import 'package:cutcy/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'profile_controller.dart';

class PermissionsScreen extends StatelessWidget {
  PermissionsScreen({Key? key}) : super(key: key);
  final ProfileController ctrl = Get.find();

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
        title: const Text('Permissions', style: TextStyle(color: white)),
      ),
      body: Column(
        children: [
          20.verticalSpace,
          Container(
            margin: const EdgeInsets.only(top: 36),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Card(
              color: const Color(0xFF232323),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Obx(
                    () => SwitchListTile(
                      value: ctrl.pushNotificationsEnabled.value,
                      onChanged: ctrl.togglePushNotifications,
                      activeColor: kprimaryColor,
                      inactiveThumbColor: white,
                      inactiveTrackColor: Colors.white24,
                      title: Row(
                        children: [
                          Icon(Icons.notifications_none_rounded, color: white, size: 22),
                          SizedBox(width: 8),
                          Text('Push Notifications', style: TextStyle(color: white, fontSize: 15)),
                        ],
                      ),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      tileColor: Colors.transparent,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                    ),
                  ),
                  Divider(color: Colors.white12, height: 1, indent: 12, endIndent: 12),
                  Obx(
                    () => SwitchListTile(
                      value: ctrl.locationEnabled.value,
                      onChanged: ctrl.toggleLocation,
                      activeColor: kprimaryColor,
                      inactiveThumbColor: white,
                      inactiveTrackColor: Colors.white24,
                      title: Row(
                        children: [
                          Icon(Icons.location_on_outlined, color: white, size: 22),
                          SizedBox(width: 8),
                          Text('Location', style: TextStyle(color: white, fontSize: 15)),
                        ],
                      ),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      tileColor: Colors.transparent,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
