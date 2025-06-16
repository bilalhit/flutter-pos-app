import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Your cart is empty',
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}
