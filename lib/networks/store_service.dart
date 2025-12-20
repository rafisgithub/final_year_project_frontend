import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:final_year_project_frontend/networks/dio/dio.dart';
import 'package:final_year_project_frontend/networks/endpoints.dart';

class StoreService {
  // Get list of all stores
  static Future<Map<String, dynamic>> getStoreList() async {
    try {
      final response = await getHttp(Endpoints.storeList, null);

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

  // Get store details by ID
  static Future<Map<String, dynamic>> getStoreDetails(int storeId) async {
    try {
      if (kDebugMode) {
        print('Fetching store details for ID: $storeId');
      }

      final response = await getHttp(
        '${Endpoints.storeDetails}$storeId/',
        null,
      );

      if (kDebugMode) {
        print('Store Details Response: ${response.data}');
      }

      if (response.statusCode == 200) {
        final responseData = response.data;

        if (responseData['success'] == true) {
          return {
            'success': true,
            'message':
                responseData['message'] ??
                'Store details retrieved successfully',
            'data': responseData['data'],
          };
        } else {
          return {
            'success': false,
            'message':
                responseData['message'] ?? 'Failed to load store details',
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
        print('Store Details Error: ${e.message}');
        print('Error Response: ${e.response?.data}');
      }

      String errorMessage = 'Failed to load store details';

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

  // Get store products with optional filters
  static Future<Map<String, dynamic>> getStoreProducts({
    required int storeId,
    String? categoryName,
    String? productName,
  }) async {
    try {
      // Build query parameters
      final queryParams = <String, dynamic>{};
      if (categoryName != null && categoryName.isNotEmpty) {
        queryParams['category_name'] = categoryName;
      }
      if (productName != null && productName.isNotEmpty) {
        queryParams['product_name'] = productName;
      }

      if (kDebugMode) {
        print(
          'Fetching store products for store ID: $storeId with filters: $queryParams',
        );
      }

      // Build URL with store ID and query parameters
      String url = '${Endpoints.storeProducts}$storeId/';
      if (queryParams.isNotEmpty) {
        final queryString = queryParams.entries
            .map((e) => '${e.key}=${Uri.encodeComponent(e.value.toString())}')
            .join('&');
        url = '$url?$queryString';
      }

      if (kDebugMode) {
        print('Request URL: $url');
      }

      final response = await getHttp(url, null);

      if (kDebugMode) {
        print('Store Products Response: ${response.data}');
      }

      if (response.statusCode == 200) {
        final responseData = response.data;

        if (responseData['success'] == true) {
          return {
            'success': true,
            'message':
                responseData['message'] ?? 'Products retrieved successfully',
            'data': responseData['data'] ?? [],
          };
        } else {
          return {
            'success': false,
            'message': responseData['message'] ?? 'Failed to load products',
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
        print('Store Products Error: ${e.message}');
        print('Error Response: ${e.response?.data}');
      }

      String errorMessage = 'Failed to load products';

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

      return {'success': false, 'message': errorMessage, 'data': []};
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

  // Get store products with search and category filter using new API
  static Future<Map<String, dynamic>> getStoreProductSearch({
    required int storeId,
    String? categoryName,
    String? productName,
  }) async {
    try {
      // Build query parameters
      final queryParams = <String, dynamic>{};

      // Ensure we pass the parameters exactly as requested
      if (productName != null && productName.isNotEmpty) {
        queryParams['name'] = productName;
      }

      if (categoryName != null && categoryName.isNotEmpty) {
        queryParams['category_name'] = categoryName;
      }

      if (kDebugMode) {
        print(
          'Searching store products for store ID: $storeId with filters: $queryParams',
        );
      }

      // Build URL with store ID and query parameters
      String url = '${Endpoints.storeProductSearch}$storeId/';
      if (queryParams.isNotEmpty) {
        final queryString = queryParams.entries
            .map((e) => '${e.key}=${Uri.encodeComponent(e.value.toString())}')
            .join('&');
        url = '$url?$queryString';
      }

      if (kDebugMode) {
        print('Request URL: $url');
      }

      final response = await getHttp(url, null);

      if (kDebugMode) {
        print('Store Product Search Response: ${response.data}');
      }

      if (response.statusCode == 200) {
        final responseData = response.data;

        if (responseData['success'] == true) {
          return {
            'success': true,
            'message':
                responseData['message'] ??
                'Store product search results retrieved successfully',
            'data': responseData['data'] ?? [],
          };
        } else {
          return {
            'success': false,
            'message': responseData['message'] ?? 'Failed to search products',
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
        print('Store Product Search Error: ${e.message}');
        print('Error Response: ${e.response?.data}');
      }

      String errorMessage = 'Failed to search products';

      if (e.response?.data != null) {
        if (e.response?.data is Map) {
          errorMessage = e.response?.data['message'] ?? errorMessage;
        }
      }

      return {'success': false, 'message': errorMessage, 'data': []};
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
