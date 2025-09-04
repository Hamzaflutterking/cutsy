// ignore_for_file: deprecated_member_use, avoid_print

import 'dart:ui';
import 'dart:async';

import 'package:cutcy/constants/constants.dart';
import 'package:cutcy/home/appointment/appointment_chat_screen.dart';
import 'package:cutcy/home/appointment/appointment_start_screen.dart';
import 'package:cutcy/home/appointment/appointment_controller.dart';
import 'package:cutcy/navbar/bottom_nav_controller.dart';
import 'package:cutcy/navbar/main_navbar.dart';
import 'package:cutcy/widgets/AppButton.dart';
import 'package:cutcy/widgets/Appdilogbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class TrackBarberScreen extends StatefulWidget {
  const TrackBarberScreen({super.key});

  @override
  State<TrackBarberScreen> createState() => _TrackBarberScreenState();
}

class _TrackBarberScreenState extends State<TrackBarberScreen> with TickerProviderStateMixin {
  bool isRideAccepted = false;
  late Timer _timer;
  int _secondsRemaining = 5;

  // Draggable sheet controller
  late DraggableScrollableController _dragController;

  // Animation controller for smooth transitions
  late AnimationController _animationController;
  late Animation<double> _animation;

  // Map controller
  final MapController _mapController = MapController();

  // Selected appointment data
  final AppointmentController appointmentCtrl = Get.find<AppointmentController>();

  // Reactive variables for locations
  final Rx<LatLng?> userLocation = Rx<LatLng?>(null);
  final Rx<LatLng?> barberLocation = Rx<LatLng?>(null);
  final RxList<LatLng> polylinePoints = <LatLng>[].obs;

  // Draggable sheet state
  final RxDouble currentSheetSize = 0.4.obs;
  final RxBool isExpanded = false.obs;

  @override
  void initState() {
    super.initState();

    _dragController = DraggableScrollableController();
    _animationController = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
    _animation = CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);

