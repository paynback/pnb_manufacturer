import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../model/product_model.dart';

class GetProductsRepo {
  final Dio _dio = Dio();

  Future<List<ProductModel>> getProducts({
    required String token,
    int page = 1,
    int limit = 10,
  }) async {
    final String baseUrl = dotenv.env['base_Url']?.toString() ?? '';
    final String endPoint = dotenv.env['get_products']?.toString() ?? '';
    final String url = "$baseUrl$endPoint";

    try {
      final response = await _dio.get(
        url,
        queryParameters: {'page': page, 'limit': limit},
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data['data'] as List;
        print('Added Products: $data');
        return data.map((e) => ProductModel.fromJson(e)).toList();
      } else {
        // Handle backend error message
        final message = response.data != null && response.data['message'] != null
            ? response.data['message'].toString()
            : 'Failed to load products';
        throw Exception(message);
      }
    } on DioException catch (dioError) {
      // If backend sends error in response body
      if (dioError.response != null && dioError.response?.data != null) {
        final backendMessage = dioError.response?.data['message'] ?? dioError.message;
        throw Exception(backendMessage);
      } else {
        throw Exception('Network error: ${dioError.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}