// ignore_for_file: file_names

import 'package:cutcy/constants/constants.dart';
import 'package:cutcy/home/homes/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class FavoritesScreen extends StatelessWidget {
  FavoritesScreen({super.key});

  // Reuse the SAME HomeController instance
  final HomeController homeC = Get.isRegistered<HomeController>() ? Get.find<HomeController>() : Get.put(HomeController());

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
        scrolledUnderElevation: 0,
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: homeC.refreshFavorites,
            icon: const Icon(Icons.refresh, color: white),
          ),
        ],
      ),
      body: Obx(() {
        if (homeC.favoritesLoading.value) {
          return const Center(child: CircularProgressIndicator(strokeWidth: 2));
        }
        if (homeC.favoritesError.value != null) {
          return _FavError(message: homeC.favoritesError.value!, onRetry: homeC.refreshFavorites);
        }
        if (homeC.favoriteBarbers.isEmpty) {
          return const Center(
            child: Text("No favorites.", style: TextStyle(color: Colors.white60)),
          );
        }

        return RefreshIndicator(
          onRefresh: homeC.refreshFavorites,
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(16.r),
            itemCount: homeC.favoriteBarbers.length,
            separatorBuilder: (_, __) => SizedBox(height: 12.h),
            itemBuilder: (context, index) {
              final b = homeC.favoriteBarbers[index];
              final address = (b.barber?.addressName?.isNotEmpty ?? false)
                  ? b.barber?.addressName!
                  : [b.barber?.addressLine1, b.barber?.city].where((e) => (e ?? '').isNotEmpty).join(', ');

              return GestureDetector(
                // onTap: () => Get.to(() => BookNowScreen(barberData: b)),
                child: Container(
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(color: ksecondaryColor, borderRadius: BorderRadius.circular(12.r)),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 24.r,
                        backgroundColor: Colors.white12,
                        backgroundImage: (b.barber?.image != null && b.barber?.image!.isNotEmpty) ? NetworkImage(b.barber?.image!) : null,
                        child: (b.barber?.image == null || b.barber?.image!.isEmpty) ? const Icon(Icons.person, color: Colors.white70) : null,
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              b.barber?.name ?? "Unknown",
                              style: TextStyle(color: white, fontSize: 16.sp, fontWeight: FontWeight.w600),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              address ?? "",
                              style: TextStyle(color: Colors.white70, fontSize: 13.sp),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.more_vert, color: Colors.white70),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}

class _FavError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _FavError({required this.message, required this.onRetry});
  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(message, style: const TextStyle(color: Colors.white70)),
        10.verticalSpace,
        OutlinedButton(onPressed: onRetry, child: const Text('Retry')),
      ],
    ),
  );
}
