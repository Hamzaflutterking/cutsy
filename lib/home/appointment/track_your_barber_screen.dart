// ignore_for_file: deprecated_member_use, avoid_print

import 'dart:ui';
import 'dart:async';

import 'package:cutcy/constants/constants.dart';
import 'package:cutcy/home/appointment/appointment_chat_screen.dart';
import 'package:cutcy/home/appointment/appointment_start_screen.dart';
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

class _TrackBarberScreenState extends State<TrackBarberScreen> {
  bool isRideAccepted = false; // Flag to track if the barber has arrived
  late Timer _timer;
  int _secondsRemaining = 5; // Time until button changes

  @override
  void initState() {
    super.initState();

    // Start the countdown timer for 10 seconds
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        // When the timer reaches 0, change text and set isRideAccepted to true
        setState(() {
          isRideAccepted = true;
        });
        _timer.cancel(); // Stop the timer
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userLocation = LatLng(43.665, -79.398); // Example: User location
    final barberLocation = LatLng(43.668, -79.394); // Example: Barber location

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          // ✅ Flutter Map with Carto Light style
          FlutterMap(
            options: MapOptions(initialCenter: LatLng(43.666, -79.396), initialZoom: 15.5),
            children: [
              TileLayer(
                urlTemplate: "https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
                userAgentPackageName: 'com.example.cutcy',
              ),
              PolylineLayer(
                polylines: [
                  Polyline(points: [barberLocation, userLocation], color: Colors.black, strokeWidth: 3),
                ],
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: barberLocation,
                    width: 40,
                    height: 40,
                    child: const Icon(Icons.navigation, color: black, size: 30),
                  ),
                  Marker(
                    point: userLocation,
                    width: 40,
                    height: 40,
                    child: const Icon(Icons.circle, color: kprimaryColor, size: 18),
                  ),
                ],
              ),
            ],
          ),

          // ✅ "5 mins away" pill
          Positioned(
            top: 60.h,
            left: Get.width / 2 - 60.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
              decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(30.r)),
              child: Text(
                isRideAccepted ? "Your barber has arrived" : "$_secondsRemaining secs remaining",
                style: TextStyle(color: kprimaryColor, fontSize: 12.sp),
              ),
            ),
          ),

          // ✅ Cancel Appointment Button
          Positioned(
            top: 60.h,
            left: Get.width / 2 - 170.w,
            child: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Container(
                width: 45.w,
                height: 40.h,
                decoration: BoxDecoration(color: ksecondaryColor, borderRadius: BorderRadius.circular(10)),
                child: GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Icon(Icons.arrow_back_ios_new, color: white),
                ),
              ),
            ),
          ),

          // ✅ Bottom blurred panel
          Align(
            alignment: Alignment.bottomCenter,
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  padding: EdgeInsets.all(20.r),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          isRideAccepted ? "Your barber is at the door!" : "Your barber is on the way!",
                          style: TextStyle(color: kprimaryColor, fontWeight: FontWeight.bold, fontSize: 16.sp),
                        ),
                      ),
                      16.verticalSpace,

                      // ✅ Barber info row
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 24.r,
                            backgroundImage: AssetImage(
                              "assets/images/young-hispanic-haidresser-and-hairstylist-standing-2024-10-18-17-47-23-utc 1.png",
                            ),
                          ),
                          12.horizontalSpace,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Richard Anderson",
                                  style: TextStyle(color: white, fontSize: 14.sp),
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.star, color: kprimaryColor, size: 14.sp),
                                    4.horizontalSpace,
                                    Text(
                                      "4.3 (65)",
                                      style: TextStyle(color: Colors.white70, fontSize: 12.sp),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              Container(
                                width: 50.w,
                                height: 40.h,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: white),
                                ),
                                child: IconButton(
                                  icon: Icon(Icons.near_me, color: kprimaryColor, size: 24.r),
                                  onPressed: () {
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
                                  },
                                ),
                              ),
                              10.verticalSpace,
                              _iconButton(Icons.call, () {}),
                            ],
                          ),
                        ],
                      ),

                      16.verticalSpace,

                      // ✅ Location info
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Track your barber",
                          style: TextStyle(color: Colors.white70, fontSize: 12.sp),
                        ),
                      ),
                      8.verticalSpace,
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(12.r),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white24),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _locationRow('Check-Inn Hotel', '130 St George St, Toronto, ON M5S 1A5, Canada'),
                            12.verticalSpace,
                            _locationRow('Your Location', '75 St George St, Toronto, ON M5S 2E5, Canada'),
                          ],
                        ),
                      ),

                      16.verticalSpace,
                      _paymentRow("\$123.00"),

                      20.verticalSpace,
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 80.h),
        child: SizedBox(
          height: 56.h,
          child: AuthButton(
            text: isRideAccepted ? "Okay, I'm Coming!" : "Cancel Appointment",
            onTap: () {
              if (!isRideAccepted) {
                // If the ride has not been accepted yet (before 10 seconds)
                // Show the CustomConfirmDialog
                Get.dialog(
                  CustomConfirmDialog(
                    topImage: Image.asset("assets/icons/Group.png", scale: 4),
                    title: "Are you sure?",
                    message: "Canceling this appointment means your slot will be released and may not be available again.",
                    positiveButtonText: "Continue",
                    negativeButtonText: "No, thanks",
                    onPositive: () {
                      Get.back(); // Close the dialog
                      // Show the bottom sheet for cancellation reason
                      _showCancellationBottomSheet();
                    },
                    onNegative: () => Get.back(), // Close the dialog
                  ),
                );
              } else {
                // Handle rider arrival confirmation if already accepted
                // Navigate to the screen when ride has been accepted
                Get.to(() => AppointmentStartedScreen()); // Navigate to your "Appointment Started" screen
                print("Barber has arrived, confirm arrival.");
              }
            },
          ),
        ),
      ),
    );
  }

  // ✅BottomSheet to cancel appointment
  final RxString selectedReason = ''.obs; // Rx variable to store selected reason

  void _showCancellationBottomSheet() {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(12)),
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            Text(
              "Why do you want to cancel the ride?",
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),

            // Options (Radio buttons for reasons)
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
            SizedBox(height: 20),

            // Submit Button
            AuthButton(
              text: "Submit",
              onTap: () {
                if (selectedReason.value.isNotEmpty) {
                  final navC = Get.isRegistered<BottomNavController>() ? Get.find<BottomNavController>() : Get.put(BottomNavController());

                  navC.changeIndex(0);
                  Get.offAll(() => MainScreen());
                } else {
                  // Show error if no reason is selected
                  Get.snackbar("Error", "Please select a reason before submitting.", backgroundColor: Colors.red, colorText: Colors.white);
                }
              },
            ),
            SizedBox(height: 50),
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
            fillColor: MaterialStateProperty.all(kprimaryColor), // Set fill color
            activeColor: kprimaryColor, // Set active color
            value: label, // The value of this radio button
            groupValue: selectedReason.value, // The currently selected value
            onChanged: (String? value) {
              selectedReason.value = value ?? ""; // Set the selected reason
            },
          ),
          Text(label, style: TextStyle(color: Colors.white, fontSize: 14)),
        ],
      ),
    );
  }

  // ✅ Icon Button Widget
  Widget _iconButton(IconData icon, VoidCallback onTap) {
    return Container(
      width: 50.w,
      height: 40.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: white),
      ),
      child: IconButton(
        icon: Icon(icon, color: kprimaryColor, size: 24.r),
        onPressed: onTap,
      ),
    );
  }

  // ✅ Location Row
  Widget _locationRow(String title, String subtitle) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.circle, color: kprimaryColor, size: 10.sp),
        SizedBox(width: 8.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(color: white, fontSize: 14.sp),
              ),
              Text(
                subtitle,
                style: TextStyle(color: Colors.white70, fontSize: 12.sp),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ✅ Payment Row
  Widget _paymentRow(String amount) {
    return Row(
      children: [
        Icon(Icons.payments, color: kprimaryColor),
        SizedBox(width: 12.w),
        Text(
          "Payment",
          style: TextStyle(color: white, fontSize: 14.sp),
        ),
        Spacer(),
        Text(
          amount,
          style: TextStyle(color: white, fontSize: 14.sp),
        ),
      ],
    );
  }
}
