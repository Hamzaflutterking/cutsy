// ignore_for_file: unnecessary_import, unnecessary_to_list_in_spreads, deprecated_member_use

import 'dart:ui';
import 'package:cutcy/constants/constants.dart';
import 'package:cutcy/home/homes/barber_model.dart';
import 'package:cutcy/home/homes/favs/fav_barber_model.dart' as fav_model;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class ProviderInfoScreen extends StatefulWidget {
  final ScrollController scrollController;
  final BarberData? barberData;
  final fav_model.FavBarberData? favBarberData;
  final bool isFromFav;

  const ProviderInfoScreen({super.key, required this.scrollController, this.barberData, this.favBarberData, required this.isFromFav});

  @override
  State<ProviderInfoScreen> createState() => _ProviderInfoScreenState();
}

class _ProviderInfoScreenState extends State<ProviderInfoScreen> {
  double selectedRating = 0;

  // Helper getters for barber data
  String get _barberName {
    if (widget.isFromFav) {
      return widget.favBarberData?.barber?.name ?? 'Unknown Barber';
    } else {
      return widget.barberData?.name ?? 'Unknown Barber';
    }
  }

  String get _barberExperience {
    if (widget.isFromFav) {
      return widget.favBarberData?.barber?.barberExperience?.title ?? 'Experience not specified';
    } else {
      return widget.barberData?.barberExperience?.title ?? widget.barberData?.experience ?? 'Experience not specified';
    }
  }

  double get _averageRating {
    if (widget.isFromFav) {
      return 4.8; // Fav model doesn't include rating
    } else {
      return widget.barberData?.averageRating ?? 4.8;
    }
  }

  int get _totalReviews {
    if (widget.isFromFav) {
      return 114; // Fav model doesn't include review count
    } else {
      return widget.barberData?.totalReviews ?? 114;
    }
  }

  String get _address {
    if (widget.isFromFav) {
      final b = widget.favBarberData?.barber;
      if ((b?.addressName ?? '').isNotEmpty) return b!.addressName!;
      return [b?.addressLine1, b?.city, b?.country].where((e) => (e ?? '').isNotEmpty).join(', ');
    } else {
      final b = widget.barberData;
      if ((b?.addressName ?? '').isNotEmpty) return b!.addressName!;
      return [b?.addressLine1, b?.city, b?.country].where((e) => (e ?? '').isNotEmpty).join(', ');
    }
  }

  LatLng get _barberLocation {
    if (widget.isFromFav) {
      final b = widget.favBarberData?.barber;
      return LatLng(b?.latitude ?? 43.651070, b?.longitude ?? -79.347015);
    } else {
      final b = widget.barberData;
      return LatLng(b?.latitude ?? 43.651070, b?.longitude ?? -79.347015);
    }
  }

  String? get _barberImage {
    if (widget.isFromFav) {
      return widget.favBarberData?.barber?.image as String?;
    } else {
      return widget.barberData?.image;
    }
  }

