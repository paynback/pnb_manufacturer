part of 'add_product_bloc.dart';

@immutable
sealed class AddProductEvent {}


class AddProductButtonPressed extends AddProductEvent {
  final String name;
  final String description;
  final double price;
  final int stock;
  final String categoryId;
  final String moq;
  final List<File> images;
  final String token;

  AddProductButtonPressed({
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.categoryId,
    required this.moq,
    required this.images,
    required this.token,
  });
}
