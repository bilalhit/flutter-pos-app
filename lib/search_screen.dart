import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Search',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.green),
            onPressed: () {
              // Search action
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              // Search bar section
              TextField(
                decoration: InputDecoration(
                  labelText: 'Search for products...',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.search, color: Colors.green),
                ),
              ),
              const SizedBox(height: 20),

              // Categories section with circular icons
              const Text(
                'Shop by Categories',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              // Horizontal List of Categories (Circular Icons with Text)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: <Widget>[
                    _buildCategoryCard(Icons.local_florist, 'Fruits'),
                    _buildCategoryCard(Icons.cake, 'Bakery'),
                    _buildCategoryCard(Icons.grass, 'Vegetables'),
                    _buildCategoryCard(Icons.shopping_cart, 'Grocery'),
                    _buildCategoryCard(Icons.electrical_services, 'Electronics'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to build circular category card
  Widget _buildCategoryCard(IconData icon, String categoryName) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          // Handle category click, navigate or show products
        },
        child: Column(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.green.shade200,
              child: Icon(icon, color: Colors.white, size: 30),
            ),
            const SizedBox(height: 8),
            Text(categoryName, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
