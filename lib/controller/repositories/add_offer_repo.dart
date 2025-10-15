import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AddOfferRepo {
  final Dio _dio = Dio();

  Future<void> addOffer({
    required String token,
    required String description,
    required String startDate,
    required String endDate,
    required String offerValue,
    required List<String> productIds,
  }) async {
    final String baseUrl = dotenv.env['base_Url']?.toString() ?? '';
    final String endPoint = dotenv.env['add_offer']?.toString() ?? '';
    final String url = "$baseUrl$endPoint";

    try {
      final response = await _dio.post(
        url,
        data: {
          "discountValue": offerValue,
          "startDate": startDate,
          "endDate": endDate,
          "description": description,
          "productIds": productIds,
        },
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
        ),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception(response.data['message'] ?? "Failed to add offer");
      }
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? e.message ?? "Unknown error";
      throw Exception("Backend Error: $message");
    } catch (e) {
      throw Exception("Error adding offer: $e");
    }
  }
}