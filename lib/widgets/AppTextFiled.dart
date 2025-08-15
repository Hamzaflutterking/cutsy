// ignore_for_file: use_super_parameters, file_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool enableVisibilityToggle;
  final Widget? suffix; // Optional suffix
  final Function(String)? onChanged; // Optional onChanged

  const AuthTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.keyboardType,
    this.obscureText = false,
    this.enableVisibilityToggle = false,
    this.suffix,
    this.onChanged, // Optional parameter
  }) : super(key: key);

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  late bool _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.keyboardType ?? TextInputType.text,
      obscureText: _obscure,
      style: TextStyle(color: Colors.white, fontSize: 16.sp),
      cursorColor: Colors.white,
      onChanged: widget.onChanged, // Use the onChanged callback if provided, else it's null
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14.sp),
        filled: false,
        border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade700)),
        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade700)),
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade500)),
        contentPadding: EdgeInsets.symmetric(vertical: 12.h),
        suffixIcon: widget.enableVisibilityToggle
            ? IconButton(
                icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility, color: Colors.grey.shade500),
                onPressed: () {
                  setState(() {
                    _obscure = !_obscure;
                  });
                },
              )
            : widget.suffix, // If provided, use it; otherwise, keep it empty.
      ),
    );
  }
}
