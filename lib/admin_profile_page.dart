import 'package:flutter/material.dart';
import 'admin_login_screen.dart';

class AdminProfilePage extends StatefulWidget {
  const AdminProfilePage({super.key});

  @override
  State<AdminProfilePage> createState() => _AdminProfilePageState();
}

class _AdminProfilePageState extends State<AdminProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Profile'),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                  radius: 60,
                backgroundColor: Colors.grey.shade300,
                backgroundImage:const AssetImage("assets/images/profile.jpg") as ImageProvider,
               //child: const Icon(Icons.person, size: 60, color: Colors.green),
              ),
              const SizedBox(height: 20),
              const Text('Muhammad Bilal',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('PosAdmin@gmail.com',
                  style: TextStyle(color: Colors.grey,fontSize: 18)),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: () {
                  ///
                  Future.delayed(const Duration(seconds: 0), () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const AdminLoginScreen())
                    );
                  });
                  ///
                },
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
