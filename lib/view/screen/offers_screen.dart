import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paynback_manufacturer_app/constants.dart';
import 'package:paynback_manufacturer_app/controller/repositories/get_offers_repo.dart';
import 'package:paynback_manufacturer_app/view/bloc/get_offers/get_offers_bloc.dart';
import 'package:intl/intl.dart';

class OffersScreen extends StatelessWidget {
  const OffersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetOffersBloc(GetOffersRepo())..add(FetchOffersEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Available Offers'),
          centerTitle: true,
        ),
        body: BlocBuilder<GetOffersBloc, GetOffersState>(
          builder: (context, state) {
            if (state is GetOffersLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is GetOffersError) {
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              );
            } else if (state is GetOffersLoaded) {
              if (state.offers.isEmpty) {
                return const Center(child: Text('No offers available.'));
              }

              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: state.offers.length,
                itemBuilder: (context, index) {
                  final offer = state.offers[index];
                  final startDate = DateFormat('dd MMM yyyy')
                      .format(DateTime.parse(offer['startDate']));
                  final endDate = DateFormat('dd MMM yyyy')
                      .format(DateTime.parse(offer['endDate']));
                  final isActive = offer['isActive'] == true;

                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 6,
                    color: pnbwhite,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 2,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Product Name',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  
                                }, 
                                icon: Icon(Icons.delete,color: Colors.red,)
                              )
                            ],
                          ),
                          Text('Discount: ${offer['discountValue']}%',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          Text('Description: ${offer['description'] ?? "No description"}'),
                          const SizedBox(height: 8),
                          Text(
                            'Offer ID: ${offer['offer_id']}',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Start: $startDate',style: GoogleFonts.poppins(color: Colors.green,fontWeight: FontWeight.w500),),
                              Text('End: $endDate',style: GoogleFonts.poppins(color: Colors.red,fontWeight: FontWeight.w500),),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Status: ${isActive ? "Active" : "Inactive"}',
                            style: TextStyle(
                              color: isActive ? Colors.green : Colors.red,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 6,
                            children: (offer['products'] as List<dynamic>)
                                .map((prod) => Text('Product ID: ${prod.toString()}',style: GoogleFonts.poppins(fontSize: 12,fontWeight: FontWeight.w500),))
                                .toList(),
                          ),
                        ],
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
    );
  }
}