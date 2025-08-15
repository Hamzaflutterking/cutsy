// views/search_screen.dart
// ignore_for_file: use_key_in_widget_constructors

import 'package:cutcy/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  final List<String> fakeSuggestions = [
    "134 North Square, Toronto, CA",
    "221B Baker Street, London",
    "1600 Amphitheatre Parkway, Mountain View",
    "1 Apple Park Way, Cupertino",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: const Text('Search Address', style: TextStyle(color: white)),
        iconTheme: const IconThemeData(color: white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              onChanged: (value) => Get.forceAppUpdate(),
              style: const TextStyle(color: white),
              decoration: InputDecoration(
                hintText: "Type your address...",
                hintStyle: const TextStyle(color: Colors.white38),
                filled: true,
                fillColor: Colors.black87,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: fakeSuggestions
                    .where((s) => s.toLowerCase().contains(_controller.text.toLowerCase()))
                    .map(
                      (suggestion) => ListTile(
                        title: Text(suggestion, style: const TextStyle(color: white)),
                        leading: const Icon(Icons.location_on, color: kprimaryColor),
                        onTap: () {
                          Get.back(result: suggestion); // pass the selected address back
                        },
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
