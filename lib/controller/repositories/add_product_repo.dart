import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AddProductRepo {
  final Dio _dio = Dio();



  Future<Map<String, dynamic>> addProduct({
    required String name,
    required String description,
    required double price,
    required int stock,
    required String categoryId,
    required String moq,
    required List<File> images,
    required String token,
  }) async {
    final String baseUrl = dotenv.env['base_Url']?.toString() ?? '';
    final String endPoint = dotenv.env['add_product']?.toString() ?? '';
    final String url = "$baseUrl$endPoint";
    try {
      FormData formData = FormData.fromMap({
        "name": name,
        "description": description,
        "price": price.toString(),
        "stock": stock.toString(),
        "category_id": categoryId,
        "moq": moq,
        "images": [
          for (var img in images.take(5))
            await MultipartFile.fromFile(img.path,
                filename: img.path.split("/").last)
        ],
      });

      final response = await _dio.post(
        url,
        data: formData,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "multipart/form-data",
          },
        ),
      );

      return response.data;
    } on DioException catch (e) {
      throw Exception(e.response?.data["message"] ?? e.message);
    }
  }
}