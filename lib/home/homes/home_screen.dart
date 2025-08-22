// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cutcy/home/homes/barber_model.dart';
import 'package:cutcy/home/homes/home_controller.dart';
import 'package:cutcy/widgets/backend_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:cutcy/auth/auth_controller.dart';
import 'package:cutcy/constants/constants.dart';
import 'package:cutcy/home/bookings/book_now_screen.dart';
import 'package:cutcy/home/homes/favs/favorites_screen..dart';
import 'package:cutcy/home/homes/nearby/nearby_screen.dart';
import 'package:cutcy/home/search/home_searah_screen.dart';
import 'package:cutcy/notifications/notiiations_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);
  final AuthController authC = Get.find();
  final HomeController homeC = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: _CurvedClipper(),
              child: Container(
                height: 350.h,
                decoration: BoxDecoration(
                  color: kprimaryColor,
                  image: DecorationImage(
                    image: AssetImage("assets/images/bg.png"),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(kprimaryColor, BlendMode.srcATop),
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    16.verticalSpace,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Circle avatar
                        BackendImage.circle(url: authC.userModel?.data?.image, size: 56),
                        // CircleAvatar(
                        //   radius: 21.r,
                        //   backgroundImage: AssetImage(
                        //     "assets/images/young-hispanic-haidresser-and-hairstylist-standing-2024-10-18-17-47-23-utc 1.png",
                        //   ),
                        // ),
                        12.horizontalSpace,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  authC.userModel?.data?.addressLine1.toString() ?? "", //"134 North Square",
                                  style: TextStyle(fontWeight: FontWeight.bold, color: black, fontSize: 14.sp),
                                ),
                                GestureDetector(
                                  onTap: () => showAddressSelectorSheet(context),
                                  child: Icon(Icons.keyboard_arrow_down_rounded, color: black, size: 20.sp),
                                ),
                              ],
                            ),

                            Text(
                              "${authC.userModel?.data?.city ?? ""},${authC.userModel?.data?.country ?? ""}", //"Toronto, CA",
                              style: TextStyle(color: black.withValues(alpha: 0.68), fontSize: 13.sp, fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            Get.to(() => NotificationsScreen());
                          },
                          child: Icon(Icons.notifications_none_rounded, color: black, size: 28.sp),
                        ),
                      ],
                    ),
                    28.verticalSpace,
                    // Headline
                    Text(
                      "Your best hair day starts here.\nReady to book?",
                      style: TextStyle(fontWeight: FontWeight.bold, color: black, fontSize: 20.sp, height: 1.2),
                    ),
                    22.verticalSpace,
                    // Search bar
                    Container(
                      decoration: BoxDecoration(color: Colors.yellow[100], borderRadius: BorderRadius.circular(14.r)),
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 3.h),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              style: TextStyle(color: black, fontSize: 15.sp),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Search services or barbers',
                                hintStyle: TextStyle(color: Colors.black54, fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.to(() => BarberSearchScreen());
                            },
                            child: Icon(Icons.search, color: Colors.black54, size: 22.sp),
                          ),
                        ],
                      ),
                    ),
                    18.verticalSpace,

                    // Card scroll area
                    // SizedBox(
                    //   height: 250.h,
                    //   child: ListView.builder(
                    //     itemCount: 2,
                    //     scrollDirection: Axis.horizontal,
                    //     physics: BouncingScrollPhysics(),
                    //     itemBuilder: (context, index) {
                    //       return _BarberCard(
                    //         name: 'Richard Anderson',
                    //         rating: '4.9',
                    //         address: '134 North Square, New York',
                    //         image: "assets/images/Frame 1686560766.png",
                    //         yellow: kprimaryColor,
                    //         onTap: () {
                    //           Get.to(() => BookNowScreen());
                    //         },
                    //       );
                    //     },
                    //   ),
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Trending barbers",
                          style: TextStyle(color: white, fontWeight: FontWeight.w600, fontSize: 16.sp),
                        ),
                        GestureDetector(
                          onTap: () => homeC.refreshTrending(),
                          child: Text(
                            "Refresh",
                            style: TextStyle(color: kprimaryColor, fontWeight: FontWeight.w500, fontSize: 14.sp),
                          ),
                        ),
                      ],
                    ),
                    12.verticalSpace,

                    // ---- FEED ----
                    Obx(() {
                      if (homeC.isLoading.value) {
                        return SizedBox(
                          height: 210.h,
                          child: Center(child: CircularProgressIndicator(color: kprimaryColor, strokeWidth: 2)),
                        );
                      }

                      if (homeC.error.value != null) {
                        return _ErrorBox(msg: homeC.error.value!, onRetry: homeC.fetchTrendingBarbers);
                      }

                      if (homeC.barbers.isEmpty) {
                        return _EmptyBox(message: "No trending barbers right now.");
                      }

                      return SizedBox(
                        height: 250.h,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemCount: homeC.barbers.length,
                          separatorBuilder: (_, __) => 14.horizontalSpace,
                          itemBuilder: (_, i) => _TrendingCard(data: homeC.barbers[i]),
                        ),
                      );
                    }),

                    50.verticalSpace,
                    // Nearest
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Nearest for your location",
                          style: TextStyle(color: white, fontWeight: FontWeight.w600, fontSize: 16.sp),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.to(() => NearbyScreen());
                          },
                          child: Text(
                            "See All",
                            style: TextStyle(color: kprimaryColor, fontWeight: FontWeight.w500, fontSize: 14.sp),
                          ),
                        ),
                      ],
                    ),
                    12.verticalSpace,

                    Obx(() {
                      if (homeC.nearestLoading.value) {
                        return Container(height: 80, alignment: Alignment.center, child: const CircularProgressIndicator(strokeWidth: 2));
                      }
                      if (homeC.nearestError.value != null) {
                        return _ErrorBox(msg: homeC.nearestError.value!, onRetry: homeC.fetchNearestBarbers);
                      }
                      final list = homeC.nearestTop3;
                      if (list.isEmpty) {
                        return const _EmptyBox(message: "No nearby barbers found.");
                      }

                      // show max 3 tiles
                      return Column(
                        children: list.map((b) {
                          final address = (b.addressName?.isNotEmpty ?? false)
                              ? b.addressName!
                              : [b.addressLine1, b.city].where((e) => (e ?? '').isNotEmpty).join(', ');
                          return Padding(
                            padding: EdgeInsets.only(bottom: 8.h),
                            child: _NearestTile(
                              name: b.name ?? "Unknown",
                              address: address,
                              onTap: () => Get.to(() => BookNowScreen(barberData: b, isFromFav: false)),
                            ),
                          );
                        }).toList(),
                      );
                    }),

                    24.verticalSpace,

                    // Favorites
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Favorites",
                          style: TextStyle(color: white, fontWeight: FontWeight.w600, fontSize: 16.sp),
                        ),
                        GestureDetector(
                          onTap: () {
                            // Navigate to the FavoritesScreen
                            Get.to(() => FavoritesScreen());
                          },
                          child: Text(
                            "See All",
                            style: TextStyle(color: kprimaryColor, fontWeight: FontWeight.w500, fontSize: 14.sp),
                          ),
                        ),
                      ],
                    ),
                    12.verticalSpace,

                    Obx(() {
                      if (homeC.favoritesLoading.value) {
                        return const Center(child: CircularProgressIndicator(strokeWidth: 2));
                      }
                      if (homeC.favoritesError.value != null) {
                        return _ErrorBox(msg: homeC.favoritesError.value!, onRetry: homeC.refreshFavorites);
                      }
                      final list = homeC.favoritesTop3;
                      if (list.isEmpty) {
                        return const _EmptyBox(message: "No favorites yet.");
                      }

                      // Reuse your _FavoritesTile UI; show max 3
                      return Column(
                        children: list.map((b) {
                          final address = (b.barber?.addressName?.isNotEmpty ?? false)
                              ? b.barber?.addressName!
                              : [b.barber?.addressLine1, b.barber?.city].where((e) => (e ?? '').isNotEmpty).join(', ');
                          return Padding(
                            padding: EdgeInsets.only(bottom: 8.h),
                            child: _FavoritesTile(
                              name: b.barber?.name ?? "Unknown",
                              address: address ?? "",
                              onTap: () => Get.to(() => BookNowScreen(favBarberData: b, isFromFav: true)),
                            ),
                          );
                        }).toList(),
                      );
                    }),
                    24.verticalSpace,
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

