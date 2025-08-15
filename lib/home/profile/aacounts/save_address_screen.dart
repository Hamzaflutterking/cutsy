// ignore_for_file: must_be_immutable, use_key_in_widget_constructors

import 'package:cutcy/constants/constants.dart';
import 'package:cutcy/widgets/AppButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SavedAddressesScreen extends StatelessWidget {
  // Observable list of saved addresses
  var addresses = [
    {'name': 'Home', 'address': '134 North Square, Toronto, ON M5S 2E5, Canada'},
    {'name': 'Office', 'address': '75 St George Street, Toronto, ON M5S 2E5, Canada'},
  ].obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text('Saved Addresses', style: TextStyle(color: white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and description
            SizedBox(height: 20.h),

            // List of saved addresses
            Obx(
              () => ListView.builder(
                shrinkWrap: true,
                itemCount: addresses.length,
                itemBuilder: (context, index) {
                  final address = addresses[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 6.h),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 40.h),
                      decoration: BoxDecoration(
                        border: Border.all(color: kprimaryColor),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.location_on, color: kprimaryColor, size: 18),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  address['name']!,
                                  style: TextStyle(color: white, fontSize: 14.sp, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  address['address']!,
                                  style: TextStyle(color: Colors.white54, fontSize: 12.sp),
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'View on map',
                              style: TextStyle(color: kprimaryColor, fontSize: 12.sp),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            Spacer(),

            // Button to add new address
            SizedBox(
              width: double.infinity,
              child: AuthButton(text: "Add New Address", onTap: () {}),
            ),
            50.verticalSpace,
          ],
        ),
      ),
    );
  }
}
