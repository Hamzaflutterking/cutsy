// ignore_for_file: use_super_parameters

import 'package:cutcy/home/profile/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:cutcy/constants/constants.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({Key? key}) : super(key: key);

  final ProfileController ctrl = Get.find<ProfileController>();

  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _nameController.text = ctrl.userName.value;
    _emailController.text = ctrl.email.value;
    _phoneController.text = ctrl.phone.value;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Back button + Title
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Get.back(),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            'Edit Profile',
                            style: TextStyle(color: Colors.white, fontSize: 20.sp, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox(width: 48), // symmetry
                    ],
                  ),
                  SizedBox(height: 12.h),

                  // Avatar + Edit
                  GestureDetector(
                    onTap: () => _showPhotoOptions(context),
                    child: Obx(
                      () => Column(
                        children: [
                          // Rounded-square avatar (80x80, 18.r corner radius)
                          Container(
                            width: 80.r,
                            height: 80.r,
                            decoration: BoxDecoration(
                              color: Colors.grey[700],
                              borderRadius: BorderRadius.circular(18.r), // match your design
                            ),
                            clipBehavior: Clip.hardEdge,
                            child: ctrl.avatarFile.value != null
                                ? Image.file(ctrl.avatarFile.value!, width: 80.r, height: 80.r, fit: BoxFit.cover)
                                : Image.asset(ctrl.avatarPath.value, width: 80.r, height: 80.r, fit: BoxFit.cover),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Edit Photo',
                            style: TextStyle(color: kprimaryColor, fontSize: 13.sp),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // Full Name
                  _fieldLabel('Full Name'), 10.verticalSpace,
                  TextField(
                    controller: _nameController,
                    style: TextStyle(color: Colors.white),
                    decoration: _inputDecoration(),
                  ),
                  SizedBox(height: 18.h),

                  // Email
                  _fieldLabel('Email Address'), 10.verticalSpace,
                  TextField(
                    controller: _emailController,
                    style: TextStyle(color: Colors.white),
                    decoration: _inputDecoration(),
                  ),
                  SizedBox(height: 18.h),

                  // Phone
                  _fieldLabel('Phone Number'), 10.verticalSpace,
                  Obx(
                    () => TextField(
                      controller: _phoneController,
                      style: TextStyle(color: Colors.white),
                      decoration: _inputDecoration(
                        prefixIcon: GestureDetector(
                          onTap: () => ctrl.pickCountry(context),
                          child: Container(
                            color: Colors.transparent,
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(ctrl.countryFlag.value, style: TextStyle(fontSize: 18.sp)),
                                SizedBox(width: 4.w),
                                Text(
                                  ctrl.countryCode.value,
                                  style: TextStyle(color: Colors.white, fontSize: 15.sp),
                                ),
                                Icon(Icons.arrow_drop_down, color: Colors.white70, size: 20.sp),
                                SizedBox(width: 8.w),
                              ],
                            ),
                          ),
                        ),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                  SizedBox(height: 18.h),

                  // Gender Dropdown
                  _fieldLabel('Gender'),
                  10.verticalSpace,
                  Obx(
                    () => Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: ctrl.gender.value,
                          dropdownColor: Colors.grey[900],
                          isExpanded: true,
                          icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                          style: TextStyle(color: Colors.white, fontSize: 15.sp),
                          items: ['Female', 'Male', 'Other'].map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                          onChanged: (value) {
                            if (value != null) ctrl.gender.value = value;
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 80.h),
                ],
              ),
            ),
            // Bottom Save Button
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.grey[900],
                padding: EdgeInsets.fromLTRB(24.w, 15.h, 24.w, 60.h),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      ctrl.userName.value = _nameController.text.trim();
                      ctrl.email.value = _emailController.text.trim();
                      ctrl.phone.value = _phoneController.text.trim();
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kprimaryColor,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                    ),
                    child: Text(
                      'Save',
                      style: TextStyle(color: Colors.black, fontSize: 16.sp),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _fieldLabel(String label) => Align(
    alignment: Alignment.centerLeft,
    child: Text(
      label,
      style: TextStyle(color: Colors.white70, fontSize: 13.sp, fontWeight: FontWeight.w400),
    ),
  );

  InputDecoration _inputDecoration({Widget? prefixIcon}) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.black,
      hintStyle: TextStyle(color: Colors.white38),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide(color: Colors.white12),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide(color: Colors.white12),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide(color: kprimaryColor),
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 14.w),
      prefixIcon: prefixIcon,
    );
  }

  void _showPhotoOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24.r))),
      builder: (_) => SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.photo_library, color: kprimaryColor),
                title: Text('Choose from Library', style: TextStyle(color: Colors.white)),
                onTap: () {
                  ctrl.pickImage(ImageSource.gallery);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt, color: kprimaryColor),
                title: Text('Take Photo', style: TextStyle(color: Colors.white)),
                onTap: () {
                  ctrl.pickImage(ImageSource.camera);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
