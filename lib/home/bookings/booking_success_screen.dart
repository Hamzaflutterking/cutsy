// import 'package:cutcy/constants/constants.dart';
// import 'package:cutcy/home/appointment/appointment_controller.dart';
// import 'package:cutcy/home/appointment/appointment_details_screen.dart';
// import 'package:cutcy/widgets/AppButton.dart';

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';

// class BookingSuccessScreen extends StatefulWidget {
//   const BookingSuccessScreen({super.key});

//   @override
//   State<BookingSuccessScreen> createState() => _BookingSuccessScreenState();
// }

// class _BookingSuccessScreenState extends State<BookingSuccessScreen> with SingleTickerProviderStateMixin {
//   late AnimationController _spinController;

//   @override
//   void initState() {
//     super.initState();
//     _spinController = AnimationController(vsync: this, duration: const Duration(seconds: 5))..repeat(); // infinite spin
//   }

//   @override
//   void dispose() {
//     _spinController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: backgroundColor,
//       body: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 20.w),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // Counter-clockwise spinning image
//             RotationTransition(
//               turns: Tween<double>(begin: 0.0, end: -1.0).animate(_spinController),
//               child: Image.asset('assets/icons/Property 1=Frame 1400001546.png', width: 120.w, height: 120.w),
//             ),

//             SizedBox(height: 30.h),

//             Text(
//               "You're all set!",
//               style: TextStyle(color: Colors.yellow, fontWeight: FontWeight.bold, fontSize: 20.sp),
//             ),

//             SizedBox(height: 10.h),

//             Text(
//               "Your appointment has been successfully booked. You’ll receive a reminder before your appointment.",
//               style: TextStyle(color: Colors.white, fontSize: 14.sp),
//               textAlign: TextAlign.center,
//             ),

//             SizedBox(height: 40.h),

//             AuthButton(
//               text: "View Appointment Details",
//               onTap: () {
//                 Get.to(() => AppointmentDetailsScreen());
//               },
//             ),

//             SizedBox(height: 16.h),

//             AuthButton(text: "Go Back", onTap: () => Get.back()),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:cutcy/constants/constants.dart';
import 'package:cutcy/home/appointment/appointment_controller.dart';
import 'package:cutcy/home/appointment/appointment_details_screen.dart';
import 'package:cutcy/widgets/AppButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class BookingSuccessScreen extends StatefulWidget {
  final Appointment appointment; // ✅ use your model

  const BookingSuccessScreen({super.key, required this.appointment});

  @override
  State<BookingSuccessScreen> createState() => _BookingSuccessScreenState();
}

class _BookingSuccessScreenState extends State<BookingSuccessScreen> with SingleTickerProviderStateMixin {
  late AnimationController _spinController;

  @override
  void initState() {
    super.initState();
    _spinController = AnimationController(vsync: this, duration: const Duration(seconds: 5))..repeat(); // Infinite spin
  }

  @override
  void dispose() {
    _spinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RotationTransition(
              turns: Tween<double>(begin: 0.0, end: -1.0).animate(_spinController),
              child: Image.asset('assets/icons/Property 1=Frame 1400001546.png', width: 120.w, height: 120.w),
            ),

            SizedBox(height: 30.h),

            Text(
              "You're all set!",
              style: TextStyle(color: Colors.yellow, fontWeight: FontWeight.bold, fontSize: 20.sp),
            ),

            SizedBox(height: 10.h),

            Text(
              "Your appointment has been successfully booked. You’ll receive a reminder before your appointment.",
              style: TextStyle(color: Colors.white, fontSize: 14.sp),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 40.h),

            AuthButton(
              text: "View Appointment Details",
              onTap: () {
                final ctrl = Get.find<AppointmentController>();
                ctrl.selectedAppointment.value = widget.appointment; // ✅ Pass appointment
                Get.to(() => AppointmentDetailsScreen());
              },
            ),

            SizedBox(height: 16.h),

            AuthButton(text: "Go Back", onTap: () => Get.back()),
          ],
        ),
      ),
    );
  }
}
