import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:final_year_project_frontend/networks/dio/dio.dart'
    as dio_helper;
import 'package:final_year_project_frontend/networks/endpoints.dart';

class ProfileService {
  // Get Profile
  static Future<Map<String, dynamic>> getProfile() async {
    try {
      if (kDebugMode) {
        print('Get Profile Request');
      }

      final response = await dio_helper.getHttp(Endpoints.profileGet, null);

      if (kDebugMode) {
        print('Get Profile Response: ${response.data}');
      }

      if (response.statusCode == 200) {
        final responseData = response.data;

        if (responseData['success'] == true) {
          return {
            'success': true,
            'message':
                responseData['message'] ?? 'Profile retrieved successfully',
            'data': responseData['data'],
          };
        } else {
          return {
            'success': false,
            'message': responseData['message'] ?? 'Failed to retrieve profile',
          };
        }
      } else {
        return {'success': false, 'message': 'Failed to retrieve profile'};
      }
    } on DioException catch (e) {
      if (kDebugMode) {
        print('Get Profile Error: ${e.message}');
        print('Error Response: ${e.response?.data}');
      }

      String errorMessage = 'Failed to retrieve profile';

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

      return {'success': false, 'message': errorMessage};
    } catch (e) {
      if (kDebugMode) {
        print('Unexpected Error: $e');
      }
      return {'success': false, 'message': 'An unexpected error occurred'};
    }
  }

  // Update Avatar
  static Future<Map<String, dynamic>> updateAvatar({
    required String avatarPath,
  }) async {
    try {
      if (kDebugMode) {
        print('Update Avatar Request: $avatarPath');
      }

      // Create FormData for file upload
      final formData = FormData.fromMap({
        'avatar': await MultipartFile.fromFile(
          avatarPath,
          filename: avatarPath.split('/').last,
        ),
      });

      final response = await dio_helper.putHttpFormData(
        Endpoints.avatarUpdate,
        formData,
      );

      if (kDebugMode) {
        print('Update Avatar Response: ${response.data}');
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;

        if (responseData['success'] == true) {
          return {
            'success': true,
            'message': responseData['message'] ?? 'Avatar updated successfully',
            'data': responseData['data'],
          };
        } else {
          return {
            'success': false,
            'message': responseData['message'] ?? 'Failed to update avatar',
          };
        }
      } else {
        return {
          'success': false,
          'message': 'Server error: ${response.statusCode}',
        };
      }
    } on DioException catch (e) {
      if (kDebugMode) {
        print('Update Avatar Error: ${e.message}');
        print('Error Response: ${e.response?.data}');
      }

      String errorMessage = 'Failed to update avatar';

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

      return {'success': false, 'message': errorMessage};
    } catch (e) {
      if (kDebugMode) {
        print('Unexpected Error: $e');
      }
      return {'success': false, 'message': 'An unexpected error occurred'};
    }
  }

  // Switch Role
  static Future<Map<String, dynamic>> switchRole({required String role}) async {
    try {
      if (kDebugMode) {
        print('Switch Role Request: $role');
      }

      final response = await dio_helper.postHttp(Endpoints.switchRole, {
        'role': role,
      });

      if (kDebugMode) {
        print('Switch Role Response: ${response.data}');
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;

        if (responseData['success'] == true) {
          return {
            'success': true,
            'message': responseData['message'] ?? 'Role switched successfully',
            'data': responseData['data'],
          };
        } else {
          return {
            'success': false,
            'message': responseData['message'] ?? 'Failed to switch role',
          };
        }
      } else {
        return {
          'success': false,
          'message': 'Server error: ${response.statusCode}',
        };
      }
    } on DioException catch (e) {
      if (kDebugMode) {
        print('Switch Role Error: ${e.message}');
        print('Error Response: ${e.response?.data}');
      }

      String errorMessage = 'Failed to switch role';

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

      return {'success': false, 'message': errorMessage};
    } catch (e) {
      if (kDebugMode) {
        print('Unexpected Error: $e');
      }
      return {'success': false, 'message': 'An unexpected error occurred'};
    }
  }

  // Seller Registration
  static Future<Map<String, dynamic>> sellerRegistration({
    required String storeName,
    required String storeContactNumber,
    required String storeAddress,
    required String nidFrontImagePath,
    required String nidBackImagePath,
  }) async {
    try {
      if (kDebugMode) {
        print('Seller Registration Request');
        print('Store Name: $storeName');
        print('Store Contact: $storeContactNumber');
        print('Store Address: $storeAddress');
      }

      // Create FormData for file upload
      final formData = FormData.fromMap({
        'store_name': storeName,
        'store_contact_number': storeContactNumber,
        'store_address': storeAddress,
        'nid_front_image': await MultipartFile.fromFile(
          nidFrontImagePath,
          filename: nidFrontImagePath.split('/').last,
        ),
        'nid_back_image': await MultipartFile.fromFile(
          nidBackImagePath,
          filename: nidBackImagePath.split('/').last,
        ),
      });

      final response = await dio_helper.postHttpFormData(
        Endpoints.sellerRegistration,
        formData,
      );

      if (kDebugMode) {
        print('Seller Registration Response: ${response.data}');
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;

        if (responseData['success'] == true) {
          return {
            'success': true,
            'message':
                responseData['message'] ?? 'Seller registration successful',
            'data': responseData['data'],
          };
        } else {
          return {
            'success': false,
            'message':
                responseData['message'] ?? 'Failed to register as seller',
          };
        }
      } else {
        return {
          'success': false,
          'message': 'Server error: ${response.statusCode}',
        };
      }
    } on DioException catch (e) {
      if (kDebugMode) {
        print('Seller Registration Error: ${e.message}');
        print('Error Response: ${e.response?.data}');
      }

      String errorMessage = 'Failed to register as seller';

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

      return {'success': false, 'message': errorMessage};
    } catch (e) {
      if (kDebugMode) {
        print('Unexpected Error: $e');
      }
      return {'success': false, 'message': 'An unexpected error occurred'};
    }
  }
}
