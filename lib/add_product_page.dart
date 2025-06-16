import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  String productName = '';
  String price = '';
  String quantity = '';
  String productCode = '';
  File? imageFile;

  Future<void> pickImage() async {
    final pickedImage =
    await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        imageFile = File(pickedImage.path);
      });
    }
  }

  void saveProduct() {
    if (_formKey.currentState!.validate()) {
      // You can send this data to your database later
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product Saved (Frontend Only)')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Product'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Image Preview + Button
              GestureDetector(
                onTap: pickImage,
                child: Container(
                  height: 160,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: imageFile != null
                      ? Image.file(imageFile!, fit: BoxFit.cover)
                      : const Center(
                    child: Text('Tap to select product image'),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Product Name
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Product Name',
                  border: OutlineInputBorder(),
                ),
                onChanged: (val) => productName = val,
                validator: (val) =>
                val!.isEmpty ? 'Enter product name' : null,
              ),
              const SizedBox(height: 16),

              // Price
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (val) => price = val,
                validator: (val) => val!.isEmpty ? 'Enter price' : null,
              ),
              const SizedBox(height: 16),

              // Quantity
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Quantity',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (val) => quantity = val,
                validator: (val) => val!.isEmpty ? 'Enter quantity' : null,
              ),
              const SizedBox(height: 16),

              // Product Code
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Product Code (Unique)',
                  border: OutlineInputBorder(),
                ),
                onChanged: (val) => productCode = val,
                validator: (val) =>
                val!.isEmpty ? 'Enter unique product code' : null,
              ),
              const SizedBox(height: 30),

              // Save Button
              ElevatedButton.icon(
                onPressed: saveProduct,
                icon: const Icon(Icons.save),
                label: const Text('Save Product'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
