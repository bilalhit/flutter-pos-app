import 'package:flutter/material.dart';

class QRScannerScreen extends StatelessWidget {
  const QRScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('QR Scanner'),
      ),
      body: Center(
        child: Text(
          'QR Scanner will be here',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
