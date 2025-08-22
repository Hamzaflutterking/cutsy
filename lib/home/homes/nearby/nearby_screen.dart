import 'package:cutcy/constants/constants.dart';
import 'package:cutcy/home/bookings/book_now_screen.dart';
import 'package:cutcy/home/homes/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NearbyScreen extends StatelessWidget {
  NearbyScreen({super.key});

  // Reuse the same HomeController instance (fallback to put if not registered)
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
        title: const Text("Nearest for your location", style: TextStyle(color: white)),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: homeC.refreshNearest,
            icon: const Icon(Icons.refresh, color: white),
          ),
        ],
      ),
      body: Obx(() {
        if (homeC.nearestLoading.value) {
          return const Center(child: CircularProgressIndicator(strokeWidth: 2));
        }
        if (homeC.nearestError.value != null) {
          return _ErrorView(message: homeC.nearestError.value!, onRetry: homeC.refreshNearest);
        }
        if (homeC.nearestBarbers.isEmpty) {
          return const _EmptyView(message: "No nearby barbers found.");
        }

        // FULL list here (Home shows only top 3)
        return RefreshIndicator(
          onRefresh: homeC.refreshNearest,
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(16.r),
            itemCount: homeC.nearestBarbers.length,
            separatorBuilder: (_, __) => SizedBox(height: 12.h),
            itemBuilder: (context, index) {
              final b = homeC.nearestBarbers[index];
              final address = (b.addressName?.isNotEmpty ?? false)
                  ? b.addressName!
                  : [b.addressLine1, b.city].where((e) => (e ?? '').isNotEmpty).join(', ');

              return GestureDetector(
                onTap: () => Get.to(() => BookNowScreen(barberData: b, isFromFav: false)),
                child: Container(
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(color: ksecondaryColor, borderRadius: BorderRadius.circular(12.r)),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 24.r,
                        backgroundColor: Colors.white12,
                        backgroundImage: (b.image != null && b.image!.isNotEmpty) ? NetworkImage(b.image!) : null,
                        child: (b.image == null || b.image!.isEmpty) ? const Icon(Icons.person, color: Colors.white70) : null,
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              b.name ?? "Unknown",
                              style: TextStyle(color: white, fontSize: 16.sp, fontWeight: FontWeight.w600),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              address,
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

class _EmptyView extends StatelessWidget {
  final String message;
  const _EmptyView({required this.message});
  @override
  Widget build(BuildContext context) => Center(
    child: Text(message, style: const TextStyle(color: Colors.white60)),
  );
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});
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
