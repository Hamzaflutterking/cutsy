// ignore_for_file: deprecated_member_use, unused_local_variable, avoid_print, sized_box_for_whitespace

import 'package:cutcy/constants/constants.dart';
import 'package:cutcy/home/bookings/book_now_screen.dart';
import 'package:cutcy/widgets/AppButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class FilterController extends GetxController {
  // Observable state for checkboxes
  var selectedExperienceLevel = RxList<bool>([false, false, false]); // Example for 3 experience levels
  var selectedServices = RxList<bool>([false, false, false, false, false, false, false]); // 7 services
  var selectedDays = RxList<bool>([false, false, false, false, false, false, false]); // 7 days
  var selectedHours = RxList<bool>([false, false, false, false, false]); // 5 time slots
}

class SearchResulteScreen extends StatelessWidget {
  const SearchResulteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FilterController filterController = Get.put(FilterController());
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: white),
          onPressed: () => Get.back(),
        ),
        title: const Text("Search Results", style: TextStyle(color: white)),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 250,
                  decoration: BoxDecoration(color: Colors.grey[800], borderRadius: BorderRadius.circular(14.r)),
                  child: TextField(
                    style: TextStyle(color: white, fontSize: 15.sp),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search services or barbers',
                      hintStyle: TextStyle(color: Colors.white54, fontSize: 12),
                      prefixIcon: Icon(Icons.search, color: Colors.white54),
                    ),
                  ),
                ),
                // Sort icon (Arrows)
                Container(
                  decoration: BoxDecoration(color: Colors.grey[800], borderRadius: BorderRadius.circular(12.r)),
                  child: IconButton(
                    icon: Image.asset("assets/icons/ArrowsLeftRight.png", scale: 4),
                    onPressed: () {
                      // Show bottom sheet with sort options
                      _showSortOptions(context);
                    },
                  ),
                ),
                // Filter icon
                Container(
                  decoration: BoxDecoration(color: Colors.grey[800], borderRadius: BorderRadius.circular(12.r)),
                  child: IconButton(
                    icon: Image.asset("assets/icons/SlidersHorizontal.png", scale: 4),
                    onPressed: () {
                      // Show filter options
                      _showFilterOptions(context);
                    },
                  ),
                ),
              ],
            ),
            18.verticalSpace,

            // Showing search results text
            Text(
              'Showing X search results for "searchQuery"',
              style: TextStyle(color: white, fontSize: 14.sp),
            ),
            18.verticalSpace,

            // Search results list
            Expanded(
              child: ListView.separated(
                itemCount: 6, // Update with dynamic barbers list
                separatorBuilder: (_, __) => SizedBox(height: 12.h),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Get.to(() => BookNowScreen()); // Navigate to BookNowScreen
                    },
                    child: Card(
                      color: ksecondaryColor,
                      margin: EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 12.w),
                        leading: CircleAvatar(backgroundImage: AssetImage("assets/images/Frame 567 (2).png"), radius: 24.r),
                        title: Text(
                          "Richard Anderson",
                          style: TextStyle(color: white, fontWeight: FontWeight.w600, fontSize: 14.sp),
                        ),
                        subtitle: Text(
                          '134 North Square, New York',
                          style: TextStyle(color: Colors.white70, fontSize: 12.sp),
                        ),
                        trailing: Icon(Icons.more_vert, color: Colors.white38, size: 21.sp),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Show the bottom sheet with sort options
  void _showSortOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: ksecondaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50)),
      ),
      builder: (BuildContext context) {
        return Container(
          height: 350.h, // Set a fixed height for the bottom sheet
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title with close icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Sort By',
                      style: TextStyle(color: white, fontWeight: FontWeight.w600, fontSize: 18.sp),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.yellow),
                      onPressed: () {
                        Get.back(); // Close the bottom sheet
                      },
                    ),
                  ],
                ),
                12.verticalSpace,

                // Sort options in a scrollable column
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: ['Price (Low to High)', 'Price (High to Low)', 'Rating', 'Experience']
                          .map(
                            (option) => ListTile(
                              title: Text(option, style: TextStyle(color: white)),
                              onTap: () {
                                // Set the selected sort option
                                print('Selected: $option');
                                Get.back(); // Close the bottom sheet
                              },
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showFilterOptions(BuildContext context) {
    showModalBottomSheet(
      scrollControlDisabledMaxHeightRatio: 0.9,
      context: context,
      backgroundColor: ksecondaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      ),
      builder: (BuildContext context) {
        final FilterController filterController = Get.find(); // Get the instantiated controller

        return Padding(
          padding: EdgeInsets.all(12.r),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                20.verticalSpace,
                // Title with close icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Filters',
                      style: TextStyle(color: white, fontWeight: FontWeight.bold, fontSize: 18.sp),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, size: 30, color: kprimaryColor),
                      onPressed: () {
                        Get.back(); // Close the bottom sheet
                      },
                    ),
                  ],
                ),
                Divider(color: grey.withOpacity(0.5)),
                12.verticalSpace,

                // Experience Level Filters
                Text(
                  'Experience Level',
                  style: TextStyle(color: kprimaryColor, fontWeight: FontWeight.bold, fontSize: 16.sp),
                ),
                8.verticalSpace,
                Obx(
                  () => Column(
                    children: ['Apprentice', 'Senior Stylist', 'Master Stylist']
                        .asMap()
                        .entries
                        .map(
                          (entry) => CheckboxListTile(
                            side: const BorderSide(color: kprimaryColor, width: 3),
                            selectedTileColor: kprimaryColor,
                            checkColor: white,

                            activeColor: kprimaryColor, // Color when checked
                            hoverColor: kprimaryColor,

                            title: Text(entry.value, style: TextStyle(color: white)),
                            value: filterController.selectedExperienceLevel[entry.key],
                            onChanged: (value) {
                              filterController.selectedExperienceLevel[entry.key] = value!;
                            },
                          ),
                        )
                        .toList(),
                  ),
                ),
                12.verticalSpace,

                // Services Filters
                Text(
                  'Services',
                  style: TextStyle(color: kprimaryColor, fontWeight: FontWeight.bold, fontSize: 16.sp),
                ),
                8.verticalSpace,
                Obx(
                  () => Column(
                    children: ['Hair cut', 'Hair styling', 'Hair coloring', 'Hair treatment', 'Hair extensions', 'Beard styling', 'Beard trimming']
                        .asMap()
                        .entries
                        .map(
                          (entry) => CheckboxListTile(
                            side: const BorderSide(color: kprimaryColor, width: 3),
                            activeColor: kprimaryColor,
                            title: Text(entry.value, style: TextStyle(color: white)),
                            value: filterController.selectedServices[entry.key],
                            onChanged: (value) {
                              filterController.selectedServices[entry.key] = value!;
                            },
                          ),
                        )
                        .toList(),
                  ),
                ),
                12.verticalSpace,

                // Availability (Days) Filters
                Text(
                  'Availability (Days)',
                  style: TextStyle(color: kprimaryColor, fontWeight: FontWeight.bold, fontSize: 16.sp),
                ),
                8.verticalSpace,
                Obx(
                  () => Column(
                    children: ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday']
                        .asMap()
                        .entries
                        .map(
                          (entry) => CheckboxListTile(
                            side: const BorderSide(color: kprimaryColor, width: 3),
                            activeColor: kprimaryColor,
                            title: Text(entry.value, style: TextStyle(color: white)),
                            value: filterController.selectedDays[entry.key],
                            onChanged: (value) {
                              filterController.selectedDays[entry.key] = value!;
                            },
                          ),
                        )
                        .toList(),
                  ),
                ),
                12.verticalSpace,

                // Availability (Hours) Filters
                Text(
                  'Availability (Hours)',
                  style: TextStyle(color: kprimaryColor, fontWeight: FontWeight.bold, fontSize: 16.sp),
                ),
                8.verticalSpace,
                Obx(
                  () => Column(
                    children:
                        [
                              'Morning (8:00 AM – 12:00 PM)',
                              'Afternoon (12:00 PM – 4:00 PM)',
                              'Evening (4:00 PM – 8:00 PM)',
                              'Full Day (8:00 AM – 8:00 PM)',
                              'Flexible hours (As needed)',
                            ]
                            .asMap()
                            .entries
                            .map(
                              (entry) => CheckboxListTile(
                                side: const BorderSide(color: kprimaryColor, width: 3),
                                activeColor: kprimaryColor,
                                title: Text(entry.value, style: TextStyle(color: white)),
                                value: filterController.selectedHours[entry.key],
                                onChanged: (value) {
                                  filterController.selectedHours[entry.key] = value!;
                                },
                              ),
                            )
                            .toList(),
                  ),
                ),
                18.verticalSpace,

                // Save Button
                AuthButton(text: "Save", onTap: () {}),
              ],
            ),
          ),
        );
      },
    );
  }
}
