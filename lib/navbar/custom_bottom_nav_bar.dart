// lib/widgets/custom_bottom_nav_bar.dart
// ignore_for_file: use_super_parameters

import 'package:cutcy/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavBar({Key? key, required this.currentIndex, required this.onTap}) : super(key: key);

  static const _icons = ['assets/icons/HouseSimple.png', 'assets/icons/CalendarDots.png', 'assets/icons/Wallet.png', 'assets/icons/UserCircle.png'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 30.h),
        decoration: BoxDecoration(
          color: ksecondaryColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(35.r)),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(_icons.length, (i) {
            final isActive = i == currentIndex;
            return GestureDetector(
              onTap: () => onTap(i),
              behavior: HitTestBehavior.opaque,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(_icons[i], width: 24.w, height: 35.h, color: isActive ? kprimaryColor : grey),
                  SizedBox(height: 6.h),
                  if (isActive)
                    Container(
                      width: 16.w,
                      height: 4.h,
                      decoration: BoxDecoration(color: kprimaryColor, borderRadius: BorderRadius.circular(2.r)),
                    ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
