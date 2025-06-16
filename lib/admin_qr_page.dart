import 'package:flutter/material.dart';

class AdminQRPage extends StatelessWidget {
  const AdminQRPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("QR Scanner"),
        backgroundColor: Colors.green,
      ),
      body: const Center(
        child: Text(
          'QR Scanner Screen (Functionality coming soon)',
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
