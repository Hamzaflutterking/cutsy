// ignore_for_file: library_private_types_in_public_api

import 'package:cutcy/constants/constants.dart';
import 'package:cutcy/home/search/search_result_screen.dart';

import 'package:cutcy/widgets/AppButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class BarberSearchScreen extends StatefulWidget {
  const BarberSearchScreen({super.key});

  @override
  _BarberSearchScreenState createState() => _BarberSearchScreenState();
}

class _BarberSearchScreenState extends State<BarberSearchScreen> {
  // Track the currently selected tag
  String? selectedTag;
  String searchQuery = ''; // Search query

  // List of tags for search
  final List<String> tags = ["Hair extensions", "Beard styling", "Hair styling", "Hair coloring", "Beard trimming", "Hair cutting", "Hair treatment"];

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
        title: const Text("Search", style: TextStyle(color: white)),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar
            GestureDetector(
              onTap: () {
                // You can trigger any additional search logic here if needed
              },
              child: Container(
                decoration: BoxDecoration(color: Colors.grey[800], borderRadius: BorderRadius.circular(14.r)),
                child: TextField(
                  onChanged: (query) {
                    setState(() {
                      searchQuery = query; // Capture the search query
                    });
                  },
                  style: TextStyle(color: white, fontSize: 15.sp),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Search services or barbers',
                    hintStyle: TextStyle(color: Colors.white54),
                    prefixIcon: Icon(Icons.search, color: Colors.white54),
                  ),
                ),
              ),
            ),
            18.verticalSpace,

            // Show tags only when user starts typing in search bar
            if (searchQuery.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Select a service:",
                    style: TextStyle(color: white, fontSize: 16.sp),
                  ),
                  12.verticalSpace,

                  // Tags displayed as chips (acting like radio buttons)
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: tags.map((tag) {
                      return ChoiceChip(
                        label: Text(tag),
                        labelStyle: TextStyle(color: white),
                        backgroundColor: Colors.grey[800],
                        selectedColor: kprimaryColor,
                        selected: selectedTag == tag, // Check if this tag is selected
                        autofocus: false,
                        clipBehavior: Clip.none,
                        onSelected: (selected) {
                          setState(() {
                            selectedTag = selected ? tag : null; // Set selected tag
                          });
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            25.verticalSpace,

            // Show the "Continue" button only if a tag is selected or search is not empty
            if (selectedTag != null || searchQuery.isNotEmpty)
              AuthButton(
                textColor: black,
                text: "Continue",
                onTap: () {
                  // Pass the search query and selected tag to the results screen
                  Get.to(() => SearchResulteScreen());
                },
              ),
          ],
        ),
      ),
    );
  }
}
