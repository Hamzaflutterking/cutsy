import 'package:get/get.dart';
import 'package:flutter/material.dart';

class SupportController extends GetxController {
  final RxList<SupportMessage> messages = <SupportMessage>[].obs;
  final TextEditingController messageController = TextEditingController();

  void sendMessage() {
    String text = messageController.text.trim();
    if (text.isNotEmpty) {
      messages.add(SupportMessage(text: text, isUser: true));
      messageController.clear();
      // Optionally, send to backend here.
    }
  }

  // You can add a method for attachment as needed
}

class SupportMessage {
  final String text;
  final bool isUser;
  SupportMessage({required this.text, required this.isUser});
}
