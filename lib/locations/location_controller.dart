// controllers/location_controller.dart
import 'package:cutcy/locations/address_details_scree.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class LocationController extends GetxController {
  Rx<LatLng> selectedLatLng = LatLng(43.651070, -79.347015).obs;
  RxString selectedAddress = ''.obs;
  RxString searchText = ''.obs;

  void updateLocation(LatLng latLng) {
    selectedLatLng.value = latLng;

    selectedAddress.value = "134 North Square, Toronto, CA";
  }

  void confirmLocation() {
    Get.to(() => AddressDetailScreen());
  }
}
