import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class VerifyAuth {
  final Dio _dio = Dio();

  Future<Map<String, dynamic>> verifyOtp(String phone, String otp) async {
    final String baseUrl = dotenv.env['base_Url']?.toString() ?? '';
    final String endPoint = dotenv.env['verify_Auth']?.toString() ?? '';
    final String url = "$baseUrl$endPoint";

    log(phone);

    try {
      final response = await _dio.post(
        url,
        data: {
          "mobileNumber": phone,
          "enteredOtp": otp,
        },
      );

      if (response.statusCode != 200) {
        throw Exception("Unexpected server response");
      }

      // Cast and return the response as Map<String, dynamic>
      final responseData = response.data as Map<String, dynamic>;
      print("OTP Verification Response: $responseData");
      return responseData;
    } on DioException catch (e) {
      final errorMessage = e.response?.data['message'] ?? 'OTP verification failed';
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception("Unknown error occurred: $e");
    }
  }
}