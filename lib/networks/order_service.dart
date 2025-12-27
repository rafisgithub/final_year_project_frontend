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

  // Update Order Status
  static Future<Map<String, dynamic>> updateOrderStatus(
    int orderId,
    String status,
  ) async {
    try {
      final token = GetStorage().read(kKeyAccessToken);
      final formData = FormData.fromMap({'status': status});

      final response = await DioSingleton.instance.dio.patch(
        '${Endpoints.orderStatusUpdate}$orderId/',
        data: formData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData['success'] == true) {
          return {
            'success': true,
            'message': responseData['message'] ?? 'Order status updated',
          };
        }
      }
      return {'success': false, 'message': 'Failed to update order status'};
    } catch (e) {
      if (kDebugMode) {
        print('Update Order Status Error: $e');
      }
      return {'success': false, 'message': 'Error updating order status'};
    }
  }

  // Get All Customers for Search
  static Future<Map<String, dynamic>> getAllCustomers() async {
    try {
      final token = GetStorage().read(kKeyAccessToken);
      final response = await DioSingleton.instance.dio.get(
        Endpoints.allCustomers,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData['success'] == true) {
          return {
            'success': true,
            'message':
                responseData['message'] ?? 'Customers retrieved successfully',
            'data': responseData['data'],
          };
        }
      }
      return {
        'success': false,
        'message': 'Failed to load customers',
        'data': [],
      };
    } catch (e) {
      if (kDebugMode) {
        print('Get All Customers Error: $e');
      }
      return {
        'success': false,
        'message': 'Error loading customers',
        'data': [],
      };
    }
  }

  // Add Due Entry
  static Future<Map<String, dynamic>> addDue({
    required int customerId,
    required String phoneNumber,
    required double amount,
    required String paymentDate, // YYYY-MM-DD
    required String notes,
    required String status,
  }) async {
    try {
      final token = GetStorage().read(kKeyAccessToken);
      final formData = FormData.fromMap({
        'customer_id': customerId,
        'phone_number': phoneNumber,
        'due_amount': amount,
        'payment_date': paymentDate,
        'notes': notes,
        'status': status,
      });

      final response = await DioSingleton.instance.dio.post(
        Endpoints.addDues,
        data: formData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;
        if (responseData['success'] == true) {
          return {
            'success': true,
            'message':
                responseData['message'] ?? 'Due entry added successfully',
          };
        }
      }
      return {'success': false, 'message': 'Failed to add due entry'};
    } catch (e) {
      if (kDebugMode) {
        print('Add Due Error: $e');
      }
      return {'success': false, 'message': 'Error adding due entry'};
    }
  }

  // Get Dues List (Filtered)
  static Future<Map<String, dynamic>> getDues({
    String? customerName,
    String? statusFilter, // 'all', 'paid', 'unpaid'
  }) async {
    try {
      final token = GetStorage().read(kKeyAccessToken);
      final Map<String, dynamic> queryParams = {};

      if (customerName != null && customerName.isNotEmpty) {
        queryParams['customer_name'] = customerName;
      }

      if (statusFilter != null) {
        queryParams['status_filter'] = statusFilter.toLowerCase();
      }

      final response = await DioSingleton.instance.dio.get(
        Endpoints.duesFilter,
        queryParameters: queryParams,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData['success'] == true) {
          return {
            'success': true,
            'message': responseData['message'] ?? 'Dues retrieved successfully',
            'data': responseData['data'],
          };
        }
      }
      return {'success': false, 'message': 'Failed to load dues', 'data': []};
    } catch (e) {
      if (kDebugMode) {
        print('Get Dues Error: $e');
      }
      return {'success': false, 'message': 'Error loading dues', 'data': []};
    }
  }

  // Update Due Status
  static Future<Map<String, dynamic>> updateDueStatus(
    int id,
    String status,
  ) async {
    try {
      final token = GetStorage().read(kKeyAccessToken);
      final formData = FormData.fromMap({'status': status});

      final response = await DioSingleton.instance.dio.patch(
        '${Endpoints.updateDuesStatus}$id/',
        data: formData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData['success'] == true) {
          return {
            'success': true,
            'message': responseData['message'] ?? 'Status updated successfully',
          };
        }
      }
      return {'success': false, 'message': 'Failed to update status'};
    } catch (e) {
      if (kDebugMode) {
        print('Update Due Status Error: $e');
      }
      return {'success': false, 'message': 'Error updating status'};
    }
  }

  // Update Due (Full Edit)
  static Future<Map<String, dynamic>> updateDue({
    required int id,
    required int customerId,
    required String phoneNumber,
    required double amount,
    required String paymentDate,
    required String notes,
    required String status,
  }) async {
    try {
      final token = GetStorage().read(kKeyAccessToken);
      final formData = FormData.fromMap({
        'customer_id': customerId,
        'phone_number': phoneNumber,
        'due_amount': amount,
        'payment_date': paymentDate,
        'notes': notes,
        'status': status,
      });

      final response = await DioSingleton.instance.dio.put(
        '${Endpoints.updateDues}$id/',
        data: formData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData['success'] == true) {
          return {
            'success': true,
            'message': responseData['message'] ?? 'Due updated successfully',
          };
        }
      }
      return {'success': false, 'message': 'Failed to update due'};
    } catch (e) {
      if (kDebugMode) {
        print('Update Due Error: $e');
      }
      return {'success': false, 'message': 'Error updating due'};
    }
  }

  // Get Due Details
  static Future<Map<String, dynamic>> getDueDetails(int id) async {
    try {
      final token = GetStorage().read(kKeyAccessToken);
      final response = await DioSingleton.instance.dio.get(
        '${Endpoints.editDues}$id/',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData['success'] == true) {
          return {
            'success': true,
            'message':
                responseData['message'] ?? 'Due details retrieved successfully',
            'data': responseData['data'],
          };
        }
      }
      return {'success': false, 'message': 'Failed to load due details'};
    } catch (e) {
      if (kDebugMode) {
        print('Get Due Details Error: $e');
      }
      return {'success': false, 'message': 'Error loading due details'};
    }
  }

  // Delete Due
  static Future<Map<String, dynamic>> deleteDue(int id) async {
    try {
      final token = GetStorage().read(kKeyAccessToken);
      final response = await DioSingleton.instance.dio.delete(
        '${Endpoints.deleteDues}$id/',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData['success'] == true) {
          return {
            'success': true,
            'message': responseData['message'] ?? 'Dues deleted successfully',
          };
        }
      }
      return {'success': false, 'message': 'Failed to delete due'};
    } catch (e) {
      if (kDebugMode) {
        print('Delete Due Error: $e');
      }
      return {'success': false, 'message': 'Error deleting due'};
    }
  }
}
