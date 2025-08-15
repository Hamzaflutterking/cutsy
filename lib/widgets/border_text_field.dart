// // widgets/border_text_field.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class BorderTextField extends StatelessWidget {
//   final String? label;
//   final String? hint;
//   final TextEditingController? controller;
//   final TextInputType? keyboardType;
//   final bool obscureText;
//   final int? maxLines;
//   final Widget? suffixIcon;

//   const BorderTextField({
//     super.key,
//     this.label,
//     this.hint,
//     this.controller,
//     this.keyboardType,
//     this.obscureText = false,
//     this.maxLines = 1,
//     this.suffixIcon,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         if (label != null) ...[
//           Text(
//             label!,
//             style: TextStyle(color: Colors.white, fontSize: 13.sp, fontWeight: FontWeight.w500),
//           ),
//           const SizedBox(height: 6),
//         ],
//         Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(12.r),
//             border: Border.all(color: Colors.grey.shade700, width: 1),
//           ),
//           child: TextFormField(
//             controller: controller,
//             keyboardType: keyboardType,
//             obscureText: obscureText,
//             maxLines: maxLines,
//             style: TextStyle(color: Colors.white, fontSize: 15.sp),
//             decoration: InputDecoration(
//               contentPadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
//               hintText: hint,
//               hintStyle: TextStyle(color: Colors.grey.shade500),
//               border: InputBorder.none,
//               suffixIcon: suffixIcon,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// ignore_for_file: no_leading_underscores_for_local_identifiers, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BorderTextField extends StatefulWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final int? maxLines;
  final Widget? suffixIcon;
  final bool enableVisibilityToggle;
  final Function(String)? onChanged;

  const BorderTextField({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.maxLines = 1,
    this.suffixIcon,
    this.enableVisibilityToggle = false,
    this.onChanged, // Optional parameter for onChanged
  });

  @override
  _BorderTextFieldState createState() => _BorderTextFieldState();
}

class _BorderTextFieldState extends State<BorderTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: TextStyle(color: Colors.white, fontSize: 13.sp, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 6),
        ],
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.grey.shade700, width: 1),
          ),
          child: TextFormField(
            controller: widget.controller,
            keyboardType: widget.keyboardType ?? TextInputType.text,
            obscureText: _obscureText,
            maxLines: widget.maxLines,
            style: TextStyle(color: Colors.white, fontSize: 15.sp),
            onChanged: widget.onChanged, // Ensure this is used for updating values
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
              hintText: widget.hint,
              hintStyle: TextStyle(color: Colors.grey.shade500),
              border: InputBorder.none,
              suffixIcon: widget.enableVisibilityToggle
                  ? IconButton(
                      icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility, color: Colors.grey.shade500),
                      onPressed: _togglePasswordVisibility, // Toggle the visibility
                    )
                  : widget.suffixIcon, // Use the custom suffixIcon if available
            ),
          ),
        ),
      ],
    );
  }
}
