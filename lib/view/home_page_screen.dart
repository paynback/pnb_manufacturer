import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paynback_manufacturer_app/constants.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<String> _products = [];

  void _showAddProductDialog() {
    final TextEditingController productController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Product'),
        content: TextField(
          controller: productController,
          decoration: const InputDecoration(hintText: 'Enter product name'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final productName = productController.text.trim();
              if (productName.isNotEmpty) {
                setState(() {
                  _products.add(productName);
                });
              }
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: pnbThemeColor1,
            ),
            child: const Text('Add', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: pnbThemeColor1,
        title: Text(
          'Hello Athul Bar Pvt.Ltd',
          style: GoogleFonts.poppins(color: pnbwhite),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: _showAddProductDialog,
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text('Add Product', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: pnbThemeColor1,
                minimumSize: const Size.fromHeight(50),
              ),
            ),
            const SizedBox(height: 20),
            _products.isEmpty
                ? const Center(child: Text('No products added yet.'))
                : Expanded(
                    child: ListView.builder(
                      itemCount: _products.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            leading: const Icon(Icons.shopping_bag),
                            title: Text(_products[index]),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
