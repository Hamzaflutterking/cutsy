// ignore_for_file: use_key_in_widget_constructors, deprecated_member_use

import 'package:cutcy/constants/constants.dart';
import 'package:cutcy/home/bookings/booking_screen.dart';
import 'package:cutcy/home/bookings/dateandtime_screen.dart';
import 'package:cutcy/home/bookings/info_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'bookings_controller.dart';

class BookNowScreen extends StatelessWidget {
  final BookingController ctrl = Get.put(BookingController());

  final List<Map<String, dynamic>> services = [
    {"title": "HAIRCUT", "subtitle": "\$20.50 · 40 min", "icon": Icons.cut},
    {"title": "HAIR COLORING", "subtitle": "\$20.50 · 40 min", "icon": Icons.brush},
    {"title": "BEARD TRIMMING", "subtitle": "\$20.50 · 40 min", "icon": Icons.content_cut},
    {"title": "BEARD STYLING", "subtitle": "\$20.50 · 40 min", "icon": Icons.face_4},
    {"title": "HAIR EXTENSIONS", "subtitle": "\$20.50 · 40 min", "icon": Icons.waves},
    {"title": "HAIR STYLING", "subtitle": "\$20.50 · 40 min", "icon": Icons.dry_cleaning},
    {"title": "HAIR TREATMENT", "subtitle": "\$20.50 · 40 min", "icon": Icons.spa},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          // Background Image
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: _CurvedClipper(),
              child: Container(
                height: 350.h,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/young-hispanic-haidresser-and-hairstylist-standing-2024-10-18-17-47-23-utc 1.png"),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
          // Foreground Content
          SafeArea(
            child: Column(
              children: [
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [_iconButton(Icons.arrow_back, () => Get.back()), _iconButton(Icons.bookmark_border, () {})],
                ),
                SizedBox(height: 170.h),
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [BoxShadow(color: white.withOpacity(0.5), blurRadius: 8, offset: Offset(0, -2))],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          10.verticalSpace,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _licensedTag(),
                              GestureDetector(
                                onTap: () => showProviderInfoBottomSheet(context),
                                child: Icon(Icons.info_outline, color: white, size: 20.sp),
                              ),
                            ],
                          ),

                          SizedBox(height: 6.h),

                          Text(
                            "RICHARD ANDERSON",
                            style: TextStyle(color: white, fontWeight: FontWeight.bold, fontSize: 18.sp),
                          ),
                          SizedBox(height: 2.h),

                          Text(
                            "134 North Square, New York",
                            style: TextStyle(color: Colors.white60, fontSize: 13.sp),
                          ),
                          SizedBox(height: 8.h),

                          Row(
                            children: [
                              Icon(Icons.star, color: kprimaryColor, size: 18.sp),
                              SizedBox(width: 4.w),
                              Text(
                                "4.9",
                                style: TextStyle(color: Colors.white, fontSize: 13.sp, fontWeight: FontWeight.w500),
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                "· 114 reviews",
                                style: TextStyle(color: Colors.white54, fontSize: 13.sp),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.h),

                          _timeSlot(),
                          SizedBox(height: 18.h),

                          ...services.map((s) => _buildService(s["title"], s["subtitle"], s["icon"])),
                          SizedBox(height: 24.h),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 65.h),
        child: SizedBox(
          height: 50.h,
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: kprimaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              Get.to(() => BookingScreen());
            },
            child: Text(
              "Book Now",
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16.sp),
            ),
          ),
        ),
      ),
    );
  }

  Widget _iconButton(IconData icon, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CircleAvatar(
        backgroundColor: ksecondaryColor,
        child: IconButton(
          icon: Icon(icon, color: white),
          onPressed: onTap,
        ),
      ),
    );
  }

  Widget _licensedTag() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(color: kprimaryColor, borderRadius: BorderRadius.circular(4)),
      child: Text(
        "Licensed",
        style: TextStyle(color: Colors.black, fontSize: 12.sp, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _timeSlot() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      decoration: BoxDecoration(color: ksecondaryColor, borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "FRIDAY, AUGUST 25",
                style: TextStyle(color: Colors.white70, fontSize: 12.sp),
              ),
              SizedBox(height: 4.h),
              Text(
                "15:00–16:00",
                style: TextStyle(color: white, fontSize: 14.sp, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              Get.to(() => DateTimeScreen());
            },

            child: Icon(Icons.edit, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildService(String title, String subtitle, IconData icon) {
    return Obx(() {
      final selected = ctrl.isSelected(title);
      return Container(
        margin: EdgeInsets.symmetric(vertical: 6.h),
        decoration: BoxDecoration(color: ksecondaryColor, borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          leading: Icon(icon, color: kprimaryColor),
          title: Text(title, style: TextStyle(color: white)),
          subtitle: Text(
            subtitle,
            style: TextStyle(color: Colors.white54, fontSize: 12.sp),
          ),
          trailing: Switch(
            value: selected,
            onChanged: (_) => ctrl.toggleService(title),
            activeColor: white,
            activeTrackColor: kprimaryColor,
            inactiveThumbColor: white,
            inactiveTrackColor: grey.withOpacity(0.5),
          ),
        ),
      );
    });
  }
}

class _CurvedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 80);
    path.quadraticBezierTo(size.width / 2, size.height, size.width, size.height - 80);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
