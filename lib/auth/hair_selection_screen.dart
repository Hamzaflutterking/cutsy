// ignore_for_file: deprecated_member_use

import 'package:cutcy/constants/constants.dart';
import 'package:cutcy/auth/auth_controller.dart';
import 'package:cutcy/widgets/AppButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HairSelectionScreen extends StatefulWidget {
  const HairSelectionScreen({super.key});

  @override
  State<HairSelectionScreen> createState() => _HairSelectionScreenState();
}

class _HairSelectionScreenState extends State<HairSelectionScreen> {
  final AuthController controller = Get.find();

  final LayerLink layerLink1 = LayerLink();
  final LayerLink layerLink2 = LayerLink();
  OverlayEntry? hairTypeOverlay;
  OverlayEntry? hairLengthOverlay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 36.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Please specify your\nhair type and length.",
                    style: TextStyle(color: white, fontSize: 24.sp, fontWeight: FontWeight.bold),
                  ),
                  40.verticalSpace,

                  // Hair Type Dropdown
                  CompositedTransformTarget(
                    link: layerLink1,
                    child: Obx(
                      () => _buildDropdownButton(
                        label: "Select Hair Type",
                        selected: controller.selectedHairType.value,
                        onTap: () => _toggleDropdown(context, isHairType: true),
                      ),
                    ),
                  ),

                  20.verticalSpace,

                  // Hair Length Dropdown
                  CompositedTransformTarget(
                    link: layerLink2,
                    child: Obx(
                      () => _buildDropdownButton(
                        label: "Select Hair Length",
                        selected: controller.selectedHairLength.value,
                        onTap: () => _toggleDropdown(context, isHairType: false),
                      ),
                    ),
                  ),

                  const Spacer(),

                  AuthButton(text: "Save and Continue", onTap: controller.saveHairSelection, textColor: black),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownButton({required String label, required String selected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 50.h,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white30),
          borderRadius: BorderRadius.circular(8.r),
          color: Colors.transparent,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              selected.isEmpty ? label : selected,
              style: TextStyle(color: selected.isEmpty ? Colors.white70 : white, fontSize: 16.sp),
            ),
            const Icon(Icons.keyboard_arrow_down, color: white),
          ],
        ),
      ),
    );
  }

  void _toggleDropdown(BuildContext context, {required bool isHairType}) {
    final isOpen = isHairType ? hairTypeOverlay != null : hairLengthOverlay != null;

    if (isOpen) {
      _removeDropdown(isHairType: isHairType);
    } else {
      _showDropdown(context, isHairType: isHairType);
    }
  }

  void _removeDropdown({required bool isHairType}) {
    final currentOverlay = isHairType ? hairTypeOverlay : hairLengthOverlay;
    currentOverlay?.remove();
    if (isHairType) {
      hairTypeOverlay = null;
    } else {
      hairLengthOverlay = null;
    }
  }

  void _showDropdown(BuildContext context, {required bool isHairType}) {
    final items = isHairType ? controller.hairTypes : controller.hairLengths;
    final link = isHairType ? layerLink1 : layerLink2;
    final setter = isHairType ? controller.selectedHairType : controller.selectedHairLength;

    final overlay = OverlayEntry(
      builder: (context) => Positioned(
        width: MediaQuery.of(context).size.width - 48.w,
        child: CompositedTransformFollower(
          link: link,
          showWhenUnlinked: false,
          offset: Offset(0, 60.h),
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: Colors.white24),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: items.map((item) {
                  return InkWell(
                    onTap: () {
                      setter.value = item;
                      _removeDropdown(isHairType: isHairType);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(item, style: const TextStyle(color: white)),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(overlay);
    if (isHairType) {
      hairTypeOverlay = overlay;
    } else {
      hairLengthOverlay = overlay;
    }
  }
}
