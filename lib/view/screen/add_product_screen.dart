  // ignore_for_file: use_build_context_synchronously

  import 'dart:developer';
  import 'dart:io';
  import 'package:flutter/material.dart';
  import 'package:flutter_bloc/flutter_bloc.dart';
  import 'package:flutter_image_compress/flutter_image_compress.dart';
  import 'package:google_fonts/google_fonts.dart';
  import 'package:image_picker/image_picker.dart';
  import 'package:paynback_manufacturer_app/constants.dart';
  import 'package:paynback_manufacturer_app/controller/repositories/add_product_repo.dart';
  import 'package:paynback_manufacturer_app/controller/repositories/product_category_repo.dart';
  import 'package:paynback_manufacturer_app/controller/repositories/update_product_repo.dart';
  import 'package:paynback_manufacturer_app/model/product_model.dart';
  import 'package:paynback_manufacturer_app/view/bloc/add_product/add_product_bloc.dart';
  import 'package:paynback_manufacturer_app/view/bloc/get_products/get_products_bloc.dart';
  import 'package:paynback_manufacturer_app/view/bloc/product_category/product_category_bloc.dart';
  import 'package:paynback_manufacturer_app/view/bloc/update_product/update_product_bloc.dart';
  import 'package:shared_preferences/shared_preferences.dart';


  class AddProductScreen extends StatefulWidget {
    final ProductModel? productToEdit;
    final int? index;
    final bool? isEdit;
    const AddProductScreen({super.key, this.productToEdit, this.index, this.isEdit});

    @override
    State<AddProductScreen> createState() => _AddProductScreenState();
  }

  class _AddProductScreenState extends State<AddProductScreen> {
    final _formKey = GlobalKey<FormState>();

    final _nameController = TextEditingController();
    final _descController = TextEditingController();
    final _priceController = TextEditingController();
    final _stockController = TextEditingController();
    final _moqController = TextEditingController();
    final List<File> _images = [];
    final List<String> _existingImages = [];
    final List<String> _deletingImages = [];
    String? _selectedCategory;
    bool _isChanged = false;
    ProductModel? _originalProduct;

    final ImagePicker _picker = ImagePicker();

    Future<void> _pickImage() async {
      final picked = await _picker.pickMultiImage();
      if (picked.isNotEmpty) {
        List<File> compressedImages = [];
        
        for (var pickedFile in picked) {
          File? compressed = await _compressImage(File(pickedFile.path));
          if (compressed != null) {
            compressedImages.add(compressed);
          }
        }
        
        setState(() {
          print('picked images: ${compressedImages.length}');
          _images.addAll(compressedImages);
        });
        _checkForChanges();
      }
    }

    Future<File?> _compressImage(File file) async {
      final filePath = file.absolute.path;
      final outPath = "${filePath.substring(0, filePath.lastIndexOf('.'))}_compressed.jpg";
      
      var result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        outPath,
        quality: 70,
        minWidth: 1920,
        minHeight: 1080,
      );
      
      if (result != null) {
        return File(result.path);
      }
      return null;
    }

    void _checkForChanges() {
      // If it's not edit mode, no need to compare with original product
      if (widget.isEdit != true || _originalProduct == null) return;

      bool hasChanged = false;

      // Compare text fields
      if (_nameController.text.trim() != _originalProduct!.name ||
          _descController.text.trim() != _originalProduct!.description ||
          _priceController.text.trim() != _originalProduct!.price.toString() ||
          _stockController.text.trim() != _originalProduct!.stock.toString()) {
        hasChanged = true;
      }

      // Compare category safely
      if (_selectedCategory != null &&
          _selectedCategory!.isNotEmpty &&
          _selectedCategory != _originalProduct!.categoryName) {
        hasChanged = true;
      }

      // Compare images
      if (_existingImages.length != _originalProduct!.images.length ||
          !_listEquals(_existingImages, _originalProduct!.images) ||
          _images.isNotEmpty) {
        hasChanged = true;
      }

      if (hasChanged != _isChanged) {
        setState(() {
          _isChanged = hasChanged;
        });
      }
    }

    bool _listEquals(List<String> a, List<String> b) {
      if (a.length != b.length) return false;
      for (int i = 0; i < a.length; i++) {
        if (a[i] != b[i]) return false;
      }
      return true;
    }

    @override
    void initState() {
      super.initState();
      if (widget.productToEdit != null) {
        final product = widget.productToEdit!;
        _originalProduct = product;
        _nameController.text = product.name;
        _descController.text = product.description!;
        _priceController.text = product.price.toString();
        _stockController.text = product.stock.toString();
        _existingImages.addAll(product.images);
        _selectedCategory = '';

        // Listen for text field changes
        if (widget.isEdit == true) {
          _nameController.addListener(_checkForChanges);
          _descController.addListener(_checkForChanges);
          _priceController.addListener(_checkForChanges);
          _stockController.addListener(_checkForChanges);
        }
      }
    }

    @override
    Widget build(BuildContext context) {
      return MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => AddProductBloc(AddProductRepo())),
          BlocProvider(create: (_) => ProductCategoryBloc(ProductCategoryRepo())..add(FetchProductCategories()),),
          BlocProvider(create: (_) => UpdateProductBloc(UpdateProductRepo())), 
        ],
        child: Scaffold(
          backgroundColor: pnbwhite,
          appBar: AppBar(
            title: Text( widget.isEdit==true? 'Update' : 'Add Product'),
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
                  TextFormField(
                    controller: _moqController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Minimum quantity'),
                    validator: (value) => value!.isEmpty ? 'MOQ' : null,
                  ),
                  const SizedBox(height: 12),
                  BlocBuilder<ProductCategoryBloc, ProductCategoryState>(
                    builder: (context, state) {
                      if (state is ProductCategoryLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is ProductCategoryLoaded) {
                        // Set category ID for editing if not already set
                        if (_selectedCategory == null && widget.productToEdit != null) {
                          final matchingCategory = state.categories.firstWhere(
                            (cat) => cat['name'] == widget.productToEdit!.categoryName,
                            orElse: () => {},
                          );
                          if (matchingCategory.isNotEmpty) {
                            _selectedCategory = matchingCategory['id'];
                          }
                        }
          
                        return DropdownButtonFormField<String>(
                          value: _selectedCategory?.isNotEmpty == true ? _selectedCategory : null,
                          items: state.categories.map(
                            (cat) => DropdownMenuItem<String>(
                              value: cat['id'],
                              child: Text(cat['name'] ?? ''),
                            ),
                          ).toList(),
                          onChanged: (val) {
                            setState(() => _selectedCategory = val);
                            _checkForChanges();
                          },
                          decoration: const InputDecoration(labelText: 'Category'),
                          validator: (value) => value == null ? 'Select a category' : null,
                        );
                      } else if (state is ProductCategoryError) {
                        return Text('Failed to load categories: ${state.message}');
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.image, color: pnbwhite),
                    label: Text(
                      'Pick Images',
                      style: GoogleFonts.poppins(color: pnbwhite),
                    ),
                    style: ElevatedButton.styleFrom(backgroundColor: pnbThemeColor1),
                  ),
                  const SizedBox(height: 10),
                  _existingImages.isEmpty && _images.isEmpty
                    ? const Text('No images selected')
                    : SizedBox(
                        height: 100,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            // Show existing images (from URLs)
                            ..._existingImages.asMap().entries.map(
                              (entry) {
                                final index = entry.key;
                                final url = entry.value;
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(url, width: 100, fit: BoxFit.cover),
                                      ),
                                      Positioned(
                                        right: 0,
                                        top: 0,
                                        child: GestureDetector(
                                          onTap: () {
                                            print('Existing images : $_existingImages');
                                            setState(() {
                                              final value = _existingImages[index];

                                              // Remove it from the current list
                                              _existingImages.removeAt(index);

                                              // Check if it's an existing S3 image URL
                                              if (value.startsWith("https://pndb-bucket.s3.ap-south-1.amazonaws.com/")) {
                                                print('Deleteing backend image : $value');
                                                _deletingImages.add(value);
                                              }
                                            });
                                            _checkForChanges();
                                          },
                                          child: Container(
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.black54,
                                            ),
                                            child: const Icon(Icons.close, color: Colors.white, size: 18),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
          
                            // Show newly picked images (from File)
                            ..._images.asMap().entries.map(
                              (entry) {
                                final index = entry.key;
                                final file = entry.value;
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.file(file, width: 100, fit: BoxFit.cover),
                                      ),
                                      Positioned(
                                        right: 0,
                                        top: 0,
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _images.removeAt(index);
                                            });
                                          },
                                          child: Container(
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.black54,
                                            ),
                                            child: const Icon(Icons.close, color: Colors.white, size: 18),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                  const SizedBox(height: 20),
                  // Use separate BlocConsumer for Update
                  if (widget.isEdit == true)
                    BlocConsumer<UpdateProductBloc, UpdateProductState>(
                      listener: (context, state) {
                        if (state is UpdateProductSuccess) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    "✅ Product Updated Successfully!! Redirecting to Products Screen")),
                          );
                          context.read<GetProductsBloc>().add(FetchProductsEvent());
                          Future.delayed(const Duration(milliseconds: 1500), () {
                            Navigator.pop(context);
                          });
                        } else if (state is UpdateProductFailure) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("❌ ${state.error}")),
                          );
                        }
                      },
                      builder: (context, state) {
                        return SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: state is UpdateProductLoading
                                ? null
                                : () async {
                                    if (_formKey.currentState!.validate()) {
                                      final prefs = await SharedPreferences.getInstance();
                                      final token = prefs.getString('accessToken') ?? '';
          
                                      List<dynamic> allImages = [
                                        ..._existingImages, // these are URLs already stored on backend
                                        ..._images,    // these are new uploads
                                      ];

                                      log(widget.productToEdit!.productId);
                                      log(_nameController.text.trim());
                                      log(_descController.text.trim());
                                      log(_priceController.text.trim());
                                      log(_stockController.text.trim());
                                      log(_selectedCategory!);
          
                                      context.read<UpdateProductBloc>().add(
                                            UpdateProductButtonPressed(
                                              productId: widget.productToEdit!.productId,
                                              name: _nameController.text.trim(),
                                              description: _descController.text.trim(),
                                              price: double.parse(_priceController.text.trim()),
                                              stock: int.parse(_stockController.text.trim()),
                                              categoryId: _selectedCategory!,
                                              images: allImages,
                                              token: token,
                                              removedImages: _deletingImages
                                            ),
                                          );
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: pnbThemeColor1,
                            ),
                            child: state is UpdateProductLoading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : const Text(
                                    'Update Product',
                                    style: TextStyle(color: Colors.white),
                                  ),
                          ),
                        );
                      },
                    )
                    else
                    // Use separate BlocConsumer for Add
                    BlocConsumer<AddProductBloc, AddProductState>(
                      listener: (context, state) {
                        if (state is AddProductSuccess) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    "✅ Product Added Successfully!! Redirecting to Products Screen")),
                          );
                          context.read<GetProductsBloc>().add(FetchProductsEvent());
                          Future.delayed(const Duration(milliseconds: 1500), () {
                            Navigator.pop(context);
                          });
                        } else if (state is AddProductFailure) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("❌ ${state.error}")),
                          );
                        }
                      },
                      builder: (context, state) {
                        return SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: state is AddProductLoading
                                ? null
                                : () async {
                                    if (_formKey.currentState!.validate() &&
                                        (_images.isNotEmpty || _existingImages.isNotEmpty)) {
                                      final prefs = await SharedPreferences.getInstance();
                                      final token = prefs.getString('accessToken') ?? '';       
                                      
          
                                      context.read<AddProductBloc>().add(
                                            AddProductButtonPressed(
                                              name: _nameController.text.trim(),
                                              description: _descController.text.trim(),
                                              price: double.parse(_priceController.text.trim()),
                                              moq: _moqController.text.trim(),
                                              stock: int.parse(_stockController.text.trim()),
                                              categoryId: _selectedCategory!,
                                              images: _images,
                                              token: token,
                                            ),
                                          );
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                '⚠️ Fill all fields & select images')),
                                      );
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: pnbThemeColor1,
                            ),
                            child: state is AddProductLoading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : const Text(
                                    'Add Product',
                                    style: TextStyle(color: Colors.white),
                                  ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }