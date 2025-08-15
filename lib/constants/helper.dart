import 'package:cutcy/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showCustomSnackbar({
  required String title,
  required String message,
  Color backgroundColor = kprimaryColor,
  Color textColor = black,
  IconData icon = Icons.error_outline,
}) {
  Get.showSnackbar(
    GetSnackBar(
      titleText: Text(
        title,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
      ),
      messageText: Text(message, style: TextStyle(fontSize: 14, color: textColor)),
      icon: Icon(icon, color: textColor),
      backgroundColor: backgroundColor,
      borderRadius: 12,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      duration: const Duration(seconds: 3),
      snackPosition: SnackPosition.TOP,
      isDismissible: true,
    ),
  );
}
