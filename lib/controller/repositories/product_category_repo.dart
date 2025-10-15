import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ProductCategoryRepo {
  final Dio _dio = Dio();

  Future<List<Map<String, String>>> getProductCategories() async {
    final String baseUrl = dotenv.env['base_Url']?.toString() ?? '';
    final String endPoint = dotenv.env['product_category']?.toString() ?? '';
    final String url = "$baseUrl$endPoint";
    try {
      final response = await _dio.get(url);

      if (response.statusCode == 200 && response.data['categories'] != null) {
        final List categories = response.data['categories'];
        return categories
            .map((cat) => {
                  'id': cat['category_id'] as String,
                  'name': cat['name'] as String,
                })
            .toList();
      } else {
        throw Exception("Invalid API response");
      }
    } catch (e) {
      throw Exception("Failed to fetch categories: $e");
    }
  }
}