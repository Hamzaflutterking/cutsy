// ignore_for_file: use_build_context_synchronously

import 'package:cutcy/auth/login_screen.dart';
import 'package:cutcy/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/route_manager.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      Get.off(() => LoginScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      height: 1.sh,
      color: backgroundColor,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Image.asset("assets/icons/app icon (1)-01.png", scale: 25)]),
    );
  }
}
