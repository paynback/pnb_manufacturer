import 'dart:io';

class ProductModel {
  final String name;
  final String description;
  final double price;
  final int stock;
  final List<File> images;
  final String category;

  ProductModel({
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.images,
    required this.category,
  });
}