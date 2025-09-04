// ignore_for_file: deprecated_member_use, unused_local_variable, avoid_print, sized_box_for_whitespace

import 'package:cutcy/constants/constants.dart';
import 'package:cutcy/home/bookings/book_now_screen.dart';
import 'package:cutcy/home/homes/barber_model.dart';
import 'package:cutcy/widgets/backend_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SearchResulteScreen extends StatelessWidget {
  final String searchQuery;
  final String? selectedService;
  final List<BarberData> searchResults;

  const SearchResulteScreen({super.key, required this.searchQuery, this.selectedService, required this.searchResults});

  @override
  Widget build(BuildContext context) {
    // Filter results by selected service if provided
    final filteredResults = selectedService != null
        ? searchResults.where((barber) {
            return barber.barberService?.any((service) => service.serviceCategory?.service == selectedService) ?? false;
          }).toList()
        : searchResults;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Search Results',
          style: TextStyle(color: white, fontSize: 18.sp),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search info header
          Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Results for "$searchQuery"',
                  style: TextStyle(color: white, fontSize: 16.sp, fontWeight: FontWeight.w600),
                ),
                if (selectedService != null) ...[
                  4.verticalSpace,
                  Text(
                    'Filtered by: $selectedService',
                    style: TextStyle(color: kprimaryColor, fontSize: 14.sp),
                  ),
                ],
                8.verticalSpace,
                Text(
                  '${filteredResults.length} barbers found',
                  style: TextStyle(color: Colors.white70, fontSize: 14.sp),
                ),
              ],
            ),
          ),

          // Results list
          Expanded(
            child: filteredResults.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    itemCount: filteredResults.length,
                    itemBuilder: (context, index) {
                      final barber = filteredResults[index];
                      return _buildBarberCard(barber);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarberCard(BarberData barber) {
    final address = (barber.addressName?.isNotEmpty ?? false)
        ? barber.addressName!
        : [barber.addressLine1, barber.city].where((e) => (e ?? '').isNotEmpty).join(', ');

    // Get services for this barber
    final services = barber.barberService?.map((s) => s.serviceCategory?.service).where((s) => s != null).toList() ?? [];

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: ksecondaryColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Barber image
              BackendImage.circle(url: barber.image, size: 60.w),
              16.horizontalSpace,

              // Barber info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      barber.name ?? 'Unknown',
                      style: TextStyle(color: white, fontSize: 16.sp, fontWeight: FontWeight.w600),
                    ),
                    4.verticalSpace,
                    Text(
                      address,
                      style: TextStyle(color: Colors.white70, fontSize: 12.sp),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    8.verticalSpace,
                    Row(
                      children: [
                        if (barber.barberExperience?.title != null) ...[
                          Icon(Icons.workspace_premium, color: kprimaryColor, size: 16.sp),
                          4.horizontalSpace,
                          Expanded(
                            child: Text(
                              barber.barberExperience!.title!,
                              style: TextStyle(color: kprimaryColor, fontSize: 12.sp),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              // Book button
              SizedBox(
                width: 80.w,
                height: 36.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kprimaryColor,
                    foregroundColor: black,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                  ),
                  onPressed: () {
                    Get.to(() => BookNowScreen(barberData: barber, isFromFav: false));
                  },
                  child: Text(
                    'Book',
                    style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),

          // Services offered
          if (services.isNotEmpty) ...[
            12.verticalSpace,
            Text(
              'Services:',
              style: TextStyle(color: Colors.white70, fontSize: 12.sp, fontWeight: FontWeight.w500),
            ),
            4.verticalSpace,
            Wrap(
              spacing: 6.w,
              runSpacing: 4.h,
              children: services
                  .take(3)
                  .map(
                    (service) => Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                      decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(12.r)),
                      child: Text(
                        service!,
                        style: TextStyle(color: white, fontSize: 10.sp),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, color: Colors.white60, size: 64.sp),
          16.verticalSpace,
          Text(
            'No results found',
            style: TextStyle(color: white, fontSize: 18.sp, fontWeight: FontWeight.w600),
          ),
          8.verticalSpace,
          Text(
            selectedService != null ? 'No barbers offer "$selectedService" service' : 'Try adjusting your search criteria',
            style: TextStyle(color: Colors.white60, fontSize: 14.sp),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
