// lib/controllers/appointment_controller.dart
import 'package:cutcy/home/appointment/appointment_details_screen.dart';
import 'package:get/get.dart';

/// Simple model for an appointment
class Appointment {
  final String name;
  final DateTime date;
  final double price;

  Appointment({required this.name, required this.date, required this.price});
}

class AppointmentController extends GetxController {
  /// 0 = Upcoming, 1 = Ongoing, 2 = Past
  final selectedTab = 0.obs;

  /// Dummy data
  final upcoming = <Appointment>[
    Appointment(name: 'Richard Anderson', date: DateTime(2025, 8, 25), price: 123),
    Appointment(name: 'Penny Hyper Barber', date: DateTime(2025, 8, 25), price: 123),
  ];
  final ongoing = <Appointment>[
    Appointment(name: 'Penny Hyper Barber', date: DateTime(2025, 8, 25), price: 123),
    Appointment(name: 'Richard Anderson', date: DateTime(2025, 8, 25), price: 123),
  ];
  final past = <Appointment>[
    Appointment(name: 'Richard Anderson', date: DateTime(2025, 8, 25), price: 123),
    Appointment(name: 'Penny Hyper Barber', date: DateTime(2025, 8, 25), price: 123),
  ];

  /// Here’s the missing piece:
  /// holds whichever Appointment you tapped
  final selectedAppointment = Rxn<Appointment>();

  /// Switch tabs
  void changeTab(int idx) => selectedTab.value = idx;

  /// Call this onTap of the list item:
  void selectAppointment(Appointment appt) {
    selectedAppointment.value = appt;
    // navigate to details screen
    Get.to(() => AppointmentDetailsScreen());
  }

  // date and time things
  RxInt selectedDateIndex = 0.obs;
  RxSet<String> selectedTimeSlots = <String>{}.obs;

  final List<DateTime> availableDates = List.generate(7, (index) => DateTime.now().add(Duration(days: index)));

  final List<String> timeSlots = [
    '08:00 - 09:00',
    '09:00 - 10:00',
    '10:00 - 11:00',
    '11:00 - 12:00',
    '12:00 - 13:00',
    '13:00 - 14:00',
    '14:00 - 15:00',
    '15:00 - 16:00',
    '16:00 - 17:00',
    '17:00 - 18:00',
    '18:00 - 19:00',
    '19:00 - 20:00',
    '20:00 - 21:00',
    '21:00 - 22:00',
    '22:00 - 23:00',
    '23:00 - 24:00',
  ];

  void toggleTimeSlot(String slot) {
    if (selectedTimeSlots.contains(slot)) {
      selectedTimeSlots.remove(slot);
    } else {
      selectedTimeSlots.add(slot);
    }
  }
}
