// // ignore_for_file: deprecated_member_use, use_key_in_widget_constructors

import 'package:cutcy/constants/constants.dart';
import 'package:cutcy/constants/helper.dart';
import 'package:cutcy/home/appointment/appointment_controller.dart';
import 'package:cutcy/home/bookings/booking_success_screen.dart';
import 'package:cutcy/home/bookings/bookings_controller.dart';
import 'package:cutcy/shared_preferences.dart';
import 'package:cutcy/widgets/AppButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../appointment/appointment_response_model.dart';

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
        child: Obx(
          () => AuthButton(
            text: controller.isPlacing.value ? "Processing..." : "Proceed",
            isLoading: controller.isPlacing.value,
            onTap: controller.isPlacing.value
                ? null
                : () async {
                    // Check if cards exist first
                    final existingPaymentMethods = await controller.checkExistingPaymentMethods();

                    if (existingPaymentMethods != null && existingPaymentMethods.isNotEmpty) {
                      // Has cards - proceed directly with payment (will show existing cards in Stripe sheet)
                      _showPaymentMethodBottomSheet(context, existingPaymentMethods);
                      // final success = await controller.proceedWithPayment(hasExistingCards: true);
                      // if (success) {
                      //   _handlePaymentSuccess();
                      // } else {
                      //   _handlePaymentFailure();
                      // }
                    } else {
                      // No cards - will add card first then proceed with payment
                      final success = await controller.processPaymentWithStripe();
                      if (success) {
                        _handlePaymentSuccess();
                      } else {
                        _handlePaymentFailure();
                      }
                    }
                  },
            // onTap: controller.isPlacing.value
            //     ? null
            //     : () async {
            //         // First check if cards exist
            //         final existingPaymentMethods = await controller.checkExistingPaymentMethods();

            //         if (existingPaymentMethods != null && existingPaymentMethods.isNotEmpty) {
            //           // Show bottom sheet with cards
            //           _showPaymentMethodBottomSheet(context, existingPaymentMethods);
            //         } else {
            //           // No cards - proceed with adding new card
            //           final success = await controller.processPaymentWithStripe();
            //           if (success) {
            //             _handlePaymentSuccess();
            //           } else {
            //             _handlePaymentFailure();
            //           }
            //         }
            //       },
          ),
        ),
      ),
    );
  }

  void _showPaymentMethodBottomSheet(BuildContext context, List<Map<String, dynamic>> paymentMethods) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => PaymentMethodBottomSheet(
        paymentMethods: paymentMethods,
        onPaymentMethodSelected: (paymentMethodId) async {
          Get.back(); // Close bottom sheet
          final success = await controller.proceedWithPayment();
          if (success) {
            _handlePaymentSuccess();
          } else {
            _handlePaymentFailure();
          }
        },
        onAddNewCard: () async {
          Get.back(); // Close bottom sheet
          final success = await controller.processPaymentWithStripe();
          if (success) {
            _handlePaymentSuccess();
          } else {
            _handlePaymentFailure();
          }
        },
      ),
    );
  }

  // void _handlePaymentSuccess() {
  //   showCustomSnackbar(title: "Success!", message: "Your booking has been confirmed and payment processed");
  //   Get.to(
  //     () => BookingSuccessScreen(
  //       appointment: Appointment(name: "Appointment", date: DateTime.now(), price: controller.total),
  //     ),
  //   );
  // }
  void _handlePaymentSuccess() {
    showCustomSnackbar(title: "Success!", message: "Your booking has been confirmed and payment processed");

    // ✅ Fixed: Create a mock Appointment object that matches your model
    final mockAppointment = Appointment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: null,
      barberId: controller.barberId.value,
      day: controller.selectedDay.value,
      startTime: controller.selectedStart.value,
      endTime: controller.selectedEnd.value,
      amount: controller.total,
      locationName: controller.locationName.value,
      locationLat: controller.locationLat.value,
      locationLng: controller.locationLng.value,
      status: "PENDING",
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      totalAmount: controller.total,
      services: [], // You can populate this with actual services if needed
      barber: null, // You can populate this with actual barber if needed
      cancellationReason: null,
    );

    Get.to(() => BookingSuccessScreen(appointment: mockAppointment));
  }

  void _handlePaymentFailure() {
    showCustomSnackbar(title: "Booking failed", message: controller.lastError.value ?? "Unknown error");
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

// Payment Method Bottom Sheet Widget
class PaymentMethodBottomSheet extends StatelessWidget {
  final List<Map<String, dynamic>> paymentMethods;
  final Function(String) onPaymentMethodSelected;
  final VoidCallback onAddNewCard;

  const PaymentMethodBottomSheet({super.key, required this.paymentMethods, required this.onPaymentMethodSelected, required this.onAddNewCard});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      padding: EdgeInsets.all(20.r),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(2.r)),
            ),
          ),
          16.verticalSpace,

          Text(
            "Select Payment Method",
            style: TextStyle(color: white, fontSize: 20.sp, fontWeight: FontWeight.bold),
          ),
          16.verticalSpace,

          // Payment methods list
          ...paymentMethods.map((method) => _buildPaymentMethodTile(method)),

          16.verticalSpace,

          // Add new card option
          _buildAddNewCardTile(),

          16.verticalSpace,
        ],
      ),
    );
  }

  Widget _buildPaymentMethodTile(Map<String, dynamic> method) {
    final brand = method['brand'] ?? 'card';
    final last4 = method['last4'] ?? '****';
    final expMonth = method['expMonth'] ?? 0;
    final expYear = method['expYear'] ?? 0;

    return GestureDetector(
      onTap: () => onPaymentMethodSelected(method['id']),
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: ksecondaryColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: kprimaryColor.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            // Card icon
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(color: kprimaryColor.withOpacity(0.2), borderRadius: BorderRadius.circular(8.r)),
              child: Icon(Icons.credit_card, color: kprimaryColor, size: 24.r),
            ),
            12.horizontalSpace,

            // Card details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${brand.toUpperCase()} •••• $last4",
                    style: TextStyle(color: white, fontSize: 16.sp, fontWeight: FontWeight.w600),
                  ),
                  4.verticalSpace,
                  Text(
                    "Expires ${expMonth.toString().padLeft(2, '0')}/${expYear.toString().substring(2)}",
                    style: TextStyle(color: Colors.grey[400], fontSize: 14.sp),
                  ),
                ],
              ),
            ),

            // Arrow icon
            Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 16.r),
          ],
        ),
      ),
    );
  }

  Widget _buildAddNewCardTile() {
    return GestureDetector(
      onTap: onAddNewCard,
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: ksecondaryColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: kprimaryColor),
        ),
        child: Row(
          children: [
            // Add icon
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(color: kprimaryColor.withOpacity(0.2), borderRadius: BorderRadius.circular(8.r)),
              child: Icon(Icons.add, color: kprimaryColor, size: 24.r),
            ),
            12.horizontalSpace,

            // Text
            Expanded(
              child: Text(
                "Add New Card",
                style: TextStyle(color: white, fontSize: 16.sp, fontWeight: FontWeight.w600),
              ),
            ),

            // Arrow icon
            Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 16.r),
          ],
        ),
      ),
    );
  }
}
