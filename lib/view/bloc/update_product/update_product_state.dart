part of 'update_product_bloc.dart';

@immutable
sealed class UpdateProductState {}

final class UpdateProductInitial extends UpdateProductState {}

class UpdateProductLoading extends UpdateProductState {}

class UpdateProductSuccess extends UpdateProductState {
  final String message;
  UpdateProductSuccess(this.message);
}

class UpdateProductFailure extends UpdateProductState {
  final String error;
  UpdateProductFailure(this.error);
}
