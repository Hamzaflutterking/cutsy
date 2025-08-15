// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, prefer_final_fields

import 'package:cutcy/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SupportChatScreen extends StatefulWidget {
  @override
  _SupportChatScreenState createState() => _SupportChatScreenState();
}

class _SupportChatScreenState extends State<SupportChatScreen> {
  TextEditingController _messageController = TextEditingController();

  // Sample chat data
  var chatMessages = [
    {'sender': 'user', 'message': 'Hello, I need help with my appointment.'},
    {'sender': 'support', 'message': 'Sure! How can I assist you?'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text('Support', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          // Chat messages list
          Expanded(
            child: ListView.builder(
              itemCount: chatMessages.length,
              itemBuilder: (context, index) {
                var message = chatMessages[index];
                bool isUserMessage = message['sender'] == 'user';
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
                  child: Align(
                    alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(color: isUserMessage ? kprimaryColor : Colors.grey[800], borderRadius: BorderRadius.circular(8.r)),
                      child: Text(
                        message['message']!,
                        style: TextStyle(color: isUserMessage ? backgroundColor : Colors.white, fontSize: 14.sp),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Message input field
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 50.h),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    style: TextStyle(color: Colors.white, fontSize: 14.sp),
                    decoration: InputDecoration(
                      focusColor: kprimaryColor,
                      hoverColor: kprimaryColor,
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(color: kprimaryColor, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(color: kprimaryColor, width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(color: kprimaryColor, width: 1.0),
                      ),
                      hintText: 'Enter your message',
                      hintStyle: TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.grey[800],
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                IconButton(
                  icon: Icon(Icons.send, color: kprimaryColor, size: 24.sp),
                  onPressed: () {
                    if (_messageController.text.isNotEmpty) {
                      setState(() {
                        chatMessages.add({'sender': 'user', 'message': _messageController.text});
                        _messageController.clear();
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
