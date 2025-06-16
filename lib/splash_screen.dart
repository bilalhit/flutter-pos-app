import 'package:flutter/material.dart';
import 'login_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });

    return Scaffold(
      body: SizedBox.expand(
        child: Image.asset(
          "assets/images/sp.jpg",
          fit: BoxFit.cover, // You can also use BoxFit.fill if needed
        ),
      ),
      backgroundColor: Color(0xFF4CAF50), // Optional: won't be visible with full image
    );

  }
}
