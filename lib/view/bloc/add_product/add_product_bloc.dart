import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:paynback_manufacturer_app/controller/repositories/add_product_repo.dart';

part 'add_product_event.dart';
part 'add_product_state.dart';

class AddProductBloc extends Bloc<AddProductEvent, AddProductState> {
  final AddProductRepo repo;

  AddProductBloc(this.repo) : super(AddProductInitial()) {
    on<AddProductButtonPressed>((event, emit) async {
      emit(AddProductLoading());
      try {
        final response = await repo.addProduct(
          name: event.name,
          description: event.description,
          price: event.price,
          stock: event.stock,
          categoryId: event.categoryId,
          moq: event.moq,
          images: event.images,
          token: event.token,
        );
        emit(AddProductSuccess(response));
      } catch (e) {
        emit(AddProductFailure('Something went wrong.'));
      }
    });
  }
}