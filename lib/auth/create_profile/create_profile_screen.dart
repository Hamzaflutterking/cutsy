// create_profile_screen.dart
import 'package:cutcy/constants/constants.dart';
import 'package:cutcy/widgets/AppTextFiled.dart';
import 'package:cutcy/widgets/AppButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import 'create_profile_controller.dart';

class CreateProfileScreen extends StatelessWidget {
  CreateProfileScreen({super.key});

  final c = Get.put(CreateProfileController());
  final mapC = MapController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Create Profile",
                style: TextStyle(color: white, fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 18),

              // ===== Basic Info =====
              Row(
                children: [
                  Expanded(
                    child: AuthTextField(controller: c.firstNameC, hintText: 'First name'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AuthTextField(controller: c.lastNameC, hintText: 'Last name'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              AuthTextField(controller: c.phoneC, hintText: 'Phone', keyboardType: TextInputType.phone),

              const SizedBox(height: 18),

              // ===== Gender =====
              Text(
                "Gender",
                style: TextStyle(color: white.withValues(alpha: 0.9), fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Obx(
                () => Row(
                  children: [
                    _GenderChip(label: "Male", value: "MALE", selected: c.gender.value == 'MALE', onTap: () => c.setGender('MALE')),
                    const SizedBox(width: 12),
                    _GenderChip(label: "Female", value: "FEMALE", selected: c.gender.value == 'FEMALE', onTap: () => c.setGender('FEMALE')),
                    const SizedBox(width: 12),
                    _GenderChip(label: "Other", value: "OTHER", selected: c.gender.value == 'OTHER', onTap: () => c.setGender('OTHER')),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // ===== Hair Type / Length =====
              Text(
                "Hair Details",
                style: TextStyle(color: white.withValues(alpha: 0.9), fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),

              Obx(
                () => Row(
                  children: [
                    Expanded(
                      child: _PickerTile(
                        label: c.hairTypeLoading.value ? 'Loading hair types…' : (c.selectedHairType.value?.label ?? "Select Hair Type"),
                        onTap: c.hairTypeLoading.value ? null : c.openHairTypePicker,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _PickerTile(
                        label: c.hairLengthLoading.value ? 'Loading hair lengths…' : (c.selectedHairLength.value?.label ?? "Select Hair Length"),
                        onTap: c.hairLengthLoading.value ? null : c.openHairLengthPicker,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ===== Map & Address =====
              Text(
                "Address",
                style: TextStyle(color: white.withValues(alpha: 0.9), fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),

              // Search box with suggestions
              _SearchWithSuggestions(
                controller: c.addressQueryC,
                onChanged: c.onAddressQueryChanged,
                suggestions: c.suggestions,
                onSuggestionTap: c.selectSuggestion,
              ),
              const SizedBox(height: 10),

              // Map
              SizedBox(
                height: 220,
                child: Obx(
                  () => Stack(
                    children: [
                      FlutterMap(
                        mapController: mapC,
                        options: MapOptions(
                          interactionOptions: InteractionOptions(doubleTapZoomCurve: Curves.fastOutSlowIn),
                          initialCenter: c.selectedLatLng.value,
                          initialZoom: 14,
                          onTap: (tapPos, latLng) async {
                            c.selectedLatLng.value = latLng;
                            await c.reverseGeocode(latLng);
                          },
                        ),
                        children: [
                          TileLayer(
                            urlTemplate: "https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png",
                            subdomains: const ['a', 'b', 'c'],
                            userAgentPackageName: 'com.example.cutcy',
                          ),
                          MarkerLayer(
                            markers: [
                              Marker(
                                point: c.selectedLatLng.value,
                                width: 40,
                                height: 40,
                                child: const Icon(Icons.location_pin, size: 40, color: kprimaryColor),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Positioned(
                        right: 10,
                        top: 10,
                        child: Material(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(28),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(28),
                            onTap: () async {
                              await c.centerOnGps();
                              mapC.move(c.selectedLatLng.value, 15);
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Icon(Icons.my_location, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Address fields
              AuthTextField(controller: c.addressNameC, hintText: 'Address (auto or manual)'),
              const SizedBox(height: 10),
              AuthTextField(controller: c.addressLine1C, hintText: 'Address Line 1'),
              const SizedBox(height: 10),
              AuthTextField(controller: c.addressLine2C, hintText: 'Address Line 2 (optional)'),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: AuthTextField(controller: c.cityC, hintText: 'City'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AuthTextField(controller: c.stateC, hintText: 'State'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: AuthTextField(controller: c.postalC, hintText: 'Postal Code'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AuthTextField(controller: c.countryC, hintText: 'Country'),
                  ),
                ],
              ),

              const SizedBox(height: 22),
              Obx(
                () => AuthButton(
                  isLoading: c.isLoading.value,
                  text: c.isLoading.value ? 'Saving…' : 'Save Profile',
                  onTap: c.isLoading.value ? null : c.submitProfile,
                  textColor: Colors.black,
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class _PickerTile extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  const _PickerTile({required this.label, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: Colors.white30),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(label, style: TextStyle(color: label.startsWith('Select') ? Colors.white70 : white)),
            ),
            const Icon(Icons.keyboard_arrow_down, color: white),
          ],
        ),
      ),
    );
  }
}

class _GenderChip extends StatelessWidget {
  final String label;
  final String value;
  final bool selected;
  final VoidCallback onTap;
  const _GenderChip({super.key, required this.label, required this.value, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? kprimaryColor : Colors.black87,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: selected ? kprimaryColor : Colors.white24),
        ),
        child: Text(label, style: TextStyle(color: selected ? Colors.black : Colors.white)),
      ),
    );
  }
}

class _SearchWithSuggestions extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String) onChanged;
  final RxList<Map<String, dynamic>> suggestions;
  final void Function(Map<String, dynamic>) onSuggestionTap;

  const _SearchWithSuggestions({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.suggestions,
    required this.onSuggestionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // search field
        Container(
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white24),
          ),
          child: Row(
            children: [
              // const SizedBox(width: 12),
              // const Icon(Icons.search, color: kprimaryColor),
              // const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: controller,
                  onChanged: onChanged,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    suffixIcon: Icon(Icons.search, color: kprimaryColor),
                    hintText: 'Search address',
                    hintStyle: TextStyle(color: Colors.white60),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // suggestions list
        Obx(() {
          if (suggestions.isEmpty) return const SizedBox.shrink();
          return Container(
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white24),
            ),
            child: Column(
              children: suggestions
                  .map(
                    (s) => ListTile(
                      dense: true,
                      leading: const Icon(Icons.location_on, color: kprimaryColor),
                      title: Text(
                        (s['display_name'] ?? '') as String,
                        style: const TextStyle(color: Colors.white),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () => onSuggestionTap(s),
                    ),
                  )
                  .toList(),
            ),
          );
        }),
      ],
    );
  }
}
