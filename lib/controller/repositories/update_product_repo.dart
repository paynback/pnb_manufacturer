import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class UpdateProductRepo {
  final Dio _dio = Dio();

  Future<Map<String, dynamic>> updateProduct({
    required String productId,
    required String name,
    required String description,
    required double price,
    required int stock,
    required String categoryId,
    required List<dynamic> images,
    required List<dynamic> removedImages,
    required String token,
  }) async {
    final String baseUrl = dotenv.env['base_Url']?.toString() ?? '';
    final String endPoint = dotenv.env['update_product']?.toString() ?? '';
    final String url = "$baseUrl$endPoint";

        print('Update function picked images: $images');
        print('Update function removing images: $removedImages');

    try {
      FormData formData = FormData.fromMap({
        "product_id": productId,
        "name": name,
        "description": description,
        "price": price,
        "stock": stock,
        "category_id": categoryId,
        "images": [
          for (var img in images.whereType<File>().take(5))
            await MultipartFile.fromFile(
              img.path,
              filename: img.path.split('/').last,
            ),
        ],
        "removeImages": jsonEncode(removedImages),
      });

      print(formData.fields);

      final response = await _dio.put(
        url,
        data: formData,
        options: Options(
          headers: {"Authorization": "Bearer $token"},
          contentType: "multipart/form-data",
        ),
      );

      print('Update repo result : ${response.data}');

      return response.data;
    } on DioException catch (e) {
      throw Exception(
          e.response?.data['message'] ?? e.message ?? "Failed to update product");
    } catch (e) {
      throw Exception("Something went wrong: $e");
    }
  }
}