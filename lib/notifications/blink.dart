// ignore_for_file: use_key_in_widget_constructors

import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(const BlinkApp());

class BlinkApp extends StatelessWidget {
  const BlinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: BlinkScreen(), debugShowCheckedModeBanner: false);
  }
}

class BlinkScreen extends StatefulWidget {
  @override
  State<BlinkScreen> createState() => _BlinkScreenState();
}

class _BlinkScreenState extends State<BlinkScreen> {
  bool _isBlack = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 400), (timer) {
      setState(() {
        _isBlack = !_isBlack;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: _isBlack ? Colors.black : Colors.white, body: const SizedBox.expand());
  }
}
