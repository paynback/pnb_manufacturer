part of 'update_product_bloc.dart';

@immutable
sealed class UpdateProductEvent {}

class UpdateProductButtonPressed extends UpdateProductEvent {
  final String productId;
  final String name;
  final String description;
  final double price;
  final int stock;
  final String categoryId;
  final List<dynamic> images;
  final List<dynamic> removedImages;
  final String token;

  UpdateProductButtonPressed({
    required this.productId,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.categoryId,
    required this.images,
    required this.removedImages,
    required this.token,
  });
}