// ignore_for_file: unnecessary_import, unnecessary_to_list_in_spreads, deprecated_member_use

import 'dart:ui';
import 'package:cutcy/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class ProviderInfoScreen extends StatefulWidget {
  final ScrollController scrollController;
  const ProviderInfoScreen({super.key, required this.scrollController});

  @override
  State<ProviderInfoScreen> createState() => _ProviderInfoScreenState();
}

class _ProviderInfoScreenState extends State<ProviderInfoScreen> {
  double selectedRating = 0;

  final List<Map<String, dynamic>> reviews = [
    {'rating': 5, 'comment': 'Fantastic!', 'user': 'John'},
    {'rating': 5, 'comment': 'Loved my haircut!!', 'user': 'John'},
    {'rating': 4, 'comment': 'Slow but nice', 'user': 'John'},
    {'rating': 5, 'comment': 'Very polite!', 'user': 'John'},
    {'rating': 5, 'comment': 'Polite and friendly', 'user': 'John'},
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: widget.scrollController,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: EdgeInsets.only(bottom: 16.h),
              decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)),
            ),
          ),

          /// Profile Info Card
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(color: ksecondaryColor, borderRadius: BorderRadius.circular(16.r)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [_licensedTag(), _iconButton(Icons.close, () => Get.back())]),
                SizedBox(height: 8.h),
                Text(
                  "RICHARD ANDERSON",
                  style: TextStyle(color: white, fontWeight: FontWeight.bold, fontSize: 18.sp),
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    _infoBox(Icons.workspace_premium_rounded, "02 years", "Experience"),
                    SizedBox(width: 16.w),
                    _infoBox(Icons.star, "4.9", "Rating"),
                  ],
                ),
              ],
            ),
          ),

          /// Location
          SizedBox(height: 16.h),
          Text(
            "LOCATION",
            style: TextStyle(color: Colors.white70, fontSize: 13.sp),
          ),
          SizedBox(height: 8.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              height: 160.h,
              width: double.infinity,
              child: FlutterMap(
                options: MapOptions(initialCenter: LatLng(43.651070, -79.347015), initialZoom: 14),
                children: [
                  TileLayer(
                    urlTemplate: "https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png",
                    subdomains: ['a', 'b', 'c'],
                    userAgentPackageName: 'com.example.cutcy',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: LatLng(43.651070, -79.347015),
                        width: 40.w,
                        height: 40.h,
                        child: const Icon(Icons.location_pin, color: black, size: 40),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          /// Ratings
          SizedBox(height: 16.h),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(color: ksecondaryColor, borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                Text(
                  "4.8",
                  style: TextStyle(fontSize: 32.sp, color: white, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4.h),
                Text("Overall Rating", style: TextStyle(color: Colors.white70)),
                Text(
                  "Based on 114 reviews",
                  style: TextStyle(color: Colors.white54, fontSize: 12.sp),
                ),
                SizedBox(height: 12.h),
                _buildRatingBar(5, 70),
                _buildRatingBar(4, 26),
                _buildRatingBar(3, 0),
                _buildRatingBar(2, 4),
                _buildRatingBar(1, 0),
              ],
            ),
          ),

          SizedBox(height: 16.h),
          Text(
            "Recent Reviews",
            style: TextStyle(color: white, fontSize: 15.sp),
          ),
          SizedBox(height: 12.h),

          /// Rating Filter
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: Colors.grey,
              inactiveTrackColor: Colors.grey[800],
              thumbColor: white,
              overlayColor: kprimaryColor.withAlpha(32),
            ),
            child: Slider(
              min: 0,
              max: 5,
              divisions: 5,
              value: selectedRating,
              onChanged: (value) => setState(() => selectedRating = value),
              label: selectedRating == 0 ? 'All' : selectedRating.toInt().toString(),
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(6, (i) {
              return Text(
                i == 0 ? "All" : "$i",
                style: TextStyle(color: selectedRating == i.toDouble() ? Colors.greenAccent : Colors.white54, fontSize: 12.sp),
              );
            }),
          ),

          SizedBox(height: 20.h),
          Text(
            "Top Reviews",
            style: TextStyle(color: white, fontSize: 14.sp, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 8.h),

          ...reviews.where((r) => selectedRating == 0 || r['rating'] == selectedRating).map((review) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: List.generate(review['rating'], (_) => Icon(Icons.star, size: 16, color: kprimaryColor))),
                SizedBox(height: 4),
                Text(review['comment'], style: TextStyle(color: white)),
                Text(
                  "John  •  1 week ago",
                  style: TextStyle(color: Colors.white54, fontSize: 11.sp),
                ),
                SizedBox(height: 16),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _licensedTag() => Container(
    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
    decoration: BoxDecoration(color: kprimaryColor, borderRadius: BorderRadius.circular(4)),
    child: Text(
      "Licensed",
      style: TextStyle(color: Colors.black, fontSize: 12.sp, fontWeight: FontWeight.w600),
    ),
  );

  Widget _infoBox(IconData icon, String value, String label) => Container(
    width: 150.w,
    padding: EdgeInsets.all(12),
    decoration: BoxDecoration(color: Colors.grey[850], borderRadius: BorderRadius.circular(12)),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: kprimaryColor, size: 24.sp),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(color: white, fontWeight: FontWeight.bold, fontSize: 14.sp),
          textAlign: TextAlign.center,
        ),
        Text(
          label,
          style: TextStyle(color: Colors.white54, fontSize: 11.sp),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );

  Widget _buildRatingBar(int star, int percent) => Row(
    children: [
      Text("$star", style: TextStyle(color: white, fontSize: 12)),
      SizedBox(width: 4),
      Icon(Icons.star, color: kprimaryColor, size: 14),
      SizedBox(width: 8),
      Expanded(
        child: LinearProgressIndicator(value: percent / 100, backgroundColor: Colors.white10, color: kprimaryColor, minHeight: 8),
      ),
      SizedBox(width: 8),
      Text("$percent%", style: TextStyle(color: white, fontSize: 12)),
    ],
  );

  Widget _iconButton(IconData icon, VoidCallback onTap) => CircleAvatar(
    backgroundColor: Colors.black54,
    child: IconButton(
      icon: Icon(icon, color: white),
      onPressed: onTap,
    ),
  );
}

/// ✅ Show Modal Bottom Sheet with Background and Icons Fixed
void showProviderInfoBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return Stack(
        children: [
          // Background image
          Container(
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/young-hispanic-haidresser-and-hairstylist-standing-2024-10-18-17-47-23-utc 1.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Top icons
          Positioned(top: 60.h, left: 16.w, child: _circleIcon(Icons.arrow_back, () => Get.back())),
          Positioned(top: 60.h, right: 16.w, child: _circleIcon(Icons.bookmark_border, () {})),

          // Bottom Sheet
          DraggableScrollableSheet(
            initialChildSize: 0.65,
            maxChildSize: 0.95,
            minChildSize: 0.5,
            builder: (context, controller) {
              return Container(
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
                ),
                child: ProviderInfoScreen(scrollController: controller),
              );
            },
          ),
        ],
      );
    },
  );
}

Widget _circleIcon(IconData icon, VoidCallback onTap) => Container(
  decoration: BoxDecoration(color: Colors.black.withOpacity(0.6), shape: BoxShape.circle),
  child: IconButton(
    icon: Icon(icon, color: white),
    onPressed: onTap,
  ),
);
