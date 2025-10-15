// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:paynback_manufacturer_app/constants.dart';
// import 'package:paynback_manufacturer_app/controller/repositories/delete_product_repo.dart';
// import 'package:paynback_manufacturer_app/controller/repositories/get_product_repo.dart';
// import 'package:paynback_manufacturer_app/model/product_model.dart';
// import 'package:paynback_manufacturer_app/view/bloc/delete_product/delete_product_bloc.dart';
// import 'package:paynback_manufacturer_app/view/bloc/get_products/get_products_bloc.dart';
// import 'package:paynback_manufacturer_app/view/screen/add_product_screen.dart';

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.manufacturerName});
//   final String manufacturerName;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   late GetProductsBloc _bloc;

//   @override
//   void initState() {
//     super.initState();
//     _bloc = GetProductsBloc(GetProductsRepo());
//     _bloc.add(FetchProductsEvent());
//   }

//   void _navigateToAddProduct({
//     ProductModel? product,
//     int? index,
//     bool? isEdit,
//   }) async {
//     final result = await Navigator.push<Map<String, dynamic>>(
//       context,
//       MaterialPageRoute(
//         builder:
//             (_) => BlocProvider.value(
//               value: _bloc, // Pass the existing GetProductsBloc
//               child: AddProductScreen(
//                 productToEdit: product,
//                 index: index,
//                 isEdit: isEdit,
//               ),
//             ),
//       ),
//     );
//     if (result != null) {
//       _bloc.add(FetchProductsEvent());
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider(create: (_) => _bloc),
//         BlocProvider(create: (_) => DeleteProductBloc(DeleteProductRepo())),
//       ],
//       child: Scaffold(
//         appBar: AppBar(
//           backgroundColor: pnbThemeColor1,
//           title: Text(
//             widget.manufacturerName,
//             style: GoogleFonts.poppins(color: pnbwhite),
//           ),
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               ElevatedButton.icon(
//                 onPressed: _navigateToAddProduct,
//                 icon: const Icon(Icons.add, color: Colors.white),
//                 label: const Text(
//                   'Add Product',
//                   style: TextStyle(color: Colors.white),
//                 ),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: pnbThemeColor1,
//                   minimumSize: const Size.fromHeight(50),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               BlocListener<DeleteProductBloc, DeleteProductState>(
//                 listener: (context, state) {
//                   if (state is DeleteProductSuccess) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(content: Text('Product deleted successfully')),
//                     );
//                     // Refresh product list
//                     _bloc.add(FetchProductsEvent());
//                   } else if (state is DeleteProductFailure) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text(state.message)),
//                     );
//                   }
//                 },
//                 child: Expanded(
//                   child: BlocBuilder<GetProductsBloc, GetProductsState>(
//                     builder: (context, state) {
//                       if (state is GetProductsLoading) {
//                         return const Center(child: CircularProgressIndicator());
//                       } else if (state is GetProductsLoaded) {
//                         if (state.products.isEmpty) {
//                           return const Center(
//                             child: Text('No products added yet.'),
//                           );
//                         }
//                         return GridView.builder(
//                           itemCount: state.products.length,
//                           gridDelegate:
//                               const SliverGridDelegateWithFixedCrossAxisCount(
//                                 crossAxisCount: 2,
//                                 crossAxisSpacing: 12,
//                                 mainAxisSpacing: 12,
//                                 childAspectRatio: 0.75,
//                               ),
//                           itemBuilder: (context, index) {
//                             final product = state.products[index];
//                             return Stack(
//                               children: [
//                                 Card(
//                                   elevation: 4,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(12),
//                                   ),
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       ClipRRect(
//                                         borderRadius:
//                                             const BorderRadius.vertical(
//                                               top: Radius.circular(12),
//                                             ),
//                                         child:
//                                             product.images.isNotEmpty
//                                                 ? Image.network(
//                                                   product.images.first,
//                                                   height: 120,
//                                                   width: double.infinity,
//                                                   fit: BoxFit.cover,
//                                                 )
//                                                 : Container(
//                                                   height: 120,
//                                                   width: double.infinity,
//                                                   color: Colors.grey.shade300,
//                                                   child: const Icon(
//                                                     Icons.image_not_supported,
//                                                     size: 50,
//                                                   ),
//                                                 ),
//                                       ),
//                                       Padding(
//                                         padding: const EdgeInsets.all(8.0),
//                                         child: Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Text(
//                                               product.name,
//                                               style: const TextStyle(
//                                                 fontWeight: FontWeight.bold,
//                                                 fontSize: 16,
//                                               ),
//                                             ),
//                                             const SizedBox(height: 4),
//                                             Text(
//                                               '₹${product.price.toStringAsFixed(2)}',
//                                             ),
//                                             Text('Stock: ${product.stock}'),
//                                             Text(
//                                               product.categoryName,
//                                               style: TextStyle(
//                                                 fontSize: 12,
//                                                 color: Colors.grey.shade600,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 Positioned(
//                                   top: 6,
//                                   right: 6,
//                                   child: CircleAvatar(
//                                     radius: 16,
//                                     backgroundColor: Colors.white,
//                                     child: IconButton(
//                                       padding: EdgeInsets.zero,
//                                       icon: const Icon(
//                                         Icons.edit,
//                                         size: 16,
//                                         color: pnbThemeColor1,
//                                       ),
//                                       onPressed: () {
//                                         _navigateToAddProduct(
//                                           product: product,
//                                           index: index,
//                                           isEdit: true,
//                                         );
//                                       },
//                                     ),
//                                   ),
//                                 ),
//                                 Positioned(
//                                   top: 6,
//                                   left: 6,
//                                   child: CircleAvatar(
//                                     radius: 16,
//                                     backgroundColor: Colors.white,
//                                     child: IconButton(
//                                       padding: EdgeInsets.zero,
//                                       icon: Icon(
//                                         Icons.delete,
//                                         size: 16,
//                                         color: Colors.red,
//                                       ),
//                                       onPressed: () async {
//                                         final confirm = await showDialog<bool>(
//                                           context: context,
//                                           builder:
//                                               (context) => AlertDialog(
//                                                 backgroundColor: pnbwhite,
//                                                 title: Text(
//                                                   'Confirm Delete',
//                                                   style: TextStyle(
//                                                     color: pnbThemeColor1,
//                                                     fontWeight: FontWeight.bold,
//                                                   ),
//                                                 ),
//                                                 content: const Text(
//                                                   'Are you sure you want to remove this product? This action cannot be undone.',
//                                                 ),
//                                                 actions: [
//                                                   TextButton(
//                                                     onPressed:
//                                                         () => Navigator.of(
//                                                           context,
//                                                         ).pop(false),
//                                                     child: const Text('Cancel'),
//                                                   ),
//                                                   ElevatedButton(
//                                                     style:
//                                                         ElevatedButton.styleFrom(
//                                                           backgroundColor:
//                                                               pnbThemeColor1,
//                                                         ),
//                                                     onPressed:
//                                                         () => Navigator.of(
//                                                           context,
//                                                         ).pop(true),
//                                                     child: const Text(
//                                                       'Delete',
//                                                       style: TextStyle(
//                                                         color: Colors.white,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                         );

//                                         // If the user confirms deletion
//                                         if (confirm == true) {
//                                           context.read<DeleteProductBloc>().add(
//                                             DeleteProductButtonPressed(
//                                               product.productId,
//                                             ),
//                                           );
//                                         }
//                                       },
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             );
//                           },
//                         );
//                       } else if (state is GetProductsError) {
//                         return Center(child: Text('Error: ${state.message}'));
//                       } else {
//                         return const SizedBox();
//                       }
//                     },
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paynback_manufacturer_app/constants.dart';
import 'package:paynback_manufacturer_app/controller/repositories/delete_product_repo.dart';
import 'package:paynback_manufacturer_app/controller/repositories/get_product_repo.dart';
import 'package:paynback_manufacturer_app/model/product_model.dart';
import 'package:paynback_manufacturer_app/view/bloc/delete_product/delete_product_bloc.dart';
import 'package:paynback_manufacturer_app/view/bloc/get_products/get_products_bloc.dart';
import 'package:paynback_manufacturer_app/view/screen/add_product_screen.dart';
import 'package:paynback_manufacturer_app/view/screen/product_details_screen.dart';
import 'package:paynback_manufacturer_app/view/screen/settings_screen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.manufacturerName});
  final String manufacturerName;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late GetProductsBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = GetProductsBloc(GetProductsRepo());
    _bloc.add(FetchProductsEvent());
  }

  void _navigateToAddProduct({
    ProductModel? product,
    int? index,
    bool? isEdit,
  }) async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: _bloc,
          child: AddProductScreen(
            productToEdit: product,
            index: index,
            isEdit: isEdit,
          ),
        ),
      ),
    );
    if (result != null) {
      _bloc.add(FetchProductsEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => _bloc),
        BlocProvider(create: (_) => DeleteProductBloc(DeleteProductRepo())),
      ],
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          backgroundColor: pnbThemeColor1,
          elevation: 3,
          centerTitle: true,
          title: Text(
            widget.manufacturerName,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                  return SettingsScreen();
                },));
              }, 
              icon: Icon(Icons.menu)
            )
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: pnbThemeColor1,
          onPressed: _navigateToAddProduct,
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text("Add Product", style: TextStyle(color: Colors.white)),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocListener<DeleteProductBloc, DeleteProductState>(
            listener: (context, state) {
              if (state is DeleteProductSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Product deleted successfully'),
                    backgroundColor: Colors.green.shade600,
                  ),
                );
                _bloc.add(FetchProductsEvent());
              } else if (state is DeleteProductFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red.shade400,
                  ),
                );
              } else if (state is DeleteProductLoading) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => const Center(child: CircularProgressIndicator()),
                );
              }
            },
            child: BlocBuilder<GetProductsBloc, GetProductsState>(
              builder: (context, state) {
                if (state is GetProductsLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is GetProductsLoaded) {
                  if (state.products.isEmpty) {
                    return const Center(
                      child: Text(
                        'No products added yet.',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    );
                  }

                  return GridView.builder(
                    itemCount: state.products.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 0.72,
                    ),
                    itemBuilder: (context, index) {
                      final product = state.products[index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProductDetailsScreen(product: product),
                            ),
                          );
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(16),
                                    ),
                                    child: product.images.isNotEmpty
                                        ? Image.network(
                                            product.images.first,
                                            height: 140,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                          )
                                        : Container(
                                            height: 140,
                                            width: double.infinity,
                                            color: Colors.grey.shade300,
                                            child: const Icon(
                                              Icons.image_not_supported,
                                              size: 50,
                                              color: Colors.grey,
                                            ),
                                          ),
                                  ),
                                  Positioned(
                                    top: 6,
                                    right: 6,
                                    child: CircleAvatar(
                                      radius: 16,
                                      backgroundColor: Colors.white,
                                      child: IconButton(
                                        padding: EdgeInsets.zero,
                                        icon: const Icon(
                                          Icons.edit,
                                          size: 16,
                                          color: pnbThemeColor1,
                                        ),
                                        onPressed: () {
                                          _navigateToAddProduct(
                                            product: product,
                                            index: index,
                                            isEdit: true,
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 6,
                                    left: 6,
                                    child: CircleAvatar(
                                      radius: 16,
                                      backgroundColor: Colors.white,
                                      child: IconButton(
                                        padding: EdgeInsets.zero,
                                        icon: const Icon(
                                          Icons.delete,
                                          size: 16,
                                          color: Colors.red,
                                        ),
                                        onPressed: () async {
                                          final confirm = await showDialog<bool>(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              backgroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(16),
                                              ),
                                              title: Text(
                                                'Delete Product?',
                                                style: TextStyle(
                                                  color: pnbThemeColor1,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              content: const Text(
                                                'Are you sure you want to delete this product? This action cannot be undone.',
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () => Navigator.of(context).pop(false),
                                                  child: const Text('Cancel'),
                                                ),
                                                ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: pnbThemeColor1,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                  ),
                                                  onPressed: () => Navigator.of(context).pop(true),
                                                  child: const Text('Delete', style: TextStyle(color: Colors.white)),
                                                ),
                                              ],
                                            ),
                                          );

                                          if (confirm == true) {
                                            context
                                                .read<DeleteProductBloc>()
                                                .add(DeleteProductButtonPressed(product.productId));
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.name,
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      '₹${product.price.toStringAsFixed(2)}',
                                      style: GoogleFonts.inter(
                                        color: Colors.green.shade700,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Stock: ${product.stock}',
                                      style: GoogleFonts.poppins(
                                        color: Colors.grey.shade700,
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      product.categoryName,
                                      style: GoogleFonts.poppins(
                                        color: Colors.grey.shade500,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else if (state is GetProductsError) {
                  return Center(
                    child: Text(
                      'Error: ${state.message}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}