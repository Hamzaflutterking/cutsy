// ignore_for_file: use_super_parameters

import 'package:cutcy/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'support_controller.dart'; // Path as per your project

class SupportScreen extends StatelessWidget {
  SupportScreen({Key? key}) : super(key: key);
  final SupportController chatCtrl = Get.put(SupportController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: white),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: const Text('Support', style: TextStyle(color: white)),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (chatCtrl.messages.isEmpty) {
                return const Center(
                  child: Text("No messages yet", style: TextStyle(color: Colors.white54, fontSize: 16)),
                );
              }
              // For future: Display message list (user/bot style)
              return ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                itemCount: chatCtrl.messages.length,
                itemBuilder: (context, index) {
                  final msg = chatCtrl.messages[index];
                  return Align(
                    alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(color: msg.isUser ? kprimaryColor : Colors.white10, borderRadius: BorderRadius.circular(16)),
                      child: Text(msg.text, style: TextStyle(color: msg.isUser ? black : white)),
                    ),
                  );
                },
              );
            }),
          ),
          Container(
            height: 150,
            color: const Color(0xFF1A1A1A),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            child: Row(
              children: [
                Icon(Icons.attach_file, color: white, size: 22),
                const SizedBox(width: 6),
                Expanded(
                  child: TextField(
                    controller: chatCtrl.messageController,
                    style: const TextStyle(color: white),
                    decoration: InputDecoration(
                      hintText: 'Enter your message',
                      hintStyle: TextStyle(color: Colors.white60),
                      filled: true,
                      fillColor: const Color(0xFF232323),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                    ),
                    onSubmitted: (_) => chatCtrl.sendMessage(),
                  ),
                ),
                const SizedBox(width: 6),
                SizedBox(
                  height: 44,
                  width: 44,
                  child: ElevatedButton(
                    onPressed: chatCtrl.sendMessage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kprimaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: EdgeInsets.zero,
                      elevation: 0,
                    ),
                    child: const Icon(Icons.arrow_forward, color: black),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
