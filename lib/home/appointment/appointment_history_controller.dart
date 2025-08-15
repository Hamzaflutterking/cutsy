import 'package:get/get.dart';

// Model class for Appointment
class Appointment {
  final String name;
  final String price;
  final String date;

  Appointment({required this.name, required this.price, required this.date});
}

class AppointmentHistoryController extends GetxController {
  // Observable list of appointments
  var appointments = <Appointment>[
    Appointment(name: 'Richard Anderson', price: '\$123.00', date: 'Friday, August 25, 2025'),
    Appointment(name: 'Penny Hyper Barber', price: '\$123.00', date: 'Friday, August 25, 2025'),
    Appointment(name: 'Richard Anderson', price: '\$123.00', date: 'Friday, August 25, 2025'),
    Appointment(name: 'Penny Hyper Barber', price: '\$123.00', date: 'Friday, August 25, 2025'),
    Appointment(name: 'Richard Anderson', price: '\$123.00', date: 'Friday, August 25, 2025'),
    Appointment(name: 'Penny Hyper Barber', price: '\$123.00', date: 'Friday, August 25, 2025'),
  ].obs;
}
