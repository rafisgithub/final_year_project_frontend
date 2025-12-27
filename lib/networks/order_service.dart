import 'package:flutter/foundation.dart';
import 'package:final_year_project_frontend/networks/dio/dio.dart';
import 'package:final_year_project_frontend/networks/endpoints.dart';
import 'package:get_storage/get_storage.dart';
import 'package:final_year_project_frontend/constants/app_constants.dart';
import 'package:dio/dio.dart';

class OrderService {
  // Get Seller Orders
  static Future<Map<String, dynamic>> getSellerOrders({
    String? status,
    String? customerName,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {};
      if (status == null || status == 'all' || status == 'All') {
        queryParams['status'] = [
          'pending',
          'confirmed',
          'delivered',
          'cancelled',
          'all',
        ];
      } else {
        queryParams['status'] = status;
      }

      if (customerName != null && customerName.isNotEmpty) {
        queryParams['customer_name'] = customerName;
      }

      final response = await getHttp(Endpoints.sellerOrders, queryParams);

      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData['success'] == true) {
          return {
            'success': true,
            'message':
                responseData['message'] ?? 'Orders retrieved successfully',
            'data': responseData['data'],
          };
        }
      }
      return {'success': false, 'message': 'Failed to load orders', 'data': []};
    } catch (e) {
      if (kDebugMode) {
        print('Get Seller Orders Error: $e');
      }
      return {'success': false, 'message': 'Error loading orders', 'data': []};
    }
  }

  // Get Order Details
  static Future<Map<String, dynamic>> getOrderDetails(int orderId) async {
    try {
      final response = await getHttp('${Endpoints.orderDetails}$orderId/');

      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData['success'] == true) {
          return {
            'success': true,
            'message':
                responseData['message'] ??
                'Order details retrieved successfully',
            'data': responseData['data'],
          };
        }
      }
      return {'success': false, 'message': 'Failed to load order details'};
    } catch (e) {
      if (kDebugMode) {
        print('Get Order Details Error: $e');
      }
      return {'success': false, 'message': 'Error loading order details'};
    }
  }

  static Future<Map<String, dynamic>> getCustomerOrders() async {
    try {
      final token = GetStorage().read(kKeyAccessToken);
      final response = await DioSingleton.instance.dio.get(
        Endpoints.customerOrders,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData['success'] == true) {
          return {
            'success': true,
            'message':
                responseData['message'] ??
                'Customer orders retrieved successfully',
            'data': responseData['data'],
          };
        }
      }
      return {'success': false, 'message': 'Failed to load orders', 'data': []};
    } catch (e) {
      if (kDebugMode) {
        print('Get Customer Orders Error: $e');
      }
      return {'success': false, 'message': 'Error loading orders', 'data': []};
    }
  }
}
