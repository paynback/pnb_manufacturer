import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paynback_manufacturer_app/constants.dart';
import 'package:paynback_manufacturer_app/model/product_model.dart';
import 'package:paynback_manufacturer_app/view/screen/add_product_screen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<ProductModel> _products = [];

  void _navigateToAddProduct({ProductModel? product, int? index, bool? isEdit}) async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (_) => AddProductScreen(productToEdit: product, index: index,isEdit: isEdit,),
      ),
    );

    if (result != null) {
      final newProduct = result['product'] as ProductModel;
      final productIndex = result['index'] as int?;

      setState(() {
        if (productIndex != null) {
          _products[productIndex] = newProduct;
        } else {
          _products.add(newProduct);
        }
      });
    }
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
              onPressed: _navigateToAddProduct,
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
                    child: GridView.builder(
                      itemCount: _products.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.75,
                      ),
                      itemBuilder: (context, index) {
                        final product = _products[index];
                        return Stack(
                          children: [
                            Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Product Image
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                    child: product.images.isNotEmpty
                                        ? Image.file(
                                            product.images.first,
                                            height: 120,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                          )
                                        : Container(
                                            height: 120,
                                            width: double.infinity,
                                            color: Colors.grey.shade300,
                                            child: const Icon(Icons.image_not_supported, size: 50),
                                          ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(product.name,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            )),
                                        const SizedBox(height: 4),
                                        Text('₹${product.price.toStringAsFixed(2)}'),
                                        Text('Stock: ${product.stock}'),
                                        Text(
                                          product.category,
                                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Edit Button
                            Positioned(
                              top: 6,
                              right: 6,
                              child: CircleAvatar(
                                radius: 16,
                                backgroundColor: Colors.white,
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  icon: const Icon(Icons.edit, size: 16, color: pnbThemeColor1),
                                  onPressed: () {
                                    _navigateToAddProduct(product: product, index: index,isEdit: true);
                                  },
                                ),
                              ),
                            ),
                          ],
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