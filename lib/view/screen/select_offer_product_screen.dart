import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paynback_manufacturer_app/view/bloc/add_offer_products/add_offer_products_bloc.dart';
import 'package:paynback_manufacturer_app/model/product_for_offer.dart';

class SelectOfferProductScreen extends StatefulWidget {
  const SelectOfferProductScreen({
    super.key,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.offerValue,
  });

  final String startDate;
  final String endDate;
  final String offerValue;
  final String description;

  @override
  State<SelectOfferProductScreen> createState() =>
      _SelectOfferProductScreenState();
}

class _SelectOfferProductScreenState extends State<SelectOfferProductScreen> {
  final Set<String> _selectedProductIds = {};

  @override
  void initState() {
    super.initState();
    context.read<AddOfferProductsBloc>().add(FetchAddOfferProductsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Offer Products"),
        centerTitle: true,
      ),
      body: BlocListener<AddOfferProductsBloc, AddOfferProductsState>(
        listener: (context, state) {
          if (state is AddOfferSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            Navigator.pop(context);
          } else if (state is AddOfferProductsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: BlocBuilder<AddOfferProductsBloc, AddOfferProductsState>(
          builder: (context, state) {
            if (state is AddOfferProductsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is AddOfferProductsError) {
              return Center(child: Text("Error: ${state.message}"));
            } else if (state is AddOfferProductsLoaded) {
              final List<ProductForOffer> products = state.products;

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  final isSelected = _selectedProductIds.contains(
                    product.productId,
                  );

                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          product.image,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (context, _, __) => const Icon(
                                Icons.image_not_supported,
                                size: 40,
                                color: Colors.grey,
                              ),
                        ),
                      ),
                      title: Text(
                        product.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(
                        "ID: ${product.productId}",
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                      trailing: Checkbox(
                        value: isSelected,
                        onChanged: (value) {
                          setState(() {
                            if (value == true) {
                              _selectedProductIds.add(product.productId);
                            } else {
                              _selectedProductIds.remove(product.productId);
                            }
                          });
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  );
                },
              );
            }
            return const SizedBox();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (_selectedProductIds.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Please select at least one product"),
              ),
            );
          } else {
            // Dispatch event to submit offer
            context.read<AddOfferProductsBloc>().add(
              SubmitAddOfferEvent(
                description: widget.description,
                startDate: widget.startDate,
                endDate: widget.endDate,
                offerValue: widget.offerValue,
                selectedProductIds: _selectedProductIds.toList(),
              ),
            );
          }
        },
        label: const Text("Submit"),
        icon: const Icon(Icons.check),
      ),
    );
  }
}
