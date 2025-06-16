import 'package:flutter/material.dart';
import 'admin_login_screen.dart';
import 'add_product_page.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.green),
              child: const Text(
                'Admin Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context); // Close drawer
              },
            ),
            ListTile(
              leading: const Icon(Icons.inventory),
              title: const Text('Products'),
              onTap: () {
                // Navigate to products page (you can add later)
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_bag),
              title: const Text('Orders'),
              onTap: () {
                // Navigate to orders page (you can add later)
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AdminLoginScreen()),
              );
                },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Welcome, Admin 👋',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),

            // Dashboard Cards
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildDashboardCard('Sales Today', 'Rs. 0.00', Icons.analytics),
                _buildDashboardCard('Orders', '0', Icons.shopping_bag),
                _buildDashboardCard('Products', '0', Icons.inventory),
                _buildDashboardCard('Customers', '0', Icons.group),
              ],
            ),

            const SizedBox(height: 30),

            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddProductPage()),
              );
              },
              icon: const Icon(Icons.add),
              label: const Text('Add New Product'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard(String title, String value, IconData icon) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: Colors.green),
            const SizedBox(height: 12),
            Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(title, style: const TextStyle(fontSize: 16, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
