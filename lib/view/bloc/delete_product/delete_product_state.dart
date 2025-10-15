part of 'delete_product_bloc.dart';

@immutable
sealed class DeleteProductState {}

final class DeleteProductInitial extends DeleteProductState {}

class DeleteProductLoading extends DeleteProductState {}

class DeleteProductSuccess extends DeleteProductState {}

class DeleteProductFailure extends DeleteProductState {
  final String message;

  DeleteProductFailure(this.message);
}