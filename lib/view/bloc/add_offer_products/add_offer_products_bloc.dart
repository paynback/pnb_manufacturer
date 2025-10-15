import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:paynback_manufacturer_app/controller/repositories/get_product_for_offers_repo.dart';
import 'package:paynback_manufacturer_app/controller/repositories/add_offer_repo.dart';
import 'package:paynback_manufacturer_app/model/product_for_offer.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'add_offer_products_event.dart';
part 'add_offer_products_state.dart';

class AddOfferProductsBloc
    extends Bloc<AddOfferProductsEvent, AddOfferProductsState> {
  final GetProductForOffersRepo repo;
  final AddOfferRepo addOfferRepo = AddOfferRepo();

  AddOfferProductsBloc(this.repo) : super(AddOfferProductsInitial()) {
    // ✅ Fetch products
    on<FetchAddOfferProductsEvent>((event, emit) async {
      emit(AddOfferProductsLoading());
      try {
        final pref = await SharedPreferences.getInstance();
        final token = pref.getString('accessToken');
        if (token != null) {
          final products = await repo.fetchProductNames(token: token);
          emit(AddOfferProductsLoaded(products));
        } else {
          emit(AddOfferProductsError('Something went wrong'));
        }
      } catch (e) {
        emit(AddOfferProductsError(e.toString()));
      }
    });

    // ✅ Submit offer
    on<SubmitAddOfferEvent>((event, emit) async {
      emit(AddOfferSubmitting());
      try {
        final pref = await SharedPreferences.getInstance();
        final token = pref.getString('accessToken');
        if (token == null) throw Exception("Missing authentication token");

        await addOfferRepo.addOffer(
          token: token,
          description: event.description,
          startDate: event.startDate,
          endDate: event.endDate,
          offerValue: event.offerValue,
          productIds: event.selectedProductIds,
        );

        emit(AddOfferSuccess("Offer added successfully"));
      } catch (e) {
        emit(AddOfferProductsError(e.toString()));
      }
    });
  }
}