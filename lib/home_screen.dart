import 'dart:async';
import 'package:flutter/material.dart';
import 'profile_screen.dart';
import 'search_screen.dart';
import 'cart_screen.dart';
import 'qr_scanner_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  int _currentPromoIndex = 0;
  final PageController _pageController = PageController();
  late Timer _promoTimer;

  final List<String> _promotionImages = [
    'assets/images/p1.jpeg',
    'assets/images/p2.jpeg',
    'assets/images/p3.webp',
  ];

  @override
  void initState() {
    super.initState();
    _promoTimer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPromoIndex < _promotionImages.length - 1) {
        _currentPromoIndex++;
      } else {
        _currentPromoIndex = 0;
      }
      _pageController.animateToPage(
        _currentPromoIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  void dispose() {
    _promoTimer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  static Widget _buildProductCard(String name, String imagePath, String price) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(imagePath, fit: BoxFit.contain),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(price, style: const TextStyle(color: Colors.green)),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHomePage() {
    return Column(
      children: [
        SizedBox(
          height: 180,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _promotionImages.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    _promotionImages[index],
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: GridView.count(
            crossAxisCount: 2,
            padding: const EdgeInsets.all(16),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _buildProductCard("Banana", "assets/images/banana.jpg", "Rs. 150 (12 pcs)"),
              _buildProductCard("Potato", "assets/images/patato.webp", "Rs. 80/kg"),
              _buildProductCard("Iron", "assets/images/iron.webp", "Rs. 2,500"),
              _buildProductCard("Toothpaste", "assets/images/toothpaste.webp", "Rs. 250"),
              _buildProductCard("Milk", "assets/images/milk.jpeg", "Rs. 180/litre"),
              _buildProductCard("Bread", "assets/images/bread.webp", "Rs. 120"),
              _buildProductCard("Shampoo", "assets/images/shampoowebp.webp", "Rs. 350"),
              _buildProductCard("LED Bulb", "assets/images/blub.jpg", "Rs. 220"),
            ],

          ),
        ),
      ],
    );
  }

  late List<Widget> _screens;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _screens = <Widget>[
      _buildHomePage(),
      const SearchScreen(),
      const CartScreen(),
      const ProfileScreen(),
    ];
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _openQRScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const QRScannerScreen()),
    );
  }

  void _openDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Home',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.green),
            onPressed: () => _openDrawer(context),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner, color: Colors.green),
            onPressed: _openQRScreen,
          ),
        ],
      ),

      body: _screens[_selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onBottomNavTap,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Cart"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
        type: BottomNavigationBarType.fixed,
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.green),
              child: Text(
                'Categories',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.local_florist, color: Colors.green),
              title: const Text('Fruits'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.cake, color: Colors.green),
              title: const Text('Bakery'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.grass, color: Colors.green),
              title: const Text('Vegetables'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart, color: Colors.green),
              title: const Text('Grocery'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.electrical_services, color: Colors.green),
              title: const Text('Electronics'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
