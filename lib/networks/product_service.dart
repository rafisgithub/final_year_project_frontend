import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:final_year_project_frontend/networks/dio/dio.dart';
import 'package:final_year_project_frontend/networks/endpoints.dart';

class ProductService {
  // Get product details by ID
  static Future<Map<String, dynamic>> getProductDetails(int productId) async {
    try {
      if (kDebugMode) {
        print('Fetching product details for ID: $productId');
      }

      final response = await getHttp(
        '${Endpoints.productDetails}$productId/',
        null,
      );

      if (kDebugMode) {
        print('Product Details Response: ${response.data}');
      }

      if (response.statusCode == 200) {
        final responseData = response.data;

        if (responseData['success'] == true) {
          return {
            'success': true,
            'message':
                responseData['message'] ??
                'Product details retrieved successfully',
            'data': responseData['data'],
          };
        } else {
          return {
            'success': false,
            'message':
                responseData['message'] ?? 'Failed to load product details',
            'data': null,
          };
        }
      } else {
        return {
          'success': false,
          'message': 'Server error: ${response.statusCode}',
          'data': null,
        };
      }
    } on DioException catch (e) {
      if (kDebugMode) {
        print('Product Details Error: ${e.message}');
        print('Error Response: ${e.response?.data}');
      }

      String errorMessage = 'Failed to load product details';

      if (e.response?.data != null) {
        if (e.response?.data is Map) {
          errorMessage = e.response?.data['message'] ?? errorMessage;
        }
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        errorMessage = 'Connection timeout. Please try again.';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage = 'No internet connection. Please check your network.';
      }

      return {'success': false, 'message': errorMessage, 'data': null};
    } catch (e) {
      if (kDebugMode) {
        print('Unexpected Error: $e');
      }
      return {
        'success': false,
        'message': 'An unexpected error occurred',
        'data': null,
      };
    }
  }

  // Get product categories
  static Future<Map<String, dynamic>> getProductCategories() async {
    try {
      final response = await getHttp(Endpoints.productCategories, null);

      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData['success'] == true) {
          return {
            'success': true,
            'message':
                responseData['message'] ??
                'Product categories retrieved successfully',
            'data': responseData['data'],
          };
        }
      }
      return {'success': false, 'message': 'Failed to load categories'};
    } catch (e) {
      return {'success': false, 'message': 'Error fetching categories'};
    }
  }

  // Get diseased categories
  static Future<Map<String, dynamic>> getDiseasedCategories() async {
    try {
      final response = await getHttp(Endpoints.diseasedCategories, null);

      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData['success'] == true) {
          return {
            'success': true,
            'message':
                responseData['message'] ??
                'Diseased categories retrieved successfully',
            'data': responseData['data'],
          };
        }
      }
      return {
        'success': false,
        'message': 'Failed to load diseased categories',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error fetching diseased categories',
      };
    }
  }

  // Get target stages
  static Future<Map<String, dynamic>> getTargetStages() async {
    try {
      final response = await getHttp(Endpoints.targetStages, null);

      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData['success'] == true) {
          return {
            'success': true,
            'message':
                responseData['message'] ??
                'Target stages retrieved successfully',
            'data': responseData['data'],
          };
        }
      }
      return {'success': false, 'message': 'Failed to load target stages'};
    } catch (e) {
      return {'success': false, 'message': 'Error fetching target stages'};
    }
  }
}
