// lib/controllers/bottom_nav_controller.dart
import 'package:get/get.dart';

class BottomNavController extends GetxController {
  /// 0 = Home, 1 = Calendar, 2 = Wallet, 3 = Profile
  final currentIndex = 0.obs;

  void changeIndex(int i) {
    currentIndex.value = i;
  }
}
