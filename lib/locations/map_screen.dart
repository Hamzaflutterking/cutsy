// ignore_for_file: use_key_in_widget_constructors

import 'package:cutcy/constants/constants.dart';
import 'package:cutcy/locations/confirm_location_screen.dart';
import 'package:cutcy/locations/location_controller.dart';
import 'package:cutcy/locations/search_screen.dart';
import 'package:cutcy/widgets/AppButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MapScreen extends StatelessWidget {
  final controller = Get.put(LocationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Obx(
            () => FlutterMap(
              mapController: MapController(),
              options: MapOptions(
                initialCenter: controller.selectedLatLng.value,
                initialZoom: 14.0,
                onTap: (tapPosition, latLng) => controller.updateLocation(latLng),
              ),
              children: [
                // ✅ Updated tile layer (Carto)
                TileLayer(
                  urlTemplate: "https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                  userAgentPackageName: 'com.example.cutcy',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: controller.selectedLatLng.value,
                      width: 40,
                      height: 40,
                      child: const Icon(Icons.location_pin, size: 40, color: kprimaryColor),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Enter your address", style: TextStyle(color: white)),
                  GestureDetector(
                    onTap: () async {
                      final result = await Get.to(() => SearchScreen());
                      if (result != null) {
                        controller.selectedAddress.value = result;
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: grey),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.location_on, color: kprimaryColor),
                          SizedBox(width: 8),
                          Text("Search", style: TextStyle(color: white)),
                        ],
                      ),
                    ),
                  ),
                  10.verticalSpace,
                  AuthButton(text: "Continue", onTap: () => Get.to(() => ConfirmLocationScreen())),
                  30.verticalSpace,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
