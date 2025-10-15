class ProductModel {
  final String productId;
  final String name;
  final String? description;
  final double price;
  final int stock;
  final List<String> images;
  final bool isActive;
  final String categoryName;

  ProductModel({
    required this.productId,
    required this.name,
    this.description,
    required this.price,
    required this.stock,
    required this.images,
    required this.isActive,
    required this.categoryName,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    double parsePrice(dynamic value) {
      if (value == null) return 0.0;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    return ProductModel(
      productId: json['product_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      price: parsePrice(json['price']),
      stock: (json['stock'] is int)
          ? json['stock']
          : int.tryParse(json['stock']?.toString() ?? '0') ?? 0,
      images: List<String>.from(json['images'] ?? []),
      isActive: json['isActive'] ?? true,
      categoryName: json['categoryName'] ?? '',
    );
  }
}