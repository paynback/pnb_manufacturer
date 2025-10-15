part of 'get_products_bloc.dart';

@immutable
sealed class GetProductsState {}

final class GetProductsInitial extends GetProductsState {}

class GetProductsLoading extends GetProductsState {}

class GetProductsLoaded extends GetProductsState {
  final List<ProductModel> products;
  GetProductsLoaded(this.products);
}

class GetProductsError extends GetProductsState {
  final String message;
  GetProductsError(this.message);
}