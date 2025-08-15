// ignore_for_file: deprecated_member_use, use_key_in_widget_constructors

import 'package:cutcy/constants/constants.dart';
import 'package:cutcy/home/appointment/appointment_controller.dart';
import 'package:cutcy/home/bookings/booking_success_screen.dart';
import 'package:cutcy/home/bookings/bookings_controller.dart';
import 'package:cutcy/widgets/AppButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class BookingScreen extends StatelessWidget {
  final BookingController controller = Get.put(BookingController());

  final List<String> services = ['Hair Cut', 'Hair Styling', 'Hair Treatment'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text("Checkout", style: TextStyle(color: white)),
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          children: [
            Expanded(
              child: Obx(
                () => ListView(
                  children: services.map((service) {
                    final isSelected = controller.isSelected(service);
                    final quantity = controller.serviceQuantities[service] ?? 1;
                    return Container(
                      margin: EdgeInsets.only(bottom: 12.h),
                      padding: EdgeInsets.all(12.r),
                      decoration: BoxDecoration(color: ksecondaryColor, borderRadius: BorderRadius.circular(12.r)),
                      child: Row(
                        children: [
                          Checkbox(
                            side: const BorderSide(color: kprimaryColor, width: 2),
                            value: isSelected,
                            onChanged: (_) => controller.toggleService(service),
                            activeColor: kprimaryColor,
                            checkColor: white,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(service, style: TextStyle(color: white)),
                                Text("\$20.50", style: TextStyle(color: Colors.grey[400])),
                              ],
                            ),
                          ),
                          if (isSelected)
                            Container(
                              width: 80.w,
                              height: 30.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: backgroundColor.withOpacity(0.3),
                                border: Border.all(color: grey.withOpacity(0.3)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      controller.decrement(service);
                                    },
                                    child: Container(
                                      height: 20.h,
                                      width: 20.w,
                                      decoration: BoxDecoration(color: kprimaryColor, borderRadius: BorderRadius.circular(5)),
                                      child: Icon(Icons.remove, color: black, size: 20),
                                    ),
                                  ),
                                  8.horizontalSpace,

                                  Text(quantity.toString().padLeft(2, '0'), style: TextStyle(color: white)),
                                  8.horizontalSpace,
                                  GestureDetector(
                                    onTap: () {
                                      controller.increment(service);
                                    },
                                    child: Container(
                                      height: 20.h,
                                      width: 20.w,
                                      decoration: BoxDecoration(color: kprimaryColor, borderRadius: BorderRadius.circular(5)),
                                      child: Icon(Icons.add, color: black, size: 20),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            Divider(color: grey),
            Obx(
              () => Column(
                children: [
                  _priceRow("Sub Total:", controller.subTotal),
                  _priceRow("Discount:", -controller.discount),
                  _priceRow("Platform Fee:", controller.platformFee),
                  Divider(color: grey),
                  _priceRow("Total:", controller.total, isTotal: true),
                ],
              ),
            ),
            SizedBox(height: 12.h),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 65.h, top: 30.h),
        decoration: BoxDecoration(
          color: ksecondaryColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
        ),
        child: AuthButton(
          text: "Proceed",
          onTap: () {
            Get.to(
              () => BookingSuccessScreen(
                appointment: Appointment(name: "Richard Anderson", date: DateTime.now(), price: 123.0),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _priceRow(String label, double value, {bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: white)),
          Text(
            "\$${value.toStringAsFixed(2)}",
            style: TextStyle(color: isTotal ? kprimaryColor : white, fontWeight: isTotal ? FontWeight.bold : FontWeight.normal),
          ),
        ],
      ),
    );
  }
}
