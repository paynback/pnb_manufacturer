import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetOffersRepo {
  final Dio _dio = Dio();

  Future<List<dynamic>> getOffers() async {
    final String baseUrl = dotenv.env['base_Url']?.toString() ?? '';
    final String endPoint = dotenv.env['get_offers']?.toString() ?? '';
    final String url = "$baseUrl$endPoint";

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      if (token == null) {
        throw Exception('Access token not found. Please log in again.');
      }

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
        // ✅ Handle wrapped data format
        if (response.data is Map && response.data['data'] is List) {
          return List<dynamic>.from(response.data['data']);
        }

        // ✅ Handle direct array response
        if (response.data is List) {
          return List<dynamic>.from(response.data);
        }

        throw Exception('Unexpected response format');
      } else {
        throw Exception('Failed with status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}