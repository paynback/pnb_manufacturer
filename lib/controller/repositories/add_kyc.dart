// lib/api/add_kyc.dart

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AddKyc {
  final Dio _dio = Dio();

  Future<Response> submitKyc({
    required String name,
    required String email,
    required String aadhaar,
    required String pan,
    required String accountNumber,
    required String ifsc,
    required String branch,
    required File aadhaarFront,
    required File aadhaarBack,
    required File panFront,
    required File panBack,
  }) async {
    
    final String baseUrl = dotenv.env['base_Url']?.toString() ?? '';
    final String endPoint = dotenv.env['add_Kyc']?.toString() ?? '';
    final String url = "$baseUrl$endPoint";

    try {
      FormData formData = FormData.fromMap({
        'manufacturer_id': 'PNBM@7907721095',
        'name': name,
        'email': email,
        'aadhaarNumber': aadhaar,
        'panNumber': pan,
        'bankAccountNumber': accountNumber,
        'ifscCode': ifsc,
        'branchName': branch,
        'aadhaarFront': await MultipartFile.fromFile(aadhaarFront.path),
        'aadhaarBack': await MultipartFile.fromFile(aadhaarBack.path),
        'panImageFront': await MultipartFile.fromFile(panFront.path),
        'panImageBack': await MultipartFile.fromFile(panBack.path),
      });

      final response = await _dio.post(url, data: formData);

      // Check HTTP response code
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else {
        throw Exception('Failed to submit KYC: ${response.statusMessage}');
      }
    } on DioException catch (dioError) {
      if (dioError.type == DioExceptionType.connectionTimeout) {
        throw Exception("Connection timed out. Please try again.");
      } else if (dioError.response != null) {
        final errorMsg = dioError.response?.data['message'] ?? 'Something went wrong';
        throw Exception("Server error: $errorMsg");
      } else {
        throw Exception("Network error: ${dioError.message}");
      }
    } catch (e) {
      throw Exception("Unexpected error occurred: $e");
    }
  }
}