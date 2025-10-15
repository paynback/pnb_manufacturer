import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:paynback_manufacturer_app/controller/repositories/update_product_repo.dart';

part 'update_product_event.dart';
part 'update_product_state.dart';

class UpdateProductBloc extends Bloc<UpdateProductEvent, UpdateProductState> {
  final UpdateProductRepo repo;

  UpdateProductBloc(this.repo) : super(UpdateProductInitial()) {
    on<UpdateProductButtonPressed>(_onUpdateProduct);
  }

  Future<void> _onUpdateProduct(
      UpdateProductButtonPressed event, Emitter<UpdateProductState> emit) async {
    emit(UpdateProductLoading());
    try {
      final response = await repo.updateProduct(
        productId: event.productId,
        name: event.name,
        description: event.description,
        price: event.price,
        stock: event.stock,
        categoryId: event.categoryId,
        images: event.images,
        token: event.token,
        removedImages: event.removedImages
      );
      emit(UpdateProductSuccess(response['message'] ?? "Product updated successfully"));
    } catch (e) {
      emit(UpdateProductFailure(e.toString()));
    }
  }
}
