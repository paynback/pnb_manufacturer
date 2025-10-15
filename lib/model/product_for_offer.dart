class ProductForOffer {
  final String productId;
  final String name;
  final String image;

  ProductForOffer({
    required this.productId,
    required this.name,
    required this.image,
  });

  factory ProductForOffer.fromJson(Map<String, dynamic> json) {
    return ProductForOffer(
      productId: json['product_id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
    );
  }
}
