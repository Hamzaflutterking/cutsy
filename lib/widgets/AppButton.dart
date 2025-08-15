// ignore_for_file: use_super_parameters, file_names

import 'package:cutcy/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool isOutlined;
  final double? width;
  final Color? textColor;
  final double? height;
  final EdgeInsetsGeometry? margin;
  final Widget? child; // <-- add this

  const AuthButton({
    Key? key,
    required this.text,
    required this.onTap,
    this.isOutlined = false,
    this.width,
    this.textColor,
    this.height,
    this.margin,
    this.child, // <-- add this
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color borderColor = kprimaryColor;
    final Color defaultTextColor = isOutlined ? borderColor : black;

    return Container(
      margin: margin ?? EdgeInsets.symmetric(horizontal: 0.w),
      width: width ?? double.infinity,
      height: height ?? 46.h,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: isOutlined ? white : borderColor,
          foregroundColor: textColor ?? defaultTextColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.r),
            side: isOutlined ? BorderSide(color: borderColor, width: 1) : BorderSide.none,
          ),
        ),
        child:
            child ??
            Text(
              text,
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, fontFamily: 'SF Pro Display'),
            ),
      ),
    );
  }
}
