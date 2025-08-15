// views/confirm_location_screen.dart
// ignore_for_file: use_key_in_widget_constructors

import 'package:cutcy/constants/constants.dart';
import 'package:cutcy/locations/location_controller.dart';
import 'package:cutcy/widgets/AppButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ConfirmLocationScreen extends StatelessWidget {
  final controller = Get.find<LocationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ✅ Interactive map
          Obx(
            () => FlutterMap(
              mapController: MapController(),
              options: MapOptions(
                initialCenter: controller.selectedLatLng.value,
                initialZoom: 14.0,
                onTap: (tapPosition, latLng) {
                  controller.updateLocation(latLng);
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                  userAgentPackageName: 'com.example.cutcy',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: controller.selectedLatLng.value,
                      width: 40.w,
                      height: 40.h,
                      child: Icon(Icons.location_pin, size: 40.sp, color: kprimaryColor),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ✅ Bottom location confirm section
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Obx(
                () => Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Confirm your location", style: TextStyle(color: white, fontSize: 25)),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: kprimaryColor, size: 80),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            controller.selectedAddress.value.isNotEmpty ? controller.selectedAddress.value : "Tap on the map to select location",
                            style: const TextStyle(color: white, fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 50.h),
                    AuthButton(text: "Continue", onTap: controller.confirmLocation),
                    SizedBox(height: 80.h),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
