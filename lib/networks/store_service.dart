import 'package:dio/dio.dart';
import 'package:final_year_project_frontend/networks/dio/dio.dart';
import 'package:final_year_project_frontend/networks/endpoints.dart';

class StoreService {
  static Future<Map<String, dynamic>> getStoreList() async {
    try {
      final response = await getHttp(
        Endpoints.storeList,
        null,
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': response.data['message'] ?? 'Success',
          'data': response.data['data'] ?? [],
        };
      } else {
        return {
          'success': false,
          'message': response.data['message'] ?? 'Failed to load stores',
          'data': [],
        };
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return {
          'success': false,
          'message': 'Connection timeout. Please try again.',
          'data': [],
        };
      } else if (e.type == DioExceptionType.connectionError) {
        return {
          'success': false,
          'message': 'No internet connection. Please check your network.',
          'data': [],
        };
      } else {
        return {
          'success': false,
          'message': e.response?.data['message'] ?? 'Failed to load stores',
          'data': [],
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: ${e.toString()}',
        'data': [],
      };
    }
  }
}
