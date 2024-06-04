import 'package:flutter/material.dart';
import 'package:flutter_qr_scanner/QRScanner/qr_code_scanner.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      home: QRCodeScanner(),
    );
  }
}

