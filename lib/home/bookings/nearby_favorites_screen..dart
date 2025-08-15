// ignore_for_file: file_names

import 'package:cutcy/constants/constants.dart';
import 'package:cutcy/home/bookings/book_now_screen.dart';
import 'package:cutcy/home/bookings/nearby_favorite_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class FavoritesScreen extends StatelessWidget {
  FavoritesScreen({super.key});

  final FavoriteController ctrl = Get.put(FavoriteController());

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
        title: const Text("Favorites", style: TextStyle(color: white)),
        centerTitle: true,
        elevation: 0,
      ),
      body: Obx(
        () => ListView.separated(
          padding: EdgeInsets.all(16.r),
          itemCount: ctrl.favorites.length,
          separatorBuilder: (_, __) => SizedBox(height: 12.h),
          itemBuilder: (context, index) {
            final person = ctrl.favorites[index];
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
