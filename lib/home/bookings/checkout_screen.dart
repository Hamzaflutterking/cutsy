// // ignore_for_file: deprecated_member_use, use_key_in_widget_constructors

import 'package:cutcy/constants/constants.dart';
import 'package:cutcy/home/appointment/appointment_controller.dart';
import 'package:cutcy/home/bookings/booking_success_screen.dart';
import 'package:cutcy/home/bookings/bookings_controller.dart';
import 'package:cutcy/shared_preferences.dart';
import 'package:cutcy/widgets/AppButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

// class CheckoutScreen extends StatelessWidget {
//   final BookingController controller = Get.put(BookingController());

//   final List<String> services = ['Hair Cut', 'Hair Styling', 'Hair Treatment'];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: backgroundColor,
//       appBar: AppBar(
//         scrolledUnderElevation: 0,
//         title: Text("Checkout", style: TextStyle(color: white)),
//         backgroundColor: backgroundColor,
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: white),
//           onPressed: () => Get.back(),
//         ),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.r),
//         child: Column(
//           children: [
//             Expanded(
//               child: Obx(
//                 () => ListView(
//                   children: services.map((service) {
//                     final isSelected = controller.isSelected(service);
//                     final quantity = controller.serviceQuantities[service] ?? 1;
//                     return Container(
//                       margin: EdgeInsets.only(bottom: 12.h),
//                       padding: EdgeInsets.all(12.r),
//                       decoration: BoxDecoration(color: ksecondaryColor, borderRadius: BorderRadius.circular(12.r)),
//                       child: Row(
//                         children: [
//                           Checkbox(
//                             side: const BorderSide(color: kprimaryColor, width: 2),
//                             value: isSelected,
//                             onChanged: (_) => controller.toggleService(service),
//                             activeColor: kprimaryColor,
//                             checkColor: white,
//                           ),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(service, style: TextStyle(color: white)),
//                                 Text("\$20.50", style: TextStyle(color: Colors.grey[400])),
//                               ],
//                             ),
//                           ),
//                           if (isSelected)
//                             Container(
//                               width: 80.w,
//                               height: 30.h,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(10),
//                                 color: backgroundColor.withOpacity(0.3),
//                                 border: Border.all(color: grey.withOpacity(0.3)),
//                               ),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   GestureDetector(
//                                     onTap: () {
//                                       controller.decrement(service);
//                                     },
//                                     child: Container(
//                                       height: 20.h,
//                                       width: 20.w,
//                                       decoration: BoxDecoration(color: kprimaryColor, borderRadius: BorderRadius.circular(5)),
//                                       child: Icon(Icons.remove, color: black, size: 20),
//                                     ),
//                                   ),
//                                   8.horizontalSpace,

//                                   Text(quantity.toString().padLeft(2, '0'), style: TextStyle(color: white)),
//                                   8.horizontalSpace,
//                                   GestureDetector(
//                                     onTap: () {
//                                       controller.increment(service);
//                                     },
//                                     child: Container(
//                                       height: 20.h,
//                                       width: 20.w,
//                                       decoration: BoxDecoration(color: kprimaryColor, borderRadius: BorderRadius.circular(5)),
//                                       child: Icon(Icons.add, color: black, size: 20),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                         ],
//                       ),
//                     );
//                   }).toList(),
//                 ),
//               ),
//             ),
//             Divider(color: grey),
//             Obx(
//               () => Column(
//                 children: [
//                   _priceRow("Sub Total:", controller.subTotal),
//                   _priceRow("Discount:", -controller.discount),
//                   _priceRow("Platform Fee:", controller.platformFee),
//                   Divider(color: grey),
//                   _priceRow("Total:", controller.total, isTotal: true),
//                 ],
//               ),
//             ),
//             SizedBox(height: 12.h),
//           ],
//         ),
//       ),
//       bottomNavigationBar: Container(
//         padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 65.h, top: 30.h),
//         decoration: BoxDecoration(
//           color: ksecondaryColor,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
//         ),
//         child: AuthButton(
//           text: "Proceed",
//           onTap: () {
//             Get.to(
//               () => BookingSuccessScreen(
//                 appointment: Appointment(name: "Richard Anderson", date: DateTime.now(), price: 123.0),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   Widget _priceRow(String label, double value, {bool isTotal = false}) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 4.h),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(label, style: TextStyle(color: white)),
//           Text(
//             "\$${value.toStringAsFixed(2)}",
//             style: TextStyle(color: isTotal ? kprimaryColor : white, fontWeight: isTotal ? FontWeight.bold : FontWeight.normal),
//           ),
//         ],
//       ),
//     );
//   }
// }

