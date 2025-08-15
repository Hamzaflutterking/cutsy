// ignore_for_file: use_super_parameters, deprecated_member_use, file_names

import 'package:cutcy/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CustomConfirmDialog extends StatelessWidget {
  final Widget? topImage; // You can pass an Icon, Image.asset, etc.
  final String? title;
  final String? message;
  final String? positiveButtonText;
  final String? negativeButtonText;
  final VoidCallback? onPositive;
  final VoidCallback? onNegative;
  final Color? backgroundColor; // Optional background color

  const CustomConfirmDialog({
    Key? key,
    this.topImage,
    this.title,
    this.message,
    this.positiveButtonText,
    this.negativeButtonText,
    this.onPositive,
    this.onNegative,
    this.backgroundColor, // Allow background color to be passed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: backgroundColor ?? ksecondaryColor, // Use passed background color or default
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 26),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (topImage != null) Padding(padding: const EdgeInsets.only(bottom: 16), child: topImage!),
            if (title != null)
              Text(
                title!,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w700, color: kprimaryColor, fontSize: 20),
              ),
            if (message != null)
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 20),
                child: Text(
                  message!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 15),
                ),
              ),
            if (positiveButtonText != null)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kprimaryColor,
                    foregroundColor: black,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 0,
                  ),
                  onPressed: onPositive ?? () => Get.back(result: true),
                  child: Text(positiveButtonText!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            10.verticalSpace,
            if (negativeButtonText != null)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kprimaryColor,
                    foregroundColor: black,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 0,
                  ),
                  onPressed: onNegative ?? () => Get.back(result: false),
                  child: Text(negativeButtonText!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
