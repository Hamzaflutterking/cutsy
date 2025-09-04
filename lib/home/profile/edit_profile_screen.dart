import 'package:cutcy/home/profile/profile_controller.dart';
import 'package:cutcy/widgets/AppButton.dart';
import 'package:cutcy/widgets/backend_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:cutcy/constants/constants.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProfileController ctrl = Get.find<ProfileController>();

    // ✅ Create controllers as local variables
    final TextEditingController firstNameController = TextEditingController(text: ctrl.firstName.value);
    final TextEditingController lastNameController = TextEditingController(text: ctrl.lastName.value);
    final TextEditingController emailController = TextEditingController(text: ctrl.emailLocal.value);
    final TextEditingController phoneController = TextEditingController(text: ctrl.phoneLocal.value);

    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Obx(() {
          if (ctrl.isLoading.value) {
            return const Center(child: CircularProgressIndicator(color: kprimaryColor));
          }

          return Form(
            key: formKey,
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              children: [
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
                  onTap: () => _showPhotoOptions(context, ctrl),
                  child: Obx(
                    () => Column(
                      children: [
                        // Profile image
                        Container(
                          width: 80.r,
                          height: 80.r,
                          decoration: BoxDecoration(color: Colors.grey[700], borderRadius: BorderRadius.circular(18.r)),
                          clipBehavior: Clip.hardEdge,
                          child: ctrl.avatarFile.value != null
                              ? Image.file(ctrl.avatarFile.value!, width: 80.r, height: 80.r, fit: BoxFit.cover)
                              : ctrl.userImageLocal.value.isNotEmpty
                              ? BackendImage(url: ctrl.userImageLocal.value, width: 80.r, height: 80.r, fit: BoxFit.cover)
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

                // ✅ First Name
                _fieldLabel('First Name'),
                10.verticalSpace,
                TextFormField(
                  controller: firstNameController,
                  style: TextStyle(color: Colors.white),
                  decoration: _inputDecoration(hintText: 'Enter your first name'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'First name is required';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 18.h),

                // ✅ Last Name
                _fieldLabel('Last Name'),
                10.verticalSpace,
                TextFormField(
                  controller: lastNameController,
                  style: TextStyle(color: Colors.white),
                  decoration: _inputDecoration(hintText: 'Enter your last name'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Last name is required';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 18.h),

                // Email
                _fieldLabel('Email Address'),
                10.verticalSpace,
                TextFormField(
                  enabled: false,
                  controller: emailController,
                  style: TextStyle(color: Colors.white),
                  decoration: _inputDecoration(hintText: 'Enter your email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Email is required';
                    }
                    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
                    if (!emailRegex.hasMatch(value.trim())) {
                      return 'Enter a valid email address';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 18.h),

                // Phone
                _fieldLabel('Phone Number'),
                10.verticalSpace,
                Obx(
                  () => TextFormField(
                    controller: phoneController,
                    style: TextStyle(color: Colors.white),
                    decoration: _inputDecoration(
                      hintText: 'Enter your phone number',
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
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Phone number is required';
                      }
                      return null;
                    },
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
                        value: _normalizeGenderValue(ctrl.genderLocal.value),
                        dropdownColor: Colors.grey[900],
                        isExpanded: true,
                        icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                        style: TextStyle(color: Colors.white, fontSize: 15.sp),
                        items: ['Male', 'Female', 'Other'].map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            ctrl.genderLocal.value = value;
                          }
                        },
                      ),
                    ),
                  ),
                ),
                20.verticalSpace,
                // Bottom Save Button
                Obx(
                  () => ElevatedButton(
                    onPressed: ctrl.isUpdating.value
                        ? null
                        : () => _saveProfile(formKey, ctrl, firstNameController, lastNameController, emailController, phoneController),
                    style: ElevatedButton.styleFrom(
                      maximumSize: Size(1.sw, 60.h),
                      minimumSize: Size(1.sw, 60.h),
                      backgroundColor: kprimaryColor,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                    ),
                    child: ctrl.isUpdating.value
                        ? SizedBox(
                            height: 20.h,
                            width: 20.w,
                            child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2),
                          )
                        : Text(
                            'Save Changes',
                            style: TextStyle(color: Colors.black, fontSize: 16.sp, fontWeight: FontWeight.w600),
                          ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  // ✅ Helper methods moved to static functions
  static Widget _fieldLabel(String label) => Align(
    alignment: Alignment.centerLeft,
    child: Text(
      label,
      style: TextStyle(color: Colors.white70, fontSize: 13.sp, fontWeight: FontWeight.w400),
    ),
  );

  static InputDecoration _inputDecoration({Widget? prefixIcon, String? hintText}) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.black,
      hintText: hintText,
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
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide(color: Colors.red),
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 14.w),
      prefixIcon: prefixIcon,
    );
  }

  // ✅ Static method for photo options
  static void _showPhotoOptions(BuildContext context, ProfileController ctrl) {
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
              Container(
                width: 40.w,
                height: 4.h,
                margin: EdgeInsets.only(bottom: 20.h),
                decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2.r)),
              ),
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
              if (ctrl.avatarFile.value != null || ctrl.userImageLocal.value.isNotEmpty)
                ListTile(
                  leading: Icon(Icons.delete, color: Colors.red),
                  title: Text('Remove Photo', style: TextStyle(color: Colors.white)),
                  onTap: () {
                    ctrl.avatarFile.value = null;
                    ctrl.userImageLocal.value = '';
                    Navigator.pop(context);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ Static method for saving profile
  static void _saveProfile(
    GlobalKey<FormState> formKey,
    ProfileController ctrl,
    TextEditingController firstNameController,
    TextEditingController lastNameController,
    TextEditingController emailController,
    TextEditingController phoneController,
  ) {
    if (formKey.currentState?.validate() ?? false) {
      // Combine country code with phone number if not already combined
      String fullPhone = phoneController.text.trim();
      if (!fullPhone.startsWith(ctrl.countryCode.value)) {
        fullPhone = '${ctrl.countryCode.value}$fullPhone';
      }

      ctrl.updateProfile(
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        email: emailController.text.trim(),
        phone: fullPhone,
        gender: ctrl.genderLocal.value,
      );
    }
  }

  // ✅ Helper method to normalize gender values
  static String _normalizeGenderValue(String gender) {
    switch (gender.toUpperCase()) {
      case 'MALE':
        return 'Male';
      case 'FEMALE':
        return 'Female';
      case 'OTHER':
        return 'Other';
      default:
        return 'Male'; // Default fallback
    }
  }
}
