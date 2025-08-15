// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 24.w, bottom: 8.h, top: 18.h),
      child: Text(
        title,
        style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.bold),
      ),
    );
  }
}
