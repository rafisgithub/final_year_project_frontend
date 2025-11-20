import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:final_year_project_frontend/networks/dio/dio.dart';
import 'package:final_year_project_frontend/networks/endpoints.dart';

class SearchService {
  // Search for products or stores
  static Future<Map<String, dynamic>> searchProductAndSeller({
    required String searchFor, // 'product' or 'store'
    required String name,
  }) async {
    try {
      if (kDebugMode) {
        print('Search Request - searchFor: $searchFor, name: $name');
      }

      final response = await getHttp(
        '${Endpoints.searchProductAndSeller}?search_for=$searchFor&name=$name',
        null,
      );

      if (kDebugMode) {
        print('Search Response: ${response.data}');
      }

      if (response.statusCode == 200) {
        final responseData = response.data;
        
        if (responseData['success'] == true) {
          return {
            'success': true,
            'message': responseData['message'] ?? 'Search results retrieved successfully',
            'data': responseData['data'] ?? [],
          };
        } else {
          return {
            'success': false,
            'message': responseData['message'] ?? 'No results found',
            'data': [],
          };
        }
      } else {
        return {
          'success': false,
          'message': 'Server error: ${response.statusCode}',
          'data': [],
        };
      }
    } on DioException catch (e) {
      if (kDebugMode) {
        print('Search Error: ${e.message}');
        print('Error Response: ${e.response?.data}');
      }

      String errorMessage = 'Failed to search';
      
      if (e.response?.data != null) {
        if (e.response?.data is Map) {
          errorMessage = e.response?.data['message'] ?? errorMessage;
        }
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        errorMessage = 'Connection timeout. Please try again.';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage = 'No internet connection';
      }

      return {
        'success': false,
        'message': errorMessage,
        'data': [],
      };
    } catch (e) {
      if (kDebugMode) {
        print('Unexpected Error: $e');
      }
      return {
        'success': false,
        'message': 'An unexpected error occurred',
        'data': [],
      };
    }
  }
}
