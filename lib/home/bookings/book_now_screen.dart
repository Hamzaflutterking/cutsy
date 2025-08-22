import 'package:cutcy/constants/constants.dart';
import 'package:cutcy/home/bookings/checkout_screen.dart';
import 'package:cutcy/home/bookings/dateandtime_screen.dart';
import 'package:cutcy/home/bookings/info_screen.dart';
import 'package:cutcy/home/homes/barber_model.dart';
import 'package:cutcy/home/homes/favs/fav_barber_model.dart' as fav_model;
import 'package:cutcy/home/homes/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'bookings_controller.dart';

class BookNowScreen extends StatelessWidget {
  final bool isFromFav;
  final BarberData? barberData;
  final fav_model.FavBarberData? favBarberData;

  BookNowScreen({super.key, this.barberData, required this.isFromFav, this.favBarberData})
    : assert(
        (!isFromFav && barberData != null) || (isFromFav && favBarberData != null),
        'Provide barberData when isFromFav=false OR favBarberData when isFromFav=true',
      );

  final BookingController ctrl = Get.put(BookingController());

  // ---------- helpers to read from either model ----------
  String? get _id => isFromFav ? favBarberData?.barber?.id : barberData?.id;

  String get _name => (isFromFav ? favBarberData?.barber?.name : barberData?.name) ?? 'Unknown Barber';

  String get _address {
    if (isFromFav) {
      final b = favBarberData?.barber;
      if ((b?.addressName ?? '').isNotEmpty) return b!.addressName!;
      return [b?.addressLine1, b?.city, b?.country].where((e) => (e ?? '').isNotEmpty).join(', ');
    } else {
      final b = barberData;
      if ((b?.addressName ?? '').isNotEmpty) return b!.addressName!;
      return [b?.addressLine1, b?.city, b?.country].where((e) => (e ?? '').isNotEmpty).join(', ');
    }
  }

  String? get _imageUrl => isFromFav ? (favBarberData?.barber?.image as String?) : barberData?.image;

  double get _rating => (barberData?.averageRating ?? 0).toDouble(); // fav payload doesn’t include rating
  int get _reviews => (barberData?.totalReviews ?? 0);

  List<BarberService> get _servicesNormal => barberData?.barberService ?? const <BarberService>[];
  List<fav_model.BarberService> get _servicesFav => favBarberData?.barber?.barberService ?? const <fav_model.BarberService>[];

  List<BarberAvailableHour> get _hoursNormal => barberData?.barberAvailableHour ?? const <BarberAvailableHour>[];
  List<fav_model.BarberAvailableHour> get _hoursFav => favBarberData?.barber?.barberAvailableHour ?? const <fav_model.BarberAvailableHour>[];

  // For DateTimeScreen (expects BarberData), convert fav barber -> BarberData (minimal fields we use)
  BarberData _convertFavToBarberData(fav_model.Barber fb) {
    return BarberData(
      id: fb.id,
      name: fb.name,
      addressName: fb.addressName,
      addressLine1: fb.addressLine1,
      city: fb.city,
      country: fb.country,
      image: (fb.image as String?),
      barberService: (fb.barberService ?? [])
          .map(
            (s) => BarberService(
              id: s.id,
              serviceCategoryId: s.serviceCategoryId,
              price: s.price,
              createdById: s.createdById,
              serviceCategory: s.serviceCategory == null
                  ? null
                  : ServiceCategory(
                      id: s.serviceCategory!.id,
                      service: s.serviceCategory!.service,
                      genderCategory: s.serviceCategory!.genderCategory,
                      createdById: s.serviceCategory!.createdById,
                    ),
            ),
          )
          .toList(),
      barberAvailableHour: (fb.barberAvailableHour ?? [])
          .map((h) => BarberAvailableHour(id: h.id, day: h.day, startTime: h.startTime, endTime: h.endTime, createdById: h.createdById))
          .toList(),
    );
  }

