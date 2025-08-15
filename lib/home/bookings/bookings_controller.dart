import 'package:get/get.dart';

class BookingController extends GetxController {
  var selectedServices = <String>{}.obs;
  var serviceQuantities = <String, int>{}.obs;

  final double servicePrice = 20.50;
  final double discount = 10.00;
  final double platformFee = 5.00;

  void toggleService(String service) {
    if (selectedServices.contains(service)) {
      selectedServices.remove(service);
      serviceQuantities.remove(service);
    } else {
      selectedServices.add(service);
      serviceQuantities[service] = 1;
    }
  }

  void increment(String service) {
    if (selectedServices.contains(service)) {
      serviceQuantities[service] = (serviceQuantities[service] ?? 1) + 1;
    }
  }

  void decrement(String service) {
    if (selectedServices.contains(service)) {
      final current = serviceQuantities[service] ?? 1;
      if (current > 1) {
        serviceQuantities[service] = current - 1;
      }
    }
  }

  bool isSelected(String service) => selectedServices.contains(service);

  double get subTotal => selectedServices.fold(0.0, (sum, service) => sum + ((serviceQuantities[service] ?? 1) * servicePrice));

  double get total => subTotal - discount + platformFee;
}
