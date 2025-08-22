// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:cutcy/auth/auth_controller.dart';
import 'package:cutcy/constants/constants.dart';
import 'package:cutcy/home/bookings/book_now_screen.dart';
import 'package:cutcy/home/bookings/nearby_favorites_screen..dart';
import 'package:cutcy/home/bookings/nearby_screen.dart';
import 'package:cutcy/home/search/home_searah_screen.dart';
import 'package:cutcy/notifications/notiiations_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);
  final AuthController authC = Get.find();
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
                        CircleAvatar(
                          radius: 21.r,
                          backgroundImage: AssetImage(
                            "assets/images/young-hispanic-haidresser-and-hairstylist-standing-2024-10-18-17-47-23-utc 1.png",
                          ),
                        ),
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
                    SizedBox(
                      height: 250.h,
                      child: ListView.builder(
                        itemCount: 2,
                        scrollDirection: Axis.horizontal,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return _BarberCard(
                            name: 'Richard Anderson',
                            rating: '4.9',
                            address: '134 North Square, New York',
                            image: "assets/images/Frame 1686560766.png",
                            yellow: kprimaryColor,
                            onTap: () {
                              Get.to(() => BookNowScreen());
                            },
                          );
                        },
                      ),
                    ),
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

                    // Nearest list as a Column (no Expanded, no ListView!)
                    _NearestTile(
                      name: "Noah Wilson",
                      address: "78 Willow Crescent, Vancouver, CA",
                      onTap: () {
                        // Custom action, e.g., navigate to a detail screen
                        Get.to(() => BookNowScreen());
                      },
                    ),
                    8.verticalSpace,
                    _NearestTile(name: "Emily Harper", address: "132 Pennsylvania Square, NY"),
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
                    // List of favorites as a Column
                    _FavoritesTile(
                      name: "Olivia Brooks",
                      address: "11 Maplewood Drive, Montreal, CA",
                      onTap: () {
                        // Custom action, e.g., navigate to a detail screen
                        Get.to(() => BookNowScreen());
                      },
                    ),

                    8.verticalSpace,
                    _FavoritesTile(name: "Jack Reynolds", address: "213 Oakridge Court, Victoria, CA"),
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

// Barber feature card

class _BarberCard extends StatelessWidget {
  final String name;
  final String rating;
  final String address;
  final String image;
  final Color yellow;
  final VoidCallback? onTap;

  const _BarberCard({
    Key? key,
    required this.name,
    required this.rating,
    required this.address,
    required this.image,
    required this.yellow,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 220.w,
        height: 250.h,
        decoration: BoxDecoration(
          color: ksecondaryColor,
          borderRadius: BorderRadius.circular(22.r),
          boxShadow: [BoxShadow(color: black.withValues(alpha: 0.10), blurRadius: 16, offset: Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(22.r)),
              child: Image.asset(image, width: 220.w, height: 98.h, fit: BoxFit.cover),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(14.w, 8.h, 14.w, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(color: white, fontWeight: FontWeight.bold, fontSize: 16.sp),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  3.verticalSpace,
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          address,
                          style: TextStyle(color: Colors.white54, fontSize: 11.5.sp, fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(Icons.star, color: kprimaryColor, size: 16.sp),
                      2.horizontalSpace,
                      Text(
                        rating,
                        style: TextStyle(color: white, fontWeight: FontWeight.bold, fontSize: 13.sp),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(14.w, 0, 14.w, 12.h),
              child: SizedBox(
                width: double.infinity,
                height: 36.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: yellow,
                    foregroundColor: black,
                    elevation: 0,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                  ),
                  onPressed: () {
                    Get.to(() => BookNowScreen());
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
