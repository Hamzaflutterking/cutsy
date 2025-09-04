// ignore_for_file: use_super_parameters, depend_on_referenced_packages, deprecated_member_use

import 'package:cutcy/constants/constants.dart';
import 'package:cutcy/home/appointment/appointment_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AppointmentScreen extends StatelessWidget {
  AppointmentScreen({Key? key}) : super(key: key);
  final AppointmentController ctrl = Get.put(AppointmentController());

  String _formatDate(DateTime dt) {
    return DateFormat('EEEE, MMMM d, yyyy').format(dt);
  }

  String _formatDateFromApi(String? dateString) {
    if (dateString == null) return 'No date available';
    try {
      final dt = DateTime.parse(dateString);
      return DateFormat('EEEE, MMMM d, yyyy').format(dt);
    } catch (e) {
      return dateString; // Return original string if parsing fails
    }
  }

  Widget _buildTab(String title, int idx) {
    return Expanded(
      child: GestureDetector(
        onTap: () => ctrl.changeTab(idx),
        child: Obx(() {
          final selected = ctrl.selectedTab.value == idx;
          return Container(
            height: 40.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected ? kprimaryColor : Colors.transparent,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.transparent),
            ),
            child: Text(
              title,
              style: TextStyle(color: selected ? black : white, fontSize: 14.sp, fontWeight: FontWeight.w500),
            ),
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Appointments',
                  style: TextStyle(color: white, fontSize: 20.sp, fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(height: 16.h),

              /// Tab bar
              Container(
                padding: EdgeInsets.all(4.r),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: white),
                ),
                child: Row(
                  children: [
                    _buildTab('Upcoming', 0),
                    SizedBox(width: 4.w),
                    _buildTab('Ongoing', 1),
                    SizedBox(width: 4.w),
                    _buildTab('Past', 2),
                  ],
                ),
              ),

              SizedBox(height: 16.h),

              /// Appointment list
              Expanded(
                child: Obx(() {
                  // Show loading indicator
                  if (ctrl.isLoading.value) {
                    return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(kprimaryColor)));
                  }

                  // Show error message
                  if (ctrl.lastError.value != null) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline, color: Colors.red, size: 48.sp),
                          SizedBox(height: 16.h),
                          Text(
                            ctrl.lastError.value!,
                            style: TextStyle(color: Colors.red, fontSize: 14.sp),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 16.h),
                          ElevatedButton(
                            onPressed: () => ctrl.refreshAppointments(),
                            style: ElevatedButton.styleFrom(backgroundColor: kprimaryColor),
                            child: Text('Retry', style: TextStyle(color: black)),
                          ),
                        ],
                      ),
                    );
                  }

                  final tab = ctrl.selectedTab.value;
                  final list = tab == 1
                      ? ctrl.ongoing
                      : tab == 2
                      ? ctrl.past
                      : ctrl.upcoming;

                  // Show empty state
                  if (list.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.calendar_today, color: Colors.grey, size: 48.sp),
                          SizedBox(height: 16.h),
                          Text(
                            _getEmptyMessage(tab),
                            style: TextStyle(color: Colors.grey, fontSize: 16.sp),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () => ctrl.refreshAppointments(),
                    color: kprimaryColor,
                    child: ListView.separated(
                      physics: AlwaysScrollableScrollPhysics(),
                      itemCount: list.length,
                      separatorBuilder: (_, __) => Divider(color: Colors.white24),
                      itemBuilder: (_, i) {
                        final appt = list[i];
                        return InkWell(
                          onTap: () => ctrl.selectAppointment(appt),
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            child: Row(
                              children: [
                                // Details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        appt.barber?.name ?? 'Unknown Barber',
                                        style: TextStyle(color: white, fontSize: 16.sp, fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        '${appt.day ?? ''} ${appt.startTime ?? ''} - ${appt.endTime ?? ''}',
                                        style: TextStyle(color: Colors.white70, fontSize: 14.sp),
                                      ),
                                      if (appt.createdAt != null)
                                        Text(
                                          _formatDate(appt.createdAt!),
                                          style: TextStyle(color: Colors.white70, fontSize: 12.sp),
                                        ),
                                      // Status badge
                                      Container(
                                        margin: EdgeInsets.only(top: 4.h),
                                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                                        decoration: BoxDecoration(color: _getStatusColor(appt.status), borderRadius: BorderRadius.circular(12.r)),
                                        child: Text(
                                          appt.status ?? 'Unknown',
                                          style: TextStyle(color: white, fontSize: 10.sp),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Price
                                Text(
                                  '\$${(appt.amount ?? 0).toStringAsFixed(2)}',
                                  style: TextStyle(color: kprimaryColor, fontSize: 16.sp, fontWeight: FontWeight.w500),
                                ),

                                SizedBox(width: 8.w),
                                Icon(Icons.arrow_forward_ios, size: 16.sp, color: Colors.white70),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getEmptyMessage(int tab) {
    switch (tab) {
      case 0:
        return 'No upcoming appointments';
      case 1:
        return 'No ongoing appointments';
      case 2:
        return 'No past appointments';
      default:
        return 'No appointments found';
    }
  }

  Color _getStatusColor(String? status) {
    switch (status?.toUpperCase()) {
      case 'PENDING':
        return Colors.orange;
      case 'CONFIRMED':
        return Colors.blue;
      case 'ONGOING':
        return Colors.green;
      case 'COMPLETED':
        return Colors.green;
      case 'CANCELLED':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
