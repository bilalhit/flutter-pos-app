import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class QRDisplayPage extends StatelessWidget {
  final String productCode;
  final String productName;

  const QRDisplayPage({
    Key? key,
    required this.productCode,
    required this.productName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final qrCode = QrCode.fromData(
      data: productCode,
      errorCorrectLevel: QrErrorCorrectLevel.M,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 200,
              height: 200,
              child: PrettyQrView(
                qrImage: QrImage(qrCode),
                decoration: const PrettyQrDecoration(),
              ),
            ),
            const SizedBox(height: 30),
            Text(
              productName,
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w900,
                foreground: Paint()
                  ..shader = const LinearGradient(
                    colors: <Color>[Colors.green, Colors.teal],
                  ).createShader(const Rect.fromLTWH(
                      0.0, 0.0, 200.0, 70.0)), // Gradient text
                shadows: [
                  Shadow(
                    blurRadius: 4.0,
                    color: Colors.black26,
                    offset: Offset(2.0, 2.0),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
