// ignore_for_file: use_super_parameters

import 'package:cutcy/constants/constants.dart';
import 'package:cutcy/notifications/notifications_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationsScreen extends StatelessWidget {
  NotificationsScreen({Key? key}) : super(key: key);
  final NotificationController ctrl = Get.put(NotificationController());

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
        title: const Text('Notifications', style: TextStyle(color: white)),
      ),
      body: Obx(
        () => Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: ListView.separated(
            itemCount: ctrl.notifications.length,
            separatorBuilder: (_, __) => 16.verticalSpace,
            itemBuilder: (context, i) => _NotificationCard(text: ctrl.notifications[i]),
          ),
        ),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final String text;
  const _NotificationCard({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: ksecondaryColor, borderRadius: BorderRadius.circular(12.r)),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 13.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(5.r),
            decoration: BoxDecoration(color: black, borderRadius: BorderRadius.circular(8.r)),
            child: Icon(Icons.calendar_month_rounded, color: kprimaryColor, size: 22.sp),
          ),
          14.horizontalSpace,
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: white, fontSize: 14.5.sp, fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }
}