// checkout_screen.dart (key parts)
class CheckoutScreen extends StatelessWidget {
  final BookingController controller = Get.find<BookingController>();

  CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: const Text("Checkout", style: TextStyle(color: white)),
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          children: [
            // Selected slot summary
            Obx(() {
              final d = controller.selectedDay.value ?? '—';
              final s = controller.selectedStart.value ?? '--:--';
              final e = controller.selectedEnd.value ?? '--:--';
              return Container(
                width: double.infinity,
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(color: ksecondaryColor, borderRadius: BorderRadius.circular(12.r)),
                child: Text("Slot: $d  $s – $e", style: const TextStyle(color: white)),
              );
            }),
            12.verticalSpace,

            // Selected services
            Expanded(
              child: Obx(() {
                final ids = controller.selectedServices.toList();
                if (ids.isEmpty) {
                  return const Center(
                    child: Text("No services selected", style: TextStyle(color: Colors.white60)),
                  );
                }
                return ListView.builder(
                  itemCount: ids.length,
                  itemBuilder: (_, i) {
                    final id = ids[i];
                    final meta = controller.serviceMeta[id]!;
                    final title = meta['title'] as String? ?? 'Service';
                    final price = (meta['price'] as double?) ?? 0.0;
                    final qty = controller.serviceQuantities[id] ?? 1;

                    return Container(
                      margin: EdgeInsets.only(bottom: 12.h),
                      padding: EdgeInsets.all(12.r),
                      decoration: BoxDecoration(color: ksecondaryColor, borderRadius: BorderRadius.circular(12.r)),
                      child: Row(
                        children: [
                          Checkbox(
                            side: const BorderSide(color: kprimaryColor, width: 2),
                            value: controller.isSelected(id),
                            onChanged: (_) => controller.toggleServiceById(id, title: title, price: price),
                            activeColor: kprimaryColor,
                            checkColor: white,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(title, style: const TextStyle(color: white)),
                                Text("\$${price.toStringAsFixed(2)}", style: TextStyle(color: Colors.grey[400])),
                              ],
                            ),
                          ),
                          if (controller.isSelected(id))
                            Container(
                              width: 88.w,
                              height: 30.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: backgroundColor.withOpacity(0.3),
                                border: Border.all(color: Colors.grey.withOpacity(0.3)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () => controller.decrement(id),
                                    child: Container(
                                      height: 20.h,
                                      width: 20.w,
                                      decoration: BoxDecoration(color: kprimaryColor, borderRadius: BorderRadius.circular(5)),
                                      child: const Icon(Icons.remove, color: black, size: 20),
                                    ),
                                  ),
                                  8.horizontalSpace,
                                  Text((qty).toString().padLeft(2, '0'), style: const TextStyle(color: white)),
                                  8.horizontalSpace,
                                  GestureDetector(
                                    onTap: () => controller.increment(id),
                                    child: Container(
                                      height: 20.h,
                                      width: 20.w,
                                      decoration: BoxDecoration(color: kprimaryColor, borderRadius: BorderRadius.circular(5)),
                                      child: const Icon(Icons.add, color: black, size: 20),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                );
              }),
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
            12.verticalSpace,
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
          onTap: () async {
            // get your token however you already do it
            final token = StorageService.to.getString("token") ?? "";
            final ok = await controller.createBookingAndPayment(token: token);
            if (ok) {
              Get.to(
                () => BookingSuccessScreen(
                  appointment: Appointment(name: "Appointment", date: DateTime.now(), price: controller.total),
                ),
              );
            } else {
              Get.snackbar("Booking failed", controller.lastError.value ?? "Unknown error");
            }
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
          Text(label, style: const TextStyle(color: white)),
          Text(
            "\$${value.toStringAsFixed(2)}",
            style: TextStyle(color: isTotal ? kprimaryColor : white, fontWeight: isTotal ? FontWeight.bold : FontWeight.normal),
          ),
        ],
      ),
    );
  }
}
