import 'package:flutter/material.dart';

class QRResultPage extends StatelessWidget {
  final String scannedText;

  const QRResultPage({super.key, required this.scannedText});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("QR Result")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            scannedText,
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