// Custom clipper for the curved background
class _CurvedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 70);
    path.quadraticBezierTo(size.width / 2, size.height, size.width, size.height - 70);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

// Nearest tile
class _NearestTile extends StatelessWidget {
  final String name;
  final String address;
  final Function()? onTap; // Optional onTap callback

  const _NearestTile({
    required this.name,
    required this.address,
    this.onTap, // Optional parameter
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // If onTap is provided, it will be triggered
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        decoration: BoxDecoration(color: Color(0xFF232323), borderRadius: BorderRadius.circular(14.r)),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white12,
              radius: 19.r,
              child: Icon(Icons.person, color: Colors.white70, size: 21.sp),
            ),
            14.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(color: white, fontWeight: FontWeight.w600, fontSize: 14.5.sp),
                  ),
                  2.verticalSpace,
                  Text(
                    address,
                    style: TextStyle(color: Colors.white60, fontSize: 11.5.sp),
                  ),
                ],
              ),
            ),
            Icon(Icons.more_vert, color: Colors.white38, size: 21.sp),
          ],
        ),
      ),
    );
  }
}

// Favorites tile
class _FavoritesTile extends StatelessWidget {
  final String name;
  final String address;
  final Function()? onTap; // Optional onTap callback

  const _FavoritesTile({
    required this.name,
    required this.address,
    this.onTap, // Optional parameter
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // If onTap is provided, it will be triggered
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        decoration: BoxDecoration(color: Color(0xFF232323), borderRadius: BorderRadius.circular(14.r)),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white12,
              radius: 19.r,
              child: Icon(Icons.person, color: Colors.white70, size: 21.sp),
            ),
            14.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(color: white, fontWeight: FontWeight.w600, fontSize: 14.5.sp),
                  ),
                  2.verticalSpace,
                  Text(
                    address,
                    style: TextStyle(color: Colors.white60, fontSize: 11.5.sp),
                  ),
                ],
              ),
            ),
            Icon(Icons.more_vert, color: Colors.white38, size: 21.sp),
          ],
        ),
      ),
    );
  }
}

void showAddressSelectorSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: backgroundColor,
    builder: (_) {
      return Container(
        decoration: BoxDecoration(
          color: const Color(0xFF181818),
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        padding: EdgeInsets.fromLTRB(20, 20, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag indicator
            Container(
              width: 36,
              height: 4,
              margin: EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)),
            ),
            // Use current location
            Row(
              children: [
                Icon(Icons.location_on_outlined, color: white, size: 22),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Use current location',
                    style: TextStyle(color: white, fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
                Icon(Icons.check_circle, color: Colors.white24, size: 22),
              ],
            ),
            Divider(color: Colors.white12, height: 28),
            // Home address (selected)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.home_rounded, color: kprimaryColor, size: 22),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Home',
                            style: TextStyle(color: kprimaryColor, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.check, color: kprimaryColor, size: 18),
                        ],
                      ),
                      SizedBox(height: 2),
                      Text(
                        '75 St George St, Toronto, ON M5S 2E5, Canada',
                        style: TextStyle(color: kprimaryColor, fontSize: 13),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Divider(color: Colors.white12, height: 28),
            // Add new address
            InkWell(
              onTap: () {
                // Add address action
              },
              child: Row(
                children: [
                  Icon(Icons.add, color: white, size: 22),
                  SizedBox(width: 12),
                  Text(
                    "Add new address",
                    style: TextStyle(color: white, fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}

class _TrendingCard extends StatelessWidget {
  final BarberData data;
  const _TrendingCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final rating = (data.averageRating ?? 0).toStringAsFixed(1);
    final imgUrl = data.image; // can be null
    final address = (data.addressName?.isNotEmpty ?? false)
        ? data.addressName!
        : [data.addressLine1, data.city].where((e) => (e ?? '').isNotEmpty).join(', ');

    return GestureDetector(
      onTap: () => Get.to(() => BookNowScreen(barberData: data, isFromFav: false)),
      child: Container(
        width: 220.w,
        height: 250.h,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: ksecondaryColor,
          borderRadius: BorderRadius.circular(22.r),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 16, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // cover
            BackendImage(url: imgUrl, width: 220.w, height: 98.h, borderRadius: BorderRadius.circular(20)),
            Padding(
              padding: EdgeInsets.fromLTRB(14.w, 8.h, 14.w, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.name ?? 'Unknown',
                    style: TextStyle(color: white, fontWeight: FontWeight.bold, fontSize: 16.sp),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  4.verticalSpace,
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          address,
                          style: TextStyle(color: Colors.white60, fontSize: 11.5.sp, fontWeight: FontWeight.w500),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      Text(
                        rating,
                        style: TextStyle(color: white, fontWeight: FontWeight.bold, fontSize: 12.5.sp),
                      ),
                      3.horizontalSpace,
                      Icon(Icons.star, color: kprimaryColor, size: 16.sp),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.fromLTRB(14.w, 0, 14.w, 12.h),
              child: SizedBox(
                width: double.infinity,
                height: 36.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kprimaryColor,
                    foregroundColor: Colors.black,
                    elevation: 0,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                  ),
                  onPressed: () {
                    // Navigate to barber detail / booking
                    Get.to(() => BookNowScreen(barberData: data, isFromFav: false));
                  },
                  child: Text(
                    'Book Now',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15.sp),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyBox extends StatelessWidget {
  final String message;
  const _EmptyBox({required this.message});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: const Color(0xFF232323), borderRadius: BorderRadius.circular(14)),
      child: Text(message, style: const TextStyle(color: Colors.white60)),
    );
  }
}

class _ErrorBox extends StatelessWidget {
  final String msg;
  final VoidCallback onRetry;
  const _ErrorBox({required this.msg, required this.onRetry});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: const Color(0xFF2A1E1E), borderRadius: BorderRadius.circular(14)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(msg, style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 10),
          OutlinedButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}
