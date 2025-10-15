import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthStatus {
  final Dio _dio = Dio();

  Future<Map<String, dynamic>> checkAuthStatus() async {
    

    try {
      final prefs = await SharedPreferences.getInstance();
      final manufacturerId = prefs.getString('manufacturer_id');

      final String baseUrl = dotenv.env['base_Url']?.toString() ?? '';
      final String endPoint = dotenv.env['auth_Status']?.toString() ?? '';
      final String url = "$baseUrl$endPoint$manufacturerId";

      if (manufacturerId == null) {
        throw Exception("Manufacturer ID not found in SharedPreferences");
      }

      final response = await _dio.get(
        url,
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        log("Splash Auth Status Response: $data");
        return data;
      } else {
        throw Exception("Unexpected server response");
      }
    } on DioException catch (e) {
      final errorMessage = e.response?.data['message'] ?? 'Failed to fetch auth status';
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception("Unknown error occurred: $e");
    }
  }
}