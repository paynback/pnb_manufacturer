import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


class AuthInit {
  final Dio _dio = Dio();

  Future<void> initiateAuth(String phone) async {

    final String baseUrl = dotenv.env['base_Url']?.toString() ?? '';
    final String endPoint = dotenv.env['auth_Init']?.toString() ?? '';
    final String url = "$baseUrl$endPoint";

    try {
      final response = await _dio.post(
        url,
        data: {"mobileNumber": phone},
      );

      if (response.statusCode != 200) {
        throw Exception("Unexpected response from server.");
      }
    } on DioException catch (e) {
      final errorMessage = e.response?.data['message'] ?? 'Something went wrong';
      throw Exception(errorMessage);
    } catch (_) {
      throw Exception("Unknown error occurred.");
    }
  }
}