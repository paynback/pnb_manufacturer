part of 'product_category_bloc.dart';

abstract class ProductCategoryState {}

class ProductCategoryInitial extends ProductCategoryState {}

class ProductCategoryLoading extends ProductCategoryState {}

class ProductCategoryLoaded extends ProductCategoryState {
  final List<Map<String, String>> categories;

  ProductCategoryLoaded(this.categories);
}

class ProductCategoryError extends ProductCategoryState {
  final String message;

  ProductCategoryError(this.message);
}
