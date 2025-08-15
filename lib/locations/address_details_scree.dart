// ignore_for_file: deprecated_member_use

import 'package:cutcy/constants/constants.dart';
import 'package:cutcy/payment/payment_method_screen.dart';
import 'package:cutcy/widgets/AppButton.dart';
import 'package:cutcy/widgets/border_text_field.dart'; // ✅ Your new input field
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class AddressDetailScreen extends StatelessWidget {
  AddressDetailScreen({super.key});

  // ✅ Text controllers for all fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController line1Controller = TextEditingController();
  final TextEditingController line2Controller = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController postalController = TextEditingController();
  final TextEditingController countryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          // ✅ Map Background
          FlutterMap(
            options: MapOptions(initialCenter: LatLng(43.651070, -79.347015), initialZoom: 14),
            children: [
              TileLayer(
                urlTemplate: "https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
                userAgentPackageName: 'com.example.cutcy',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: LatLng(43.651070, -79.347015),
                    width: 40,
                    height: 40,
                    child: Icon(Icons.location_pin, color: black, size: 40),
                  ),
                ],
              ),
            ],
          ),

          // ✅ Address Form Overlay
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Address Details", style: TextStyle(color: white, fontSize: 20)),
                    SizedBox(height: 8),
                    Text("Complete address would assist us better in serving you.", style: TextStyle(color: kprimaryColor)),
                    SizedBox(height: 20),
                    BorderTextField(label: "Full Name", hint: "Enter Name", controller: nameController),
                    SizedBox(height: 12),
                    BorderTextField(label: "Address Line 1", hint: "Street Address", controller: line1Controller),
                    SizedBox(height: 12),
                    BorderTextField(label: "Address Line 2", hint: "Apt, Suite, etc. (optional)", controller: line2Controller),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: BorderTextField(label: "City/Town", hint: "City", controller: cityController),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: BorderTextField(label: "State/Province", hint: "State", controller: stateController),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: BorderTextField(label: "Postal Code", hint: "ZIP", controller: postalController),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: BorderTextField(label: "Country", hint: "Country", controller: countryController),
                        ),
                      ],
                    ),
                    SizedBox(height: 24),
                    AuthButton(
                      textColor: black,
                      text: "Save and Continue",
                      onTap: () {
                        Get.to(() => AddPaymentMethodScreen());
                      },
                    ),
                    SizedBox(height: 30),
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
