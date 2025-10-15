import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DeleteProductRepo {
  final Dio _dio = Dio();

  Future<bool> deleteProduct({required String productId,required String token}) async {
    final String baseUrl = dotenv.env['base_Url']?.toString() ?? '';
    final String endPoint = dotenv.env['delete_product']?.toString() ?? '';
    final String url = "$baseUrl$endPoint$productId";

    print('Deleting api calling product id with $productId');

    try {
      // final response = await _dio.delete(url);
      final response = await _dio.delete(
        url,
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception("Failed to delete product");
      }
    } catch (e) {
      throw Exception("Error deleting product: $e");
    }
  }
}