  Widget _timeSlotReactive({required VoidCallback onEdit, required String fallbackDay, required String fallbackStartEnd}) {
    final c = Get.find<BookingController>();
    return Obx(() {
      final d = c.selectedDay.value;
      final s = c.selectedStart.value;
      final e = c.selectedEnd.value;
      final dayText = d ?? fallbackDay;
      final se = (s != null && e != null) ? "$s–$e" : fallbackStartEnd;

      return Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        decoration: BoxDecoration(color: ksecondaryColor, borderRadius: BorderRadius.circular(10)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dayText,
                  style: TextStyle(color: Colors.white70, fontSize: 12.sp),
                ),
                4.verticalSpace,
                Text(
                  se,
                  style: TextStyle(color: white, fontSize: 14.sp, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            GestureDetector(
              onTap: onEdit,
              child: const Icon(Icons.edit, color: Colors.white70),
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // header image
    final ImageProvider cover = (_imageUrl != null && _imageUrl!.isNotEmpty)
        ? NetworkImage(_imageUrl!)
        : const AssetImage("assets/images/young-hispanic-haidresser-and-hairstylist-standing-2024-10-18-17-47-23-utc 1.png");

    // first available slot (just for preview line)
    final String dayText;
    final String startEnd;
    if (isFromFav) {
      final first = _hoursFav.isNotEmpty ? _hoursFav.first : null;
      dayText = first?.day ?? '—';
      startEnd = (first == null) ? 'Select a time' : "${first.startTime ?? ''}–${first.endTime ?? ''}";
    } else {
      final first = _hoursNormal.isNotEmpty ? _hoursNormal.first : null;
      dayText = first?.day ?? '—';
      startEnd = (first == null) ? 'Select a time' : "${first.startTime ?? ''}–${first.endTime ?? ''}";
    }
    final String fallbackDay = isFromFav
        ? (_hoursFav.isNotEmpty ? (_hoursFav.first.day ?? "—") : "—")
        : (_hoursNormal.isNotEmpty ? (_hoursNormal.first.day ?? "—") : "—");

    final String fallbackStartEnd = isFromFav
        ? (_hoursFav.isNotEmpty ? "${_hoursFav.first.startTime ?? ''}–${_hoursFav.first.endTime ?? ''}" : "Select a time")
        : (_hoursNormal.isNotEmpty ? "${_hoursNormal.first.startTime ?? ''}–${_hoursNormal.first.endTime ?? ''}" : "Select a time");
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          // Header background image
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: _CurvedClipper(),
              child: Container(
                height: 350.h,
                decoration: BoxDecoration(
                  image: DecorationImage(image: cover, fit: BoxFit.cover),
                ),
              ),
            ),
          ),

          // Foreground content
          SafeArea(
            child: Column(
              children: [
                10.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _iconButton(Icons.arrow_back, () => Get.back()),
                    SizedBox(
                      height: 40.h,
                      width: 40.w,
                      child: FavoriteButton(barberId: _id),
                    ),
                  ],
                ),
                170.verticalSpace,

                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [BoxShadow(color: Colors.white.withValues(alpha: 0.15), blurRadius: 8, offset: const Offset(0, -2))],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          10.verticalSpace,

                          // top row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _licensedTag(),
                              IconButton(
                                onPressed: () => showProviderInfoBottomSheet(context),
                                icon: Icon(Icons.info_outline, color: white, size: 20.sp),
                              ),
                            ],
                          ),
                          6.verticalSpace,

                          // name
                          Text(
                            _name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: white, fontWeight: FontWeight.bold, fontSize: 18.sp),
                          ),
                          2.verticalSpace,

                          // address
                          Text(
                            _address,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.white60, fontSize: 13.sp),
                          ),
                          8.verticalSpace,

                          // rating (fav has none → 0.0 and 0 reviews)
                          Row(
                            children: [
                              Icon(Icons.star, color: kprimaryColor, size: 18.sp),
                              4.horizontalSpace,
                              Text(
                                _rating.toStringAsFixed(1),
                                style: TextStyle(color: white, fontSize: 13.sp, fontWeight: FontWeight.w500),
                              ),
                              6.horizontalSpace,
                              Text(
                                "· $_reviews reviews",
                                style: TextStyle(color: Colors.white54, fontSize: 13.sp),
                              ),
                            ],
                          ),
                          16.verticalSpace,

                          // time slot preview
                          // _timeSlot(
                          //   dayText: dayText,
                          //   startEnd: startEnd,
                          //   onEdit: () {
                          //     if (isFromFav) {
                          //       final fb = favBarberData!.barber!;
                          //       Get.to(() => DateTimeScreen(barber: _convertFavToBarberData(fb)));
                          //     } else {
                          //       Get.to(() => DateTimeScreen(barber: barberData!));
                          //     }
                          //   },
                          // ),
                          _timeSlotReactive(
                            onEdit: () {
                              ctrl.setBarberContext(
                                id: _id ?? '',
                                locName: _address,
                                lat: isFromFav ? favBarberData?.barber?.latitude : barberData?.latitude,
                                lng: isFromFav ? favBarberData?.barber?.longitude : barberData?.longitude,
                              );
                              Get.to(() => DateTimeScreen(barber: isFromFav ? _convertFavToBarberData(favBarberData!.barber!) : barberData!));
                            },
                            fallbackDay: fallbackDay,
                            fallbackStartEnd: fallbackStartEnd,
                          ),
                          18.verticalSpace,

                          // services (real data)
                          if (!isFromFav && _servicesNormal.isEmpty)
                            Container(
                              padding: EdgeInsets.all(12.r),
                              decoration: BoxDecoration(color: ksecondaryColor, borderRadius: BorderRadius.circular(10.r)),
                              child: const Text("No services listed", style: TextStyle(color: Colors.white70)),
                            )
                          else if (isFromFav && _servicesFav.isEmpty)
                            Container(
                              padding: EdgeInsets.all(12.r),
                              decoration: BoxDecoration(color: ksecondaryColor, borderRadius: BorderRadius.circular(10.r)),
                              child: const Text("No services listed", style: TextStyle(color: Colors.white70)),
                            )
                          else
                            ...(isFromFav ? _servicesFav.map(_serviceTileFav) : _servicesNormal.map(_serviceTileNormal)),

                          24.verticalSpace,
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      // CTA
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 65.h),
        child: SizedBox(
          height: 50.h,
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: kprimaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => Get.to(() => CheckoutScreen()),
            child: Text(
              "Book Now",
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16.sp),
            ),
          ),
        ),
      ),
    );
  }

  // ---- UI helpers ----

  Widget _iconButton(IconData icon, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CircleAvatar(
        backgroundColor: ksecondaryColor,
        child: IconButton(
          icon: Icon(icon, color: white),
          onPressed: onTap,
        ),
      ),
    );
  }

  Widget _licensedTag() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(color: kprimaryColor, borderRadius: BorderRadius.circular(4)),
      child: Text(
        "Licensed",
        style: TextStyle(color: Colors.black, fontSize: 12.sp, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _timeSlot({required String dayText, required String startEnd, required VoidCallback onEdit}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      decoration: BoxDecoration(color: ksecondaryColor, borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                dayText,
                style: TextStyle(color: Colors.white70, fontSize: 12.sp),
              ),
              4.verticalSpace,
              Text(
                startEnd,
                style: TextStyle(color: white, fontSize: 14.sp, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          GestureDetector(
            onTap: onEdit,
            child: const Icon(Icons.edit, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  // --- service tiles for both payloads ---

  Widget _serviceTileNormal(BarberService svc) {
    final key = svc.id ?? svc.serviceCategory?.service ?? "svc";
    final title = svc.serviceCategory?.service ?? "Service";
    final price = svc.price ?? "-";
    return Obx(() {
      final selected = ctrl.isSelected(key);
      return Container(
        margin: EdgeInsets.symmetric(vertical: 6.h),
        decoration: BoxDecoration(color: ksecondaryColor, borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          leading: const Icon(Icons.cut, color: kprimaryColor),
          title: Text(title, style: const TextStyle(color: white)),
          subtitle: Text(
            "\$$price",
            style: TextStyle(color: Colors.white54, fontSize: 12.sp),
          ),
          trailing: Switch(
            value: selected,
            // onChanged: (_) => ctrl.toggleService(key),
            onChanged: (_) => ctrl.toggleServiceById(
              svc.id ?? title, // fallback if id is null
              title: title,
              price: double.tryParse(price) ?? 0.0,
            ),
            activeColor: white,
            activeTrackColor: kprimaryColor,
            inactiveThumbColor: white,
            inactiveTrackColor: grey.withOpacity(0.5),
          ),
        ),
      );
    });
  }

  Widget _serviceTileFav(fav_model.BarberService svc) {
    final key = svc.id ?? svc.serviceCategory?.service ?? "svc";
    final title = svc.serviceCategory?.service ?? "Service";
    final price = svc.price ?? "-";
    return Obx(() {
      final selected = ctrl.isSelected(key);
      return Container(
        margin: EdgeInsets.symmetric(vertical: 6.h),
        decoration: BoxDecoration(color: ksecondaryColor, borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          leading: const Icon(Icons.cut, color: kprimaryColor),
          title: Text(title, style: const TextStyle(color: white)),
          subtitle: Text(
            "\$$price",
            style: TextStyle(color: Colors.white54, fontSize: 12.sp),
          ),
          trailing: Switch(
            value: selected,
            // onChanged: (_) => ctrl.toggleService(key),
            onChanged: (_) => ctrl.toggleServiceById(
              svc.id!, // <- API id
              title: svc.serviceCategory?.service ?? "Service",
              price: double.tryParse(svc.price ?? "0") ?? 0.0,
            ),
            activeColor: white,
            activeTrackColor: kprimaryColor,
            inactiveThumbColor: white,
            inactiveTrackColor: grey.withValues(alpha: 0.5),
          ),
        ),
      );
    });
  }
}

class _CurvedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 80);
    path.quadraticBezierTo(size.width / 2, size.height, size.width, size.height - 80);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

// FavoriteButton unchanged
class FavoriteButton extends StatelessWidget {
  final String? barberId;
  const FavoriteButton({super.key, required this.barberId});

  @override
  Widget build(BuildContext context) {
    final homeC = Get.find<HomeController>();
    return Obx(() {
      final busy = barberId != null && homeC.favBusy.contains(barberId!);
      final fav = homeC.isFavorite(barberId);
      return IconButton(
        splashRadius: 22,
        onPressed: (barberId == null || busy) ? null : () => homeC.addFavoriteBarber(barberId!),
        icon: busy
            ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2))
            : Icon(fav ? Icons.favorite : Icons.favorite_border, color: fav ? Colors.redAccent : Colors.white70),
      );
    });
  }
}
