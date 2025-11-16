import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:final_year_project_frontend/constants/app_constants.dart';
import 'package:final_year_project_frontend/helpers/di.dart';
import 'package:final_year_project_frontend/networks/dio/dio.dart';
import 'package:final_year_project_frontend/networks/endpoints.dart';

class AuthService {
  // Sign Up
  static Future<Map<String, dynamic>> signUp({
    required String name,
    required String fatherName,
    required String email,
    required String phoneNumber,
    required String password,
    required String selectedLanguage,
  }) async {
    try {
      final data = {
        'name': name,
        'father_name': fatherName,
        'email': email,
        'phone_number': phoneNumber,
        'password': password,
        'selected_language': selectedLanguage,
      };

      if (kDebugMode) {
        print('Sign Up Request: $data');
      }

      final response = await postHttpNoAuth(Endpoints.signup, data);

      if (kDebugMode) {
        print('Sign Up Response: ${response.data}');
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;
        
        if (responseData['success'] == true && responseData['data'] != null) {
          // Save tokens and user data
          final userData = responseData['data'];
          await appData.write(kKeyAccessToken, userData['access_token']);
          await appData.write(kKeyRefreshToken, userData['refresh_token']);
          await appData.write(kKeyUserId, userData['id'].toString());
          await appData.write(kKeyEmail, userData['email']);
          if (userData['role'] != null) {
            await appData.write(kKeyRole, userData['role']);
          }
          
          // Update Dio with the new token
          DioSingleton.instance.update(userData['access_token']);
          
          return {
            'success': true,
            'message': responseData['message'] ?? 'Sign up successful',
            'data': userData,
          };
        } else {
          return {
            'success': false,
            'message': responseData['message'] ?? 'Sign up failed',
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
        print('Sign Up DioException: ${e.message}');
        print('Response: ${e.response?.data}');
      }
      
      if (e.response != null && e.response?.data != null) {
        final errorData = e.response!.data;
        return {
          'success': false,
          'message': errorData['message'] ?? 'Sign up failed',
          'errors': errorData['errors'],
        };
      }
      
      return {
        'success': false,
        'message': e.message ?? 'Network error occurred',
      };
    } catch (e) {
      if (kDebugMode) {
        print('Sign Up Error: $e');
      }
      return {
        'success': false,
        'message': 'An unexpected error occurred',
      };
    }
  }

  // Sign In
  static Future<Map<String, dynamic>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final data = {
        'email': email,
        'password': password,
      };

      if (kDebugMode) {
        print('Sign In Request: $data');
      }

      final response = await postHttpNoAuth(Endpoints.signin, data);

      if (kDebugMode) {
        print('Sign In Response: ${response.data}');
      }

      if (response.statusCode == 200) {
        final responseData = response.data;
        
        if (responseData['success'] == true && responseData['data'] != null) {
          // Save tokens and user data
          final userData = responseData['data'];
          await appData.write(kKeyAccessToken, userData['access_token']);
          await appData.write(kKeyRefreshToken, userData['refresh_token']);
          await appData.write(kKeyUserId, userData['id'].toString());
          await appData.write(kKeyEmail, userData['email']);
          await appData.write(kKeyIsLoggedIn,true);
          if (userData['role'] != null) {
            await appData.write(kKeyRole, userData['role']);
          }
          
          // Update Dio with the new token
          DioSingleton.instance.update(userData['access_token']);
          
          return {
            'success': true,
            'message': responseData['message'] ?? 'Sign in successful',
            'data': userData,
          };
        } else {
          return {
            'success': false,
            'message': responseData['message'] ?? 'Sign in failed',
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
        print('Sign In DioException: ${e.message}');
        print('Response: ${e.response?.data}');
      }
      
      if (e.response != null && e.response?.data != null) {
        final errorData = e.response!.data;
        return {
          'success': false,
          'message': errorData['message'] ?? 'Sign in failed',
          'errors': errorData['errors'],
        };
      }
      
      return {
        'success': false,
        'message': e.message ?? 'Network error occurred',
      };
    } catch (e) {
      if (kDebugMode) {
        print('Sign In Error: $e');
      }
      return {
        'success': false,
        'message': 'An unexpected error occurred',
      };
    }
  }

  // Send OTP
  static Future<Map<String, dynamic>> sendOtp({
    required String email,
    required String purpose, // 'password_reset' or other purposes
  }) async {
    try {
      final data = {
        'email': email,
        'purpose': purpose,
      };

      if (kDebugMode) {
        print('Send OTP Request: $data');
      }

      final response = await postHttpNoAuth(Endpoints.sendOtp, data);

      if (kDebugMode) {
        print('Send OTP Response: ${response.data}');
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;
        
        if (responseData['success'] == true) {
          return {
            'success': true,
            'message': responseData['message'] ?? 'OTP sent successfully',
            'data': responseData['data'],
          };
        } else {
          return {
            'success': false,
            'message': responseData['message'] ?? 'Failed to send OTP',
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
        print('Send OTP DioException: ${e.message}');
        print('Response: ${e.response?.data}');
      }
      
      if (e.response != null && e.response?.data != null) {
        final errorData = e.response!.data;
        return {
          'success': false,
          'message': errorData['message'] ?? 'Failed to send OTP',
          'errors': errorData['errors'],
        };
      }
      
      return {
        'success': false,
        'message': e.message ?? 'Network error occurred',
      };
    } catch (e) {
      if (kDebugMode) {
        print('Send OTP Error: $e');
      }
      return {
        'success': false,
        'message': 'An unexpected error occurred',
      };
    }
  }

  // Sign Out
  static Future<Map<String, dynamic>> signOut() async {
    try {
      // Get refresh token from storage
      final refreshToken = appData.read(kKeyRefreshToken);
      
      if (refreshToken == null) {
        return {
          'success': false,
          'message': 'No refresh token found',
        };
      }

      final data = {
        'refresh_token': refreshToken,
      };

      if (kDebugMode) {
        print('Sign Out Request: $data');
      }

      final response = await postHttp(Endpoints.signout, data);

      if (kDebugMode) {
        print('Sign Out Response: ${response.data}');
      }

      if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 204) {
        // Clear all stored data
        await appData.remove(kKeyAccessToken);
        await appData.remove(kKeyRefreshToken);
        await appData.remove(kKeyUserId);
        await appData.remove(kKeyEmail);
        await appData.remove(kKeyIsLoggedIn);
        await appData.remove(kKeyRole);
        
        // Clear Dio token
        DioSingleton.instance.update('');
        
        final responseData = response.data;
        return {
          'success': true,
          'message': responseData?['message'] ?? 'Signed out successfully',
        };
      } else {
        return {
          'success': false,
          'message': 'Sign out failed',
        };
      }
    } on DioException catch (e) {
      if (kDebugMode) {
        print('Sign Out DioException: ${e.message}');
        print('Response: ${e.response?.data}');
      }
      
      // Even if API call fails, clear local data
      await appData.remove(kKeyAccessToken);
      await appData.remove(kKeyRefreshToken);
      await appData.remove(kKeyUserId);
      await appData.remove(kKeyEmail);
      await appData.remove(kKeyIsLoggedIn);
      await appData.remove(kKeyRole);
      DioSingleton.instance.update('');
      
      return {
        'success': true,
        'message': 'Signed out successfully',
      };
    } catch (e) {
      if (kDebugMode) {
        print('Sign Out Error: $e');
      }
      
      // Even if error occurs, clear local data
      await appData.remove(kKeyAccessToken);
      await appData.remove(kKeyRefreshToken);
      await appData.remove(kKeyUserId);
      await appData.remove(kKeyEmail);
      await appData.remove(kKeyIsLoggedIn);
      await appData.remove(kKeyRole);
      DioSingleton.instance.update('');
      
      return {
        'success': true,
        'message': 'Signed out successfully',
      };
    }
  }
}
