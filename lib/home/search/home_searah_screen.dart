// ignore_for_file: library_private_types_in_public_api

import 'package:cutcy/constants/constants.dart';
import 'package:cutcy/home/homes/barber_model.dart';
import 'package:cutcy/home/search/search_controller.dart';
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
  // Search controller
  final BarberSearchController searchC = Get.put(BarberSearchController());
  final TextEditingController textController = TextEditingController();

  // Track the currently selected tag
  String? selectedTag;

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

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
            Container(
              decoration: BoxDecoration(color: Colors.grey[800], borderRadius: BorderRadius.circular(14.r)),
              child: TextField(
                controller: textController,
                onChanged: (query) {
                  searchC.searchBarbers(query);
                },
                onSubmitted: (query) {
                  if (query.trim().isNotEmpty) {
                    _performSearch();
                  }
                },
                style: TextStyle(color: white, fontSize: 15.sp),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search services or barbers',
                  hintStyle: TextStyle(color: Colors.white54),
                  prefixIcon: Icon(Icons.search, color: Colors.white54),
                  suffixIcon: Obx(
                    () => searchC.isSearching.value
                        ? Padding(
                            padding: EdgeInsets.all(12.r),
                            child: SizedBox(
                              width: 20.w,
                              height: 20.h,
                              child: CircularProgressIndicator(strokeWidth: 2, color: kprimaryColor),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ),
              ),
            ),
            18.verticalSpace,

            // Search suggestions and results
            Expanded(
              child: Obx(() {
                // Show search results if we have an active search
                if (searchC.searchQuery.value.isNotEmpty) {
                  return _buildSearchResults();
                }
                // Show suggestions when no search
                return _buildSearchSuggestions();
              }),
            ),

            // Show continue button if tag is selected or we have search results
            Obx(() {
              final hasResults = searchC.searchResults.isNotEmpty;
              final hasQuery = searchC.searchQuery.value.isNotEmpty;
              final hasSelection = selectedTag != null;

              if (hasResults || hasSelection) {
                return Column(
                  children: [
                    16.verticalSpace,
                    AuthButton(
                      textColor: black,
                      text: "Continue",
                      onTap: () {
                        _performSearch();
                      },
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    return Obx(() {
      if (searchC.isSearching.value) {
        return const Center(child: CircularProgressIndicator(color: kprimaryColor));
      }

      if (searchC.searchError.value != null) {
        return _buildErrorState();
      }

      if (searchC.searchResults.isEmpty) {
        return _buildEmptyState();
      }

      // Show results count and tag selection
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${searchC.searchResults.length} results found",
            style: TextStyle(color: white, fontSize: 16.sp, fontWeight: FontWeight.w600),
          ),
          12.verticalSpace,

          // Service tags for filtering
          Text(
            "Filter by service:",
            style: TextStyle(color: white, fontSize: 14.sp),
          ),
          8.verticalSpace,

          // Extract unique services from results
          _buildServiceTags(),

          16.verticalSpace,

          // Results preview (first 3)
          Text(
            "Preview:",
            style: TextStyle(color: Colors.white70, fontSize: 14.sp),
          ),
          8.verticalSpace,

          Expanded(
            child: ListView.builder(
              itemCount: searchC.searchResults.length > 3 ? 3 : searchC.searchResults.length,
              itemBuilder: (context, index) {
                final barber = searchC.searchResults[index];
                return _buildBarberPreviewCard(barber);
              },
            ),
          ),
        ],
      );
    });
  }

  Widget _buildSearchSuggestions() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recent searches
          Obx(() {
            if (searchC.recentSearches.isEmpty) return const SizedBox.shrink();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent Searches',
                      style: TextStyle(color: white, fontSize: 16.sp, fontWeight: FontWeight.w600),
                    ),
                    TextButton(
                      onPressed: () => searchC.clearRecentSearches(),
                      child: Text(
                        'Clear All',
                        style: TextStyle(color: kprimaryColor, fontSize: 12.sp),
                      ),
                    ),
                  ],
                ),
                8.verticalSpace,
                ...searchC.recentSearches
                    .take(5)
                    .map(
                      (search) => _buildSuggestionTile(
                        search,
                        Icons.history,
                        onTap: () {
                          textController.text = search;
                          searchC.searchBarbers(search);
                        },
                        onRemove: () => searchC.removeFromRecent(search),
                      ),
                    ),
                24.verticalSpace,
              ],
            );
          }),

          // Popular services
          Text(
            'Popular Services',
            style: TextStyle(color: white, fontSize: 16.sp, fontWeight: FontWeight.w600),
          ),
          12.verticalSpace,
          Wrap(spacing: 8.w, runSpacing: 8.h, children: searchC.popularSearches.map((service) => _buildServiceChip(service)).toList()),
        ],
      ),
    );
  }

  Widget _buildServiceTags() {
    // Extract unique services from search results
    final services = <String>{};
    for (final barber in searchC.searchResults) {
      if (barber.barberService != null) {
        for (final service in barber.barberService!) {
          if (service.serviceCategory?.service != null) {
            services.add(service.serviceCategory!.service!);
          }
        }
      }
    }

    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: services.map((service) {
        return ChoiceChip(
          label: Text(service),
          labelStyle: TextStyle(color: white),
          backgroundColor: Colors.grey[800],
          selectedColor: kprimaryColor,
          selected: selectedTag == service,
          onSelected: (selected) {
            setState(() {
              selectedTag = selected ? service : null;
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildServiceChip(String service) {
    return GestureDetector(
      onTap: () {
        textController.text = service;
        searchC.searchByService(service);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: ksecondaryColor,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: Colors.white12),
        ),
        child: Text(
          service,
          style: TextStyle(color: white, fontSize: 12.sp),
        ),
      ),
    );
  }

  Widget _buildSuggestionTile(String title, IconData icon, {VoidCallback? onTap, VoidCallback? onRemove}) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Colors.white60, size: 20.sp),
      title: Text(
        title,
        style: TextStyle(color: white, fontSize: 14.sp),
      ),
      trailing: onRemove != null
          ? IconButton(
              icon: Icon(Icons.close, color: Colors.white60, size: 18.sp),
              onPressed: onRemove,
            )
          : Icon(Icons.north_west, color: Colors.white60, size: 16.sp),
      onTap: onTap,
    );
  }

  Widget _buildBarberPreviewCard(BarberData barber) {
    final address = (barber.addressName?.isNotEmpty ?? false)
        ? barber.addressName!
        : [barber.addressLine1, barber.city].where((e) => (e ?? '').isNotEmpty).join(', ');

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: ksecondaryColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        children: [
          // Barber avatar
          CircleAvatar(
            radius: 25.r,
            backgroundColor: Colors.white12,
            child: Icon(Icons.person, color: white, size: 25.sp),
          ),
          12.horizontalSpace,

          // Barber info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  barber.name ?? 'Unknown',
                  style: TextStyle(color: white, fontSize: 14.sp, fontWeight: FontWeight.w600),
                ),
                Text(
                  address,
                  style: TextStyle(color: Colors.white60, fontSize: 12.sp),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (barber.barberExperience?.title != null)
                  Text(
                    barber.barberExperience!.title!,
                    style: TextStyle(color: kprimaryColor, fontSize: 11.sp),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: Colors.red, size: 48.sp),
          16.verticalSpace,
          Text(
            'Search Error',
            style: TextStyle(color: white, fontSize: 16.sp, fontWeight: FontWeight.w600),
          ),
          8.verticalSpace,
          Text(
            searchC.searchError.value ?? '',
            style: TextStyle(color: Colors.white60, fontSize: 14.sp),
            textAlign: TextAlign.center,
          ),
          24.verticalSpace,
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: kprimaryColor, foregroundColor: black),
            onPressed: () {
              if (textController.text.isNotEmpty) {
                searchC.searchBarbers(textController.text);
              }
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, color: Colors.white60, size: 48.sp),
          16.verticalSpace,
          Text(
            'No barbers found',
            style: TextStyle(color: white, fontSize: 16.sp, fontWeight: FontWeight.w600),
          ),
          8.verticalSpace,
          Text(
            'Try searching with different keywords',
            style: TextStyle(color: Colors.white60, fontSize: 14.sp),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _performSearch() {
    // Navigate to results screen with current search state
    Get.to(() => SearchResulteScreen(searchQuery: searchC.searchQuery.value, selectedService: selectedTag, searchResults: searchC.searchResults));
  }
}
