// lib/screens/main_screen.dart

// ignore_for_file: unused_shown_name

import 'package:cutcy/home/appointment/appointment_screen.dart';
import 'package:cutcy/home/home/home_screen.dart';
import 'package:cutcy/home/profile/profile_screen.dart';
import 'package:cutcy/navbar/bottom_nav_controller.dart';
import 'package:cutcy/navbar/custom_bottom_nav_bar.dart';
import 'package:cutcy/payment/wallet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});

  final BottomNavController navC = Get.put(BottomNavController());

  // Replace these with your actual page widgets:
  final _pages = [
    HomeScreen(),
    AppointmentScreen(),

    WalletScreen(), // Replace WalletController() with the actual WalletScreen widget
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.grey[900],
      body: Obx(() => _pages[navC.currentIndex.value]),
      bottomNavigationBar: Obx(() => CustomBottomNavBar(currentIndex: navC.currentIndex.value, onTap: navC.changeIndex)),
    );
  }
}
