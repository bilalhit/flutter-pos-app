import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  bool _showPromotions = true;
  final ScrollController _scrollController = ScrollController();
  double _lastOffset = 0;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      final offset = _scrollController.offset;
      final direction = offset - _lastOffset;

      if (direction > 0 && _showPromotions) {
        setState(() => _showPromotions = false);
      } else if (direction < 0 && !_showPromotions) {
        setState(() => _showPromotions = true);
      }

      _lastOffset = offset;
    });

    _promoTimer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (mounted) {
        setState(() {
          _currentPromoIndex++;
        });
      }
    });
  }

  @override
  void dispose() {
    _promoTimer.cancel();
    _pageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> addToCart(BuildContext context, Map<String, dynamic> product) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final productCode = product['productCode'];

      // Get reference to the products collection
      final productsQuery = await FirebaseFirestore.instance
          .collection('products')
          .where('productCode', isEqualTo: productCode)
          .get();

      if (productsQuery.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product not found')),
        );
        return;
      }

      final productDoc = productsQuery.docs.first;
      final productRef = productDoc.reference;
      final productData = productDoc.data();

      int currentStock = productData['quantity'];

      if (currentStock <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product out of stock')),
        );
        return;
      }

      final cartRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('cart');

      final cartQuery = await cartRef
          .where('productCode', isEqualTo: productCode)
          .get();

      if (cartQuery.docs.isEmpty) {
        // Product not in cart: Add it
        await cartRef.add({
          'productCode': productCode,
          'name': product['name'],
          'price': product['price'],
          'imageUrl': product['imageUrl'],
          'quantity': 1,
        });
      } else {
        // Product already in cart: Update quantity
        final cartDoc = cartQuery.docs.first;
        await cartDoc.reference.update({
          'quantity': FieldValue.increment(1),
        });
      }

      // Reduce stock in products collection
      await productRef.update({
        'quantity': FieldValue.increment(-1),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product added to cart')),
      );
    } catch (e) {
      print('Error adding to cart: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }



  Widget _buildPromotionCarousel(List<String> images) {
    return SizedBox(
      height: 180,
      child: PageView.builder(
        controller: _pageController,
        itemCount: images.length,
        onPageChanged: (index) {
          setState(() {
            _currentPromoIndex = index;
          });
        },
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                images[index],
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.network(product['imageUrl'], fit: BoxFit.contain),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                Text(product['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                Text("Rs. ${product['price']}", style: const TextStyle(color: Colors.green)),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline, color: Colors.green),
                  onPressed: () {
                    addToCart(context, product);
                  },

                )
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
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _showPromotions
              ? StreamBuilder<QuerySnapshot>(
            key: const ValueKey(true),
            stream: FirebaseFirestore.instance.collection('promotions').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const SizedBox(height: 180, child: Center(child: CircularProgressIndicator()));
              }

              final docs = snapshot.data!.docs;
              final imageUrls = docs.map((doc) => doc['imageUrl'] as String).toList();

              if (imageUrls.isEmpty) {
                return const SizedBox(height: 180, child: Center(child: Text('No promotions')));
              }

              return _buildPromotionCarousel(imageUrls);
            },
          )
              : const SizedBox.shrink(),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('products').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final products = snapshot.data!.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

              return GridView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: products.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) => _buildProductCard(products[index]),
              );
            },
          ),
        )
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
    setState(() => _selectedIndex = index);
  }

  void _openQRScreen() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const QRScannerScreen()));
  }

  void _openDrawer(BuildContext context) => Scaffold.of(context).openDrawer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Home', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
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
              child: Text('Categories', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
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