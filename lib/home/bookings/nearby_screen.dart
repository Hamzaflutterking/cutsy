import 'package:cutcy/constants/constants.dart';
import 'package:cutcy/home/bookings/book_now_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'nearby_controller.dart';

class NearbyScreen extends StatelessWidget {
  NearbyScreen({super.key});
  final NearbyController ctrl = Get.put(NearbyController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: white),
          onPressed: () => Get.back(),
        ),
        title: const Text("Nearest for your location", style: TextStyle(color: white)),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: Obx(
        () => ListView.separated(
          padding: EdgeInsets.all(16.r),
          itemCount: ctrl.people.length,
          separatorBuilder: (_, __) => SizedBox(height: 12.h),
          itemBuilder: (context, index) {
            final person = ctrl.people[index];
            return GestureDetector(
              onTap: () {
                Get.to(() => BookNowScreen());
              },
              child: Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(color: ksecondaryColor, borderRadius: BorderRadius.circular(12.r)),
                child: Row(
                  children: [
                    CircleAvatar(backgroundImage: AssetImage(person.image), radius: 24.r),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            person.name,
                            style: TextStyle(color: white, fontSize: 16.sp, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            person.address,
                            style: TextStyle(color: Colors.white70, fontSize: 13.sp),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.more_vert, color: Colors.white70),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