    _initializeLocations();
    _startTimer();
  }

  void _initializeLocations() {
    final appointment = appointmentCtrl.selectedAppointment.value;

    if (appointment != null) {
      // Set user location from appointment
      if (appointment.locationLat != null && appointment.locationLng != null) {
        userLocation.value = LatLng(appointment.locationLat!, appointment.locationLng!);
      } else {
        // Fallback to default user location (Toronto downtown)
        userLocation.value = LatLng(43.665, -79.398);
      }

      // Set barber location from appointment
      if (appointment.barber?.latitude != null && appointment.barber?.longitude != null) {
        barberLocation.value = LatLng(appointment.barber!.latitude!, appointment.barber!.longitude!);
      } else {
        // Fallback to default barber location (nearby)
        barberLocation.value = LatLng(43.668, -79.394);
      }

      // Generate polyline points
      if (userLocation.value != null && barberLocation.value != null) {
        _generatePolyline();
      }

      // Fit map to show both locations
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _fitMapToLocations();
      });
    }
  }

  void _generatePolyline() {
    if (userLocation.value != null && barberLocation.value != null) {
      // For now, create a simple straight line
      // In a real app, you'd use a routing service like Google Directions API
      polylinePoints.value = [barberLocation.value!, userLocation.value!];
    }
  }

  // void _fitMapToLocations() {
  //   if (userLocation.value != null && barberLocation.value != null) {
  //     final bounds = LatLngBounds.fromPoints([userLocation.value!, barberLocation.value!]);
  //     _mapController.fitBounds(bounds, options: const FitBoundsOptions(padding: EdgeInsets.all(50)));
  //   }
  // }

  void _fitMapToLocations() {
    if (userLocation.value != null && barberLocation.value != null) {
      // Calculate the center point between both locations
      final centerLat = (userLocation.value!.latitude + barberLocation.value!.latitude) / 2;
      final centerLng = (userLocation.value!.longitude + barberLocation.value!.longitude) / 2;
      final center = LatLng(centerLat, centerLng);

      // Calculate distance between points to determine appropriate zoom
      final distance = Distance().as(LengthUnit.Kilometer, userLocation.value!, barberLocation.value!);

      // Determine zoom level based on distance
      double zoom;
      if (distance < 1) {
        zoom = 16.0;
      } else if (distance < 5) {
        zoom = 14.0;
      } else if (distance < 10) {
        zoom = 13.0;
      } else if (distance < 50) {
        zoom = 11.0;
      } else {
        zoom = 9.0;
      }

      // Move map to center with calculated zoom
      _mapController.move(center, zoom);
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        setState(() {
          isRideAccepted = true;
        });
        _timer.cancel();
      }
    });
  }

  void _onDragUpdate(double size) {
    currentSheetSize.value = size;
    isExpanded.value = size > 0.6;

    // Animate map padding based on sheet size
    if (size < 0.3) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _dragController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appointment = appointmentCtrl.selectedAppointment.value;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          // ✅ Flutter Map with real locations
          Obx(
            () => FlutterMap(
              mapController: _mapController,
              options: MapOptions(initialCenter: userLocation.value ?? LatLng(43.666, -79.396), initialZoom: 15.0, minZoom: 10.0, maxZoom: 18.0),
              children: [
                TileLayer(
                  urlTemplate: "https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png",
                  subdomains: const ['a', 'b', 'c'],
                  userAgentPackageName: 'com.example.cutcy',
                ),

                // Polyline showing route
                if (polylinePoints.isNotEmpty)
                  PolylineLayer(
                    polylines: [Polyline(points: polylinePoints, color: kprimaryColor, strokeWidth: 4, pattern: StrokePattern.dotted())],
                  ),

                // Markers for user and barber locations
                MarkerLayer(
                  markers: [
                    // Barber marker
                    if (barberLocation.value != null)
                      Marker(
                        point: barberLocation.value!,
                        width: 50,
                        height: 50,
                        child: Container(
                          decoration: BoxDecoration(
                            color: kprimaryColor,
                            shape: BoxShape.circle,
                            border: Border.all(color: white, width: 3),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 2))],
                          ),
                          child: const Icon(Icons.content_cut, color: black, size: 24),
                        ),
                      ),

                    // User marker
                    if (userLocation.value != null)
                      Marker(
                        point: userLocation.value!,
                        width: 40,
                        height: 40,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                            border: Border.all(color: white, width: 3),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 2))],
                          ),
                          child: const Icon(Icons.person, color: white, size: 20),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),

          // ✅ Top status pill
          Positioned(
            top: 60.h,
            left: Get.width / 2 - 80.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.8),
                borderRadius: BorderRadius.circular(30.r),
                border: Border.all(color: kprimaryColor.withOpacity(0.3)),
              ),
              child: Text(
                isRideAccepted ? "Barber has arrived!" : "$_secondsRemaining mins away",
                style: TextStyle(color: kprimaryColor, fontSize: 12.sp, fontWeight: FontWeight.w600),
              ),
            ),
          ),

          // ✅ Back button
          Positioned(
            top: 60.h,
            left: 20.w,
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                width: 45.w,
                height: 45.h,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: white.withOpacity(0.2)),
                ),
                child: Icon(Icons.arrow_back_ios_new, color: white, size: 20.sp),
              ),
            ),
          ),

          // ✅ Map controls
          Positioned(
            bottom: 200.h,
            right: 20.w,
            child: Obx(
              () => AnimatedOpacity(
                opacity: currentSheetSize.value < 0.5 ? 1.0 : 0.3,
                duration: const Duration(milliseconds: 200),
                child: Column(
                  children: [
                    // Zoom in
                    Container(
                      width: 45.w,
                      height: 45.h,
                      margin: EdgeInsets.only(bottom: 8.h),
                      decoration: BoxDecoration(color: Colors.black.withOpacity(0.8), borderRadius: BorderRadius.circular(12.r)),
                      child: IconButton(
                        icon: Icon(Icons.add, color: white, size: 20.sp),
                        onPressed: () {
                          final zoom = _mapController.camera.zoom;
                          _mapController.move(_mapController.camera.center, zoom + 1);
                        },
                      ),
                    ),
                    // Zoom out
                    Container(
                      width: 45.w,
                      height: 45.h,
                      margin: EdgeInsets.only(bottom: 8.h),
                      decoration: BoxDecoration(color: Colors.black.withOpacity(0.8), borderRadius: BorderRadius.circular(12.r)),
                      child: IconButton(
                        icon: Icon(Icons.remove, color: white, size: 20.sp),
                        onPressed: () {
                          final zoom = _mapController.camera.zoom;
                          _mapController.move(_mapController.camera.center, zoom - 1);
                        },
                      ),
                    ),
                    // Fit to bounds
                    Container(
                      width: 45.w,
                      height: 45.h,
                      decoration: BoxDecoration(color: Colors.black.withOpacity(0.8), borderRadius: BorderRadius.circular(12.r)),
                      child: IconButton(
                        icon: Icon(Icons.my_location, color: kprimaryColor, size: 20.sp),
                        onPressed: _fitMapToLocations,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ✅ Draggable bottom sheet
          DraggableScrollableSheet(
            controller: _dragController,
            initialChildSize: 0.4,
            minChildSize: 0.2,
            maxChildSize: 0.8,
            snap: true,
            snapSizes: const [0.2, 0.4, 0.8],
            builder: (context, scrollController) {
              return NotificationListener<DraggableScrollableNotification>(
                onNotification: (notification) {
                  _onDragUpdate(notification.extent);
                  return true;
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, -5))],
                  ),
                  child: Column(
                    children: [
                      // Drag handle
                      Container(
                        width: 40.w,
                        height: 4.h,
                        margin: EdgeInsets.symmetric(vertical: 12.h),
                        decoration: BoxDecoration(color: Colors.grey[600], borderRadius: BorderRadius.circular(2.r)),
                      ),

                      Expanded(
                        child: SingleChildScrollView(
                          controller: scrollController,
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: _buildBottomSheetContent(appointment),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),

      // ✅ Action button
      bottomNavigationBar: Obx(
        () => AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.translationValues(0, currentSheetSize.value > 0.6 ? 300.h : 0, 0),
          child: Padding(
            padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 60.h),
            child: SizedBox(
              height: 56.h,
              child: AuthButton(text: isRideAccepted ? "Okay, I'm Coming!" : "Cancel Appointment", onTap: () => _handleButtonTap()),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSheetContent(appointment) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Status message
        Text(
          isRideAccepted ? "Your barber is at the door!" : "Your barber is on the way!",
          style: TextStyle(color: kprimaryColor, fontWeight: FontWeight.bold, fontSize: 16.sp),
        ),
        SizedBox(height: 16.h),

        // Barber info row
        Row(
          children: [
            CircleAvatar(
              radius: 24.r,
              backgroundImage: appointment?.barber?.image != null
                  ? NetworkImage(appointment!.barber!.image!)
                  : const AssetImage("assets/images/young-hispanic-haidresser-and-hairstylist-standing-2024-10-18-17-47-23-utc 1.png")
                        as ImageProvider,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appointment?.barber?.name ?? "Richard Anderson",
                    style: TextStyle(color: white, fontSize: 14.sp, fontWeight: FontWeight.w600),
                  ),
                  Row(
                    children: [
                      Icon(Icons.star, color: kprimaryColor, size: 14.sp),
                      SizedBox(width: 4.w),
                      Text(
                        "4.3 (65)", // You can add rating to your model
                        style: TextStyle(color: Colors.white70, fontSize: 12.sp),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              children: [
                _iconButton(Icons.near_me, () => _showChat()),
                SizedBox(width: 8.w),
                _iconButton(Icons.call, () {}),
              ],
            ),
          ],
        ),

        SizedBox(height: 20.h),

        // Location info
        Text(
          "Track your barber",
          style: TextStyle(color: Colors.white70, fontSize: 12.sp),
        ),
        SizedBox(height: 8.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: ksecondaryColor,
            border: Border.all(color: Colors.white24),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _locationRow('Barber Location', appointment?.barber?.addressLine1 ?? 'Barber\'s Location'),
              SizedBox(height: 12.h),
              _locationRow('Your Location', appointment?.locationName ?? 'Your Location'),
            ],
          ),
        ),

        SizedBox(height: 16.h),

        // Payment info
        _paymentRow("\$${(appointment?.amount ?? 123).toStringAsFixed(2)}"),

        SizedBox(height: 20.h),

        // Expanded content when sheet is large
        Obx(() => currentSheetSize.value > 0.6 ? _buildExpandedContent(appointment) : const SizedBox.shrink()),
      ],
    );
  }

  Widget _buildExpandedContent(appointment) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(color: Colors.white24),
        SizedBox(height: 16.h),

        // Appointment details
        Text(
          "Appointment Details",
          style: TextStyle(color: white, fontSize: 16.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12.h),

        _detailRow("Date", appointment?.day ?? "Today"),
        _detailRow("Time", "${appointment?.startTime ?? '6:00 AM'} - ${appointment?.endTime ?? '7:00 AM'}"),
        _detailRow("Status", appointment?.status ?? "CONFIRMED"),

        SizedBox(height: 16.h),

        // Services
        if (appointment?.services != null && appointment!.services!.isNotEmpty) ...[
          Text(
            "Services",
            style: TextStyle(color: white, fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.h),
          ...appointment.services!.map(
            (service) => Padding(
              padding: EdgeInsets.symmetric(vertical: 2.h),
              child: _detailRow("Service", "\$${service.price?.toStringAsFixed(2) ?? '0.00'}"),
            ),
          ),
        ],

        SizedBox(height: 50.h), // Bottom padding
      ],
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100.w,
            child: Text(
              label,
              style: TextStyle(color: Colors.white70, fontSize: 12.sp),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: white, fontSize: 12.sp),
            ),
          ),
        ],
      ),
    );
  }

  void _showChat() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, controller) => Container(
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          child: ChatContent(controller: controller),
        ),
      ),
    );
  }

  void _handleButtonTap() {
    if (!isRideAccepted) {
      Get.dialog(
        CustomConfirmDialog(
          topImage: Image.asset("assets/icons/Group.png", scale: 4),
          title: "Are you sure?",
          message: "Canceling this appointment means your slot will be released and may not be available again.",
          positiveButtonText: "Continue",
          negativeButtonText: "No, thanks",
          onPositive: () {
            Get.back();
            _showCancellationBottomSheet();
          },
          onNegative: () => Get.back(),
        ),
      );
    } else {
      Get.to(() => AppointmentStartedScreen());
    }
  }

  // ✅BottomSheet to cancel appointment
  final RxString selectedReason = ''.obs; // Rx variable to store selected reason

  void _showCancellationBottomSheet() {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Why do you want to cancel the ride?",
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _cancellationOption("Personal emergency"),
                _cancellationOption("Work Commitments"),
                _cancellationOption("Need to add a different location"),
                _cancellationOption("Need to reschedule"),
                _cancellationOption("Other"),
              ],
            ),
            const SizedBox(height: 20),
            AuthButton(
              text: "Submit",
              onTap: () {
                if (selectedReason.value.isNotEmpty) {
                  final navC = Get.isRegistered<BottomNavController>() ? Get.find<BottomNavController>() : Get.put(BottomNavController());
                  navC.changeIndex(0);
                  Get.offAll(() => MainScreen());
                } else {
                  Get.snackbar("Error", "Please select a reason before submitting.", backgroundColor: Colors.red, colorText: Colors.white);
                }
              },
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }

  // Radio button widget for cancellation reasons
  Widget _cancellationOption(String label) {
    return Obx(
      () => Row(
        children: [
          Radio<String>(
            fillColor: WidgetStateProperty.all(kprimaryColor),
            activeColor: kprimaryColor,
            value: label,
            groupValue: selectedReason.value,
            onChanged: (String? value) {
              selectedReason.value = value ?? "";
            },
          ),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 14)),
        ],
      ),
    );
  }

  // ✅ Icon Button Widget
  Widget _iconButton(IconData icon, VoidCallback onTap) {
    return Container(
      width: 40.w,
      height: 40.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: white.withOpacity(0.3)),
        color: ksecondaryColor,
      ),
      child: IconButton(
        icon: Icon(icon, color: kprimaryColor, size: 20.r),
        onPressed: onTap,
      ),
    );
  }

  // ✅ Location Row
  Widget _locationRow(String title, String subtitle) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.circle, color: kprimaryColor, size: 8.sp),
        SizedBox(width: 8.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(color: white, fontSize: 13.sp, fontWeight: FontWeight.w500),
              ),
              Text(
                subtitle,
                style: TextStyle(color: Colors.white70, fontSize: 11.sp),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ✅ Payment Row
  Widget _paymentRow(String amount) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: ksecondaryColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        children: [
          Icon(Icons.payments, color: kprimaryColor, size: 20.sp),
          SizedBox(width: 12.w),
          Text(
            "Payment",
            style: TextStyle(color: white, fontSize: 14.sp),
          ),
          const Spacer(),
          Text(
            amount,
            style: TextStyle(color: kprimaryColor, fontSize: 14.sp, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
