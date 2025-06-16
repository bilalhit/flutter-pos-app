import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
    runApp(const MyApp());
  } catch (e) {
    runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Text(
            'Firebase Init Error:\n$e',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red, fontSize: 18),
          ),
        ),
      ),
    ));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'POS App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
        ),
      ),
      home: const SplashScreen(), // 👈 keep your original start screen
    );
  }
}
