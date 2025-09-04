import 'package:cutcy/constants/constants.dart';
import 'package:cutcy/home/bookings/date_and_time_controller.dart';
import 'package:cutcy/home/homes/barber_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class DateTimeScreen extends StatelessWidget {
  final BarberData barber;
  DateTimeScreen({super.key, required this.barber});

  late final DateTimeController ctrl = Get.put(DateTimeController(barber: barber));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,
        title: const Text("Select Date & Time", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            12.verticalSpace,
            _buildHeader(),
            12.verticalSpace,
            _buildDateSelector(),
            10.verticalSpace,
            _buildWarning(),
            10.verticalSpace,
            Expanded(child: _buildTimeSlots()),
            _buildButton(),
            12.verticalSpace,
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(Icons.arrow_back_ios, color: Colors.white),
          Obx(() {
            final date = ctrl.availableDates[ctrl.selectedDateIndex.value];
            final monthLabel = DateFormat('MMMM yyyy').format(date).toUpperCase();
            return Text(
              monthLabel,
              style: TextStyle(color: Colors.white, fontSize: 16.sp),
            );
          }),
          const Icon(Icons.arrow_forward_ios, color: Colors.white),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    return SizedBox(
      height: 60.h,
      child: Obx(() {
        // 👇 Read reactive values here so Obx tracks them
        final selectedIdx = ctrl.selectedDateIndex.value;
        final dates = ctrl.availableDates; // plain list is fine

        return ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          itemCount: dates.length,
          itemBuilder: (_, index) {
            final date = dates[index];
            final isSelected = selectedIdx == index;

            return GestureDetector(
              onTap: () => ctrl.selectedDateIndex.value = index,
              child: Container(
                width: 60.w,
                margin: EdgeInsets.symmetric(horizontal: 6.w),
                decoration: BoxDecoration(color: isSelected ? Colors.yellow : Colors.grey[900], borderRadius: BorderRadius.circular(12.r)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat('dd').format(date),
                      style: TextStyle(color: isSelected ? Colors.black : Colors.white, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      DateFormat('E').format(date),
                      style: TextStyle(color: isSelected ? Colors.black : Colors.white70, fontSize: 12.sp),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildWarning() => Padding(
    padding: EdgeInsets.symmetric(horizontal: 12.w),
    child: Row(
      children: [
        Icon(Icons.info_outline, color: Colors.yellow, size: 16.sp),
        6.horizontalSpace,
        const Expanded(
          child: Text("Based on your selected services, please book 02 hours.", style: TextStyle(color: Colors.yellow, fontSize: 12)),
        ),
      ],
    ),
  );

  Widget _buildTimeSlots() {
    return Obx(() {
      final slots = ctrl.timeSlots;
      if (slots.isEmpty) {
        return Center(
          child: Text(
            "No slots available for this date",
            style: TextStyle(color: Colors.white70, fontSize: 14.sp),
          ),
        );
      }
      return GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 3.5,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        children: slots.map((slot) {
          final isSelected = ctrl.selectedSlot.value == slot;
          return GestureDetector(
            onTap: () => ctrl.selectSlot(slot),
            child: Container(
              decoration: BoxDecoration(color: isSelected ? Colors.yellow : Colors.grey[900], borderRadius: BorderRadius.circular(12.r)),
              alignment: Alignment.center,
              child: Text(
                slot,
                style: TextStyle(color: isSelected ? Colors.black : Colors.white, fontWeight: FontWeight.w600, fontSize: 12.sp),
              ),
            ),
          );
        }).toList(),
      );
    });
  }

  Widget _buildButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: SizedBox(
        width: double.infinity,
        height: 48.h,
        child: ElevatedButton(
          onPressed: ctrl.saveToBookingAndClose,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.yellow,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
          ),
          child: const Text(
            "Save and Continue",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
