// ignore_for_file: use_super_parameters, library_private_types_in_public_api, deprecated_member_use

import 'package:cutcy/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatContent extends StatefulWidget {
  final ScrollController controller;
  const ChatContent({required this.controller, Key? key}) : super(key: key);

  @override
  _ChatContentState createState() => _ChatContentState();
}

class _ChatContentState extends State<ChatContent> {
  final TextEditingController _textCtrl = TextEditingController();
  final List<String> _messages = [];

  void _handleSend() {
    final text = _textCtrl.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(text);
    });
    _textCtrl.clear();
    // optionally scroll to bottom:
    widget.controller.animateTo(widget.controller.position.maxScrollExtent + 60, duration: Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 1) drag‐handle
        Container(
          margin: EdgeInsets.symmetric(vertical: 12.h),
          width: 40.w,
          height: 4.h,
          decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2.h)),
        ),

        // 2) title bar
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back, color: white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              Text(
                'Chat',
                style: TextStyle(color: white, fontSize: 18.sp),
              ),
            ],
          ),
        ),

        // 3) messages list
        Expanded(
          child: ListView.builder(
            controller: widget.controller,
            itemCount: _messages.length,
            itemBuilder: (_, i) {
              final msg = _messages[i];
              return Align(
                alignment: Alignment.centerRight, // you can alternate sides
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 4.h, horizontal: 24.w),
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(color: kprimaryColor.withOpacity(0.8), borderRadius: BorderRadius.circular(12.r)),
                  child: Text(msg, style: TextStyle(color: Colors.black)),
                ),
              );
            },
          ),
        ),

        // 4) input box
        Padding(
          padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, MediaQuery.of(context).viewInsets.bottom + 16.h),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _textCtrl,
                  style: TextStyle(color: white),
                  decoration: InputDecoration(
                    hintText: 'Enter your message',
                    hintStyle: TextStyle(color: Colors.white54),
                    filled: true,
                    fillColor: Colors.grey[800],
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide.none),
                    prefixIcon: Icon(Icons.attach_file, color: Colors.white54),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
                  ),
                  onSubmitted: (_) => _handleSend(),
                ),
              ),
              SizedBox(width: 12.w),
              Container(
                width: 48.w,
                height: 48.h,
                decoration: BoxDecoration(color: kprimaryColor, shape: BoxShape.circle),
                child: IconButton(
                  icon: Icon(Icons.send, color: Colors.black),
                  onPressed: _handleSend,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
