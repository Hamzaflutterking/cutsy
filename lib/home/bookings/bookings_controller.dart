// import 'package:get/get.dart';

// class BookingController extends GetxController {
//   var selectedServices = <String>{}.obs;
//   var serviceQuantities = <String, int>{}.obs;

//   final double servicePrice = 20.50;
//   final double discount = 10.00;
//   final double platformFee = 5.00;

//   void toggleService(String service) {
//     if (selectedServices.contains(service)) {
//       selectedServices.remove(service);
//       serviceQuantities.remove(service);
//     } else {
//       selectedServices.add(service);
//       serviceQuantities[service] = 1;
//     }
//   }

//   void increment(String service) {
//     if (selectedServices.contains(service)) {
//       serviceQuantities[service] = (serviceQuantities[service] ?? 1) + 1;
//     }
//   }

//   void decrement(String service) {
//     if (selectedServices.contains(service)) {
//       final current = serviceQuantities[service] ?? 1;
//       if (current > 1) {
//         serviceQuantities[service] = current - 1;
//       }
//     }
//   }

//   bool isSelected(String service) => selectedServices.contains(service);

//   double get subTotal => selectedServices.fold(0.0, (sum, service) => sum + ((serviceQuantities[service] ?? 1) * servicePrice));

//   double get total => subTotal - discount + platformFee;
// }
// bookings_controller.dart
// bookings_controller.dart
import 'dart:convert';
import 'package:cutcy/main.dart';
import 'package:cutcy/services/Exceptions/app_exceptions.dart';
import 'package:cutcy/services/api_configs.dart';
import 'package:cutcy/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class BookingController extends GetxController {
  // ---- Barber / location ----
  final Rxn<String> barberId = Rxn<String>();
  final Rxn<String> locationName = Rxn<String>();
  final Rxn<double> locationLat = Rxn<double>();
  final Rxn<double> locationLng = Rxn<double>();
  void setBarberContext({required String id, String? locName, double? lat, double? lng}) {
    barberId.value = id;
    if (locName != null) locationName.value = locName;
    if (lat != null) locationLat.value = lat;
    if (lng != null) locationLng.value = lng;
  }

  // ---- Selected slot ----
  final Rxn<String> selectedDay = Rxn<String>(); // "SAT"
  final Rxn<String> selectedStart = Rxn<String>(); // "05:00 am"
  final Rxn<String> selectedEnd = Rxn<String>(); // "06:00 am"
  void setSlot({required String day, required String start, required String end}) {
    selectedDay.value = day;
    selectedStart.value = start;
    selectedEnd.value = end;
  }

  // ---- Services (IDs) ----
  final selectedServices = <String>{}.obs;
  final serviceQuantities = <String, int>{}.obs; // id -> qty
  final serviceMeta = <String, Map<String, dynamic>>{}.obs; // id -> {title, price(double)}

  void toggleServiceById(String id, {required String title, required double price}) {
    serviceMeta[id] = {"title": title, "price": price};
    serviceQuantities[id] = serviceQuantities[id] ?? 1;
    if (selectedServices.remove(id)) {
      serviceQuantities.remove(id);
      serviceMeta.remove(id);
    } else {
      selectedServices.add(id);
    }
  }

  bool isSelected(String id) => selectedServices.contains(id);
  void increment(String id) => selectedServices.contains(id) ? serviceQuantities[id] = (serviceQuantities[id] ?? 1) + 1 : null;
  void decrement(String id) {
    if (!selectedServices.contains(id)) return;
    final c = serviceQuantities[id] ?? 1;
    serviceQuantities[id] = c > 1 ? c - 1 : 1;
  }

  // ---- Totals ----
  final double discount = 10.00;
  final double platformFee = 5.00;
  double get subTotal {
    double s = 0;
    for (final id in selectedServices) {
      final p = (serviceMeta[id]?['price'] as double?) ?? 0;
      final q = serviceQuantities[id] ?? 1;
      s += p * q;
    }
    return s;
  }

  double get total => subTotal - discount + platformFee;

  // ---- API payload & call ----
  Map<String, dynamic> buildPayloadForApi() {
    String _to24(String? t) {
      if (t == null) return '';
      // "05:00 am" -> "05:00", "06:00 pm" -> "06:00" (server example uses HH:mm)
      final m = RegExp(r'^(\d{1,2}:\d{2})').firstMatch(t);
      return m?.group(1) ?? t;
    }

    return {
      "barberId": barberId.value,
      "day": (selectedDay.value ?? '').toLowerCase(), // "sat"
      "startTime": _to24(selectedStart.value), // "05:00"
      "endTime": _to24(selectedEnd.value), // "06:00"
      "amount": total.toStringAsFixed(0), // server expects string
      "locationName": locationName.value,
      "locationLat": locationLat.value,
      "locationLng": locationLng.value,
      "services": selectedServices.toList(), // service IDs
    };
  }

  final isPlacing = false.obs;
  final Rxn<String> lastError = Rxn<String>();

  // Future<bool> createBookingAndPayment({required String token}) async {
  //   if (barberId.value == null || selectedDay.value == null || selectedStart.value == null || selectedEnd.value == null || selectedServices.isEmpty) {
  //     lastError.value = "Please select a time and at least one service.";
  //     return false;
  //   }

  //   final url = Uri.parse('http://192.168.1.20:4000/api/v1/user/booking/createBookingAndPayment');
  //   final headers = {'x-access-token': token, 'Content-Type': 'application/json'};
  //   final body = json.encode(buildPayloadForApi());

  //   isPlacing.value = true;
  //   lastError.value = null;
  //   try {
  //     final req = http.Request('POST', url)
  //       ..headers.addAll(headers)
  //       ..body = body;
  //     final res = await req.send();
  //     if (res.statusCode >= 200 && res.statusCode < 300) return true;
  //     lastError.value = await res.stream.bytesToString();
  //     return false;
  //   } catch (e) {
  //     lastError.value = e.toString();
  //     return false;
  //   } finally {
  //     isPlacing.value = false;
  //   }
  // }

  Future<bool> createBookingAndPayment() async {
    if (barberId.value == null || selectedDay.value == null || selectedStart.value == null || selectedEnd.value == null || selectedServices.isEmpty) {
      lastError.value = "Please select a time and at least one service.";
      return false;
    }

    isPlacing.value = true;
    lastError.value = null;

    try {
      // make sure token is set on the shared api service
      apiService.setToken(StorageService.to.getString("token") ?? "");

      final payload = buildPayloadForApi(); // <- your builder returning Map<String, dynamic>

      final res = await apiService.request(ApiConfig.userCreateBookingAndPayment, method: "POST", body: payload);

      // If your API returns { success: true } you can optionally check it:
      // final ok = (res is Map && res["success"] == true);
      // return ok;

      return true; // reached without exception = good
    } on UnauthorizedException catch (e) {
      lastError.value = e.toString();
      return false;
    } on NotFoundException catch (e) {
      lastError.value = e.toString();
      return false;
    } catch (e) {
      lastError.value = e.toString();
      return false;
    } finally {
      isPlacing.value = false;
    }
  }
}
