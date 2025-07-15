import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:paynback_manufacturer_app/constants.dart';
import 'package:paynback_manufacturer_app/model/product_model.dart';

class AddProductScreen extends StatefulWidget {
  final ProductModel? productToEdit;
  final int? index;
  final bool? isEdit;
  const AddProductScreen({super.key, this.productToEdit, this.index,this.isEdit});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  final List<File> _images = [];
  String _selectedCategory = 'None';

  final List<String> _categories = [
    'None',
    'Beverages',
    'Snacks',
    'Grocery',
    'Others',
  ];

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final picked = await _picker.pickMultiImage();
    if (picked.isNotEmpty) {
      setState(() {
        _images.addAll(picked.map((e) => File(e.path)));
      });
    }
  }

  void _submitProduct() {
    if (_formKey.currentState!.validate() && _images.isNotEmpty) {
      final product = ProductModel(
        name: _nameController.text.trim(),
        description: _descController.text.trim(),
        price: double.parse(_priceController.text.trim()),
        stock: int.parse(_stockController.text.trim()),
        images: _images,
        category: _selectedCategory,
      );
      Navigator.pop(context, {
        'product': product,
        'index': widget.index,
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all fields and select at least one image')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.productToEdit != null) {
      final product = widget.productToEdit!;
      _nameController.text = product.name;
      _descController.text = product.description;
      _priceController.text = product.price.toString();
      _stockController.text = product.stock.toString();
      _images.addAll(product.images);
      _selectedCategory = product.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pnbwhite,
      appBar: AppBar(
        title: const Text('Add Product'),
        backgroundColor: pnbThemeColor1,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                textCapitalization: TextCapitalization.words,
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Product Name'),
                validator: (value) => value!.isEmpty ? 'Enter product name' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                textCapitalization: TextCapitalization.sentences,
                controller: _descController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) => value!.isEmpty ? 'Enter description' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Price (₹)'),
                validator: (value) => value!.isEmpty ? 'Enter price' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _stockController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Stock Count'),
                validator: (value) => value!.isEmpty ? 'Enter stock count' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: _categories
                    .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                    .toList(),
                onChanged: (val) => setState(() => _selectedCategory = val!),
                decoration: const InputDecoration(labelText: 'Category'),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.image,color: pnbwhite,),
                label: Text('Pick Images',style: GoogleFonts.poppins(color: pnbwhite),),
                style: ElevatedButton.styleFrom(backgroundColor: pnbThemeColor1),
              ),
              const SizedBox(height: 10),
              _images.isEmpty
                  ? const Text('No images selected')
                  : SizedBox(
                      height: 100,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _images.length,
                        itemBuilder: (_, i) => Image.file(_images[i], width: 100, fit: BoxFit.cover),
                        separatorBuilder: (_, __) => const SizedBox(width: 10),
                      ),
                    ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _submitProduct,
                  style: ElevatedButton.styleFrom(backgroundColor: pnbThemeColor1),
                  child: Text( widget.isEdit==true? 'Update' : 'Add Product', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}