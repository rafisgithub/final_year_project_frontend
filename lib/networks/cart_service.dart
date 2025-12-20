import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:final_year_project_frontend/networks/dio/dio.dart';
import 'package:final_year_project_frontend/networks/endpoints.dart';

class CartService {
  // Add product to cart
  static Future<Map<String, dynamic>> addToCart({
    required int productId,
    int quantity = 1,
  }) async {
    try {
      if (kDebugMode) {
        print(
          'Adding product to cart. Product ID: $productId, Quantity: $quantity',
        );
      }

      final data = {'product_id': productId, 'quantity': quantity};

      final response = await postHttp(Endpoints.addToCart, data);

      if (kDebugMode) {
        print('Add to Cart Response: ${response.data}');
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;

        if (responseData['success'] == true) {
          return {
            'success': true,
            'message':
                responseData['message'] ?? 'Product added to cart successfully',
            'data': responseData['data'],
          };
        } else {
          return {
            'success': false,
            'message':
                responseData['message'] ?? 'Failed to add product to cart',
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
        print('Add to Cart Error: ${e.message}');
        print('Error Response: ${e.response?.data}');
      }

      String errorMessage = 'Failed to add product to cart';

      if (e.response?.data != null) {
        if (e.response?.data is Map) {
          errorMessage = e.response?.data['message'] ?? errorMessage;
          // Handle specific validation errors if any
          if (e.response?.data['errors'] != null) {
            errorMessage =
                e.response?.data['errors'].toString() ?? errorMessage;
          }
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

  // Get cart details
  static Future<Map<String, dynamic>> getCart() async {
    try {
      final response = await getHttp(Endpoints.cart, null);

      if (kDebugMode) {
        print('Get Cart Response: ${response.data}');
      }

      if (response.statusCode == 200) {
        final responseData = response.data;

        if (responseData['success'] == true) {
          return {
            'success': true,
            'message': responseData['message'] ?? 'Cart retrieved successfully',
            'data': responseData['data'],
          };
        } else {
          return {
            'success': false,
            'message': responseData['message'] ?? 'Failed to get cart',
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
        print('Get Cart Error: ${e.message}');
        print('Error Response: ${e.response?.data}');
      }

      String errorMessage = 'Failed to get cart';

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

  // Update cart item quantity
  static Future<Map<String, dynamic>> updateCartItem({
    required int cartItemId,
    required int quantity,
  }) async {
    try {
      if (kDebugMode) {
        print('Updating cart item. ID: $cartItemId, Quantity: $quantity');
      }

      final url = '${Endpoints.updateCartItem}$cartItemId/';
      final data = {'quantity': quantity};

      final response = await patchHttp(url, data);

      if (kDebugMode) {
        print('Update Cart Item Response: ${response.data}');
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;

        if (responseData['success'] == true) {
          return {
            'success': true,
            'message':
                responseData['message'] ?? 'Cart item updated successfully',
            'data': responseData['data'],
          };
        } else {
          return {
            'success': false,
            'message': responseData['message'] ?? 'Failed to update cart item',
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
        print('Update Cart Item Error: ${e.message}');
        print('Error Response: ${e.response?.data}');
      }

      String errorMessage = 'Failed to update cart item';

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
}
