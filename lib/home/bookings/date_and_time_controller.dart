// import 'package:get/get.dart';

// class DateTimeController extends GetxController {
//   RxInt selectedDateIndex = 0.obs;
//   RxSet<String> selectedTimeSlots = <String>{}.obs;

//   final List<DateTime> availableDates = List.generate(7, (index) => DateTime.now().add(Duration(days: index)));

//   final List<String> timeSlots = [
//     '08:00 - 09:00',
//     '09:00 - 10:00',
//     '10:00 - 11:00',
//     '11:00 - 12:00',
//     '12:00 - 13:00',
//     '13:00 - 14:00',
//     '14:00 - 15:00',
//     '15:00 - 16:00',
//     '16:00 - 17:00',
//     '17:00 - 18:00',
//     '18:00 - 19:00',
//     '19:00 - 20:00',
//     '20:00 - 21:00',
//     '21:00 - 22:00',
//     '22:00 - 23:00',
//     '23:00 - 24:00',
//   ];

//   void toggleTimeSlot(String slot) {
//     if (selectedTimeSlots.contains(slot)) {
//       selectedTimeSlots.remove(slot);
//     } else {
//       selectedTimeSlots.add(slot);
//     }
//   }
// }
// home/bookings/date_and_time_controller.dart
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:cutcy/home/homes/barber_model.dart';
import 'package:cutcy/home/bookings/bookings_controller.dart';

class DateTimeController extends GetxController {
  DateTimeController({required this.barber});
  final BarberData barber;

  final selectedDateIndex = 0.obs;
  final selectedSlot = RxnString(); // SINGLE selection like "05:00 am - 06:00 am"
  final timeSlots = <String>[].obs; // visible slots for the chosen day
  late final List<DateTime> availableDates; // next 14 days

  @override
  void onInit() {
    super.onInit();
    final now = DateTime.now();
    availableDates = List.generate(14, (i) => DateTime(now.year, now.month, now.day).add(Duration(days: i)));
    _computeForIndex(0);
    ever<int>(selectedDateIndex, _computeForIndex);
  }

  void selectSlot(String slot) => selectedSlot.value = slot;

  void _computeForIndex(int index) {
    if (index < 0 || index >= availableDates.length) return;
    final date = availableDates[index];

    // 'MON','TUE','WED','THU','FRI','SAT','SUN'
    final dow = DateFormat('EEE').format(date).toUpperCase().substring(0, 3);

    final hours = barber.barberAvailableHour ?? const [];
    final slotsForDay = hours.where((h) => (h.day ?? '').toUpperCase() == dow);

    // Make "05:00 am - 06:00 am"
    final asStrings = slotsForDay
        .map((h) {
          final start = (h.startTime ?? '').trim();
          final end = (h.endTime ?? '').trim();
          if (start.isEmpty || end.isEmpty) return '';
          return "$start - $end";
        })
        .where((s) => s.isNotEmpty)
        .toList();

    timeSlots.assignAll(asStrings);

    // if current selected is not in new list -> clear
    if (selectedSlot.value != null && !timeSlots.contains(selectedSlot.value)) {
      selectedSlot.value = null;
    }
  }

  /// Push selection to BookingController and close
  void saveToBookingAndClose() {
    if (selectedSlot.value == null) {
      Get.snackbar("Pick a time", "Please select an available slot");
      return;
    }
    final booking = Get.find<BookingController>();

    // day of week from the currently selected date
    final date = availableDates[selectedDateIndex.value];
    final dow = DateFormat('EEE').format(date).toUpperCase().substring(0, 3);

    final parts = selectedSlot.value!.split(' - ');
    final start = parts[0].trim(); // e.g. "05:00 am"
    final end = parts[1].trim(); // e.g. "06:00 am"

    // barber + location context
    final addr = (barber.addressName?.isNotEmpty ?? false)
        ? barber.addressName!
        : [barber.addressLine1, barber.city, barber.country].where((e) => (e ?? '').isNotEmpty).join(', ');

    booking
      ..setBarberContext(id: barber.id ?? '', locName: addr, lat: barber.latitude, lng: barber.longitude)
      ..setSlot(day: dow, start: start, end: end);

    Get.back(result: {"day": dow, "start": start, "end": end});
  }
}
