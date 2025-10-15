import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:paynback_manufacturer_app/model/product_for_offer.dart';

class GetProductForOffersRepo {
  final Dio _dio = Dio();

  Future<List<ProductForOffer>> fetchProductNames({required String token}) async {
    final String baseUrl = dotenv.env['base_Url']?.toString() ?? '';
    final String endPoint = dotenv.env['products_for_offers']?.toString() ?? '';
    final String url = "$baseUrl$endPoint";

    try {
      final response = await _dio.get(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;

        // ✅ Direct array
        if (data is List) {
          return data.map((e) => ProductForOffer.fromJson(e)).toList();
        }

        // ✅ Wrapped in "data" key
        if (data is Map && data['data'] is List) {
          return (data['data'] as List)
              .map((e) => ProductForOffer.fromJson(e))
              .toList();
        }

        throw Exception("Unexpected response format");
      } else {
        throw Exception(response.data['message'] ?? "Failed to load products");
      }
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? e.message ?? "Unknown error";
      throw Exception("Backend Error: $message");
    } catch (e) {
      throw Exception("Error fetching products: $e");
    }
  }
}