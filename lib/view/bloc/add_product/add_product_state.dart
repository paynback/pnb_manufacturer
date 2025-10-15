part of 'add_product_bloc.dart';

@immutable
sealed class AddProductState {}

final class AddProductInitial extends AddProductState {}

class AddProductLoading extends AddProductState {}

class AddProductSuccess extends AddProductState {
  final Map<String, dynamic> response;
  AddProductSuccess(this.response);
}

class AddProductFailure extends AddProductState {
  final String error;
  AddProductFailure(this.error);
}