  // Mock reviews data - you can replace this with real reviews from API
  final List<Map<String, dynamic>> reviews = [
    {'rating': 5, 'comment': 'Fantastic service! Really professional.', 'user': 'John D.', 'date': '1 week ago'},
    {'rating': 5, 'comment': 'Loved my haircut! Will definitely come back.', 'user': 'Sarah M.', 'date': '2 weeks ago'},
    {'rating': 4, 'comment': 'Good quality work, took a bit longer than expected.', 'user': 'Mike T.', 'date': '3 weeks ago'},
    {'rating': 5, 'comment': 'Very polite and friendly barber!', 'user': 'Emma L.', 'date': '1 month ago'},
    {'rating': 5, 'comment': 'Amazing attention to detail. Highly recommended!', 'user': 'David R.', 'date': '1 month ago'},
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
                  _barberName.toUpperCase(),
                  style: TextStyle(color: white, fontWeight: FontWeight.bold, fontSize: 18.sp),
                ),
                SizedBox(height: 4.h),
                Text(
                  _address,
                  style: TextStyle(color: Colors.white70, fontSize: 12.sp),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    _infoBox(Icons.workspace_premium_rounded, _barberExperience, "Experience"),
                    SizedBox(width: 16.w),
                    _infoBox(Icons.star, _averageRating.toStringAsFixed(1), "Rating"),
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
                options: MapOptions(initialCenter: _barberLocation, initialZoom: 14),
                children: [
                  TileLayer(
                    urlTemplate: "https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png",
                    subdomains: ['a', 'b', 'c'],
                    userAgentPackageName: 'com.example.cutcy',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: _barberLocation,
                        width: 40.w,
                        height: 40.h,
                        child: Icon(Icons.location_pin, color: backgroundColor, size: 40),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          /// Ratings Overview
          SizedBox(height: 16.h),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(color: ksecondaryColor, borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                Text(
                  _averageRating.toStringAsFixed(1),
                  style: TextStyle(fontSize: 32.sp, color: white, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return Icon(index < _averageRating.floor() ? Icons.star : Icons.star_border, color: kprimaryColor, size: 16.sp);
                  }),
                ),
                SizedBox(height: 4.h),
                Text("Overall Rating", style: TextStyle(color: Colors.white70)),
                Text(
                  "Based on $_totalReviews reviews",
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

          /// Services (if available)
          if (_hasServices()) ...[
            SizedBox(height: 16.h),
            Text(
              "SERVICES",
              style: TextStyle(color: Colors.white70, fontSize: 13.sp),
            ),
            SizedBox(height: 8.h),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(color: ksecondaryColor, borderRadius: BorderRadius.circular(12)),
              child: Column(children: _buildServicesList()),
            ),
          ],

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
                style: TextStyle(color: selectedRating == i.toDouble() ? kprimaryColor : Colors.white54, fontSize: 12.sp),
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
            return Container(
              margin: EdgeInsets.only(bottom: 16.h),
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(color: Colors.grey[850], borderRadius: BorderRadius.circular(8.r)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ...List.generate(review['rating'], (_) => Icon(Icons.star, size: 16, color: kprimaryColor)),
                      ...List.generate(5 - int.parse(review['rating'].toString()), (_) => Icon(Icons.star_border, size: 16, color: Colors.grey)),
                      Spacer(),
                      Text(
                        review['date'],
                        style: TextStyle(color: Colors.white54, fontSize: 10.sp),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    review['comment'],
                    style: TextStyle(color: white, fontSize: 13.sp),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    "— ${review['user']}",
                    style: TextStyle(color: Colors.white54, fontSize: 11.sp, fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            );
          }).toList(),

          SizedBox(height: 50.h), // Bottom padding
        ],
      ),
    );
  }

  bool _hasServices() {
    if (widget.isFromFav) {
      return widget.favBarberData?.barber?.barberService?.isNotEmpty ?? false;
    } else {
      return widget.barberData?.barberService?.isNotEmpty ?? false;
    }
  }

  List<Widget> _buildServicesList() {
    if (widget.isFromFav) {
      final services = widget.favBarberData?.barber?.barberService ?? [];
      return services.map((service) => _buildServiceItem(service.serviceCategory?.service ?? 'Service', service.price ?? '0')).toList();
    } else {
      final services = widget.barberData?.barberService ?? [];
      return services.map((service) => _buildServiceItem(service.serviceCategory?.service ?? 'Service', service.price ?? '0')).toList();
    }
  }

  Widget _buildServiceItem(String serviceName, String price) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          Icon(Icons.cut, color: kprimaryColor, size: 16.sp),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              serviceName,
              style: TextStyle(color: white, fontSize: 13.sp),
            ),
          ),
          Text(
            '\$$price',
            style: TextStyle(color: kprimaryColor, fontSize: 13.sp, fontWeight: FontWeight.w600),
          ),
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
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          label,
          style: TextStyle(color: Colors.white54, fontSize: 11.sp),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );

  Widget _buildRatingBar(int star, int percent) => Padding(
    padding: EdgeInsets.symmetric(vertical: 2.h),
    child: Row(
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
    ),
  );

  Widget _iconButton(IconData icon, VoidCallback onTap) => CircleAvatar(
    backgroundColor: Colors.black54,
    child: IconButton(
      icon: Icon(icon, color: white),
      onPressed: onTap,
    ),
  );
}

/// ✅ Updated Modal Bottom Sheet function to accept barber data
void showProviderInfoBottomSheet(BuildContext context, {BarberData? barberData, fav_model.FavBarberData? favBarberData, required bool isFromFav}) {
  // Get the background image
  String? imageUrl;
  if (isFromFav) {
    imageUrl = favBarberData?.barber?.image as String?;
  } else {
    imageUrl = barberData?.image;
  }

  final ImageProvider backgroundImage = (imageUrl != null && imageUrl.isNotEmpty)
      ? NetworkImage(imageUrl)
      : const AssetImage("assets/images/young-hispanic-haidresser-and-hairstylist-standing-2024-10-18-17-47-23-utc 1.png");

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
            decoration: BoxDecoration(
              image: DecorationImage(image: backgroundImage, fit: BoxFit.cover),
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
                child: ProviderInfoScreen(scrollController: controller, barberData: barberData, favBarberData: favBarberData, isFromFav: isFromFav),
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
