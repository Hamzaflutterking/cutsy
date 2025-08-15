// ignore_for_file: unnecessary_import

import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class NotificationController extends GetxController {
  // Dummy notifications (replace with API call if needed)
  final notifications = [
    "Don't forget! Your appointment is just around the corner.",
    "Your next hair transformation awaits! Confirm your booking now!",
    "Looking to freshen up that look? Book your next appointment today!",
  ].obs;
}
