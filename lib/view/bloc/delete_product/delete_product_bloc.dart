import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:paynback_manufacturer_app/controller/repositories/delete_product_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'delete_product_event.dart';
part 'delete_product_state.dart';

class DeleteProductBloc extends Bloc<DeleteProductEvent, DeleteProductState> {
  final DeleteProductRepo _repo;

  DeleteProductBloc(this._repo) : super(DeleteProductInitial()) {
    on<DeleteProductButtonPressed>((event, emit) async {
      emit(DeleteProductLoading());
      try {
        final pref = await SharedPreferences.getInstance();
        final token = pref.getString('accessToken');
        if(token !=null){
          final success = await _repo.deleteProduct(productId: event.productId,token: token);
          if (success) {
            emit(DeleteProductSuccess());
          } else {
            emit(DeleteProductFailure("Failed to delete product"));
          }
        }else{
          emit(DeleteProductFailure("Failed to delete product"));
        }
        
      } catch (e) {
        emit(DeleteProductFailure(e.toString()));
      }
    });
  }
}