import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:paynback_manufacturer_app/controller/repositories/get_product_repo.dart';
import 'package:paynback_manufacturer_app/model/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'get_products_event.dart';
part 'get_products_state.dart';

class GetProductsBloc extends Bloc<GetProductsEvent, GetProductsState> {
  final GetProductsRepo repo;

  GetProductsBloc(this.repo) : super(GetProductsInitial()) {
    on<FetchProductsEvent>((event, emit) async {
      emit(GetProductsLoading());
      try {
        final pref = await SharedPreferences.getInstance();
        final token = pref.getString('accessToken');

        if (token == null || token.isEmpty) {
          emit(GetProductsError('Token not found'));
          return;
        }

        final products = await repo.getProducts(token: token);
        emit(GetProductsLoaded(products));
      } catch (e) {
        emit(GetProductsError(e.toString()));
      }
    });
  }
}