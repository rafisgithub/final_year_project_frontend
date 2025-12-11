import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:final_year_project_frontend/networks/dio/dio.dart';
import 'package:final_year_project_frontend/networks/endpoints.dart';
import 'package:final_year_project_frontend/networks/token_storage.dart';

/// Google Authentication Service - Pure Google Sign-In without Firebase
class GoogleAuthService {
  // Configure Google Sign-In (NO clientId needed for Android - uses google-services.json)
  // For iOS, you'll need to add the reversed client ID in Info.plist
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  /// Sign in with Google and authenticate with Django backend
  static Future<Map<String, dynamic>> signInWithGoogle() async {
    try {
      if (kDebugMode) {
        print('========================================');
        print('🔑 STARTING GOOGLE SIGN-IN');
        print('========================================');
      }

      // 1. Sign in with Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User cancelled the sign-in
        if (kDebugMode) {
          print('❌ User cancelled Google Sign-In');
        }
        return {'success': false, 'message': 'Sign in cancelled'};
      }

      // 2. Get authentication details
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Get the Google OAuth access token
      final String? accessToken = googleAuth.accessToken;

      if (accessToken == null) {
        if (kDebugMode) {
          print('❌ Failed to get access token');
        }
        return {'success': false, 'message': 'Failed to get access token'};
      }

      if (kDebugMode) {
        print('========================================');
        print('✅ GOOGLE SIGN-IN SUCCESS');
        print('========================================');
        print('User Email: ${googleUser.email}');
        print('User Display Name: ${googleUser.displayName}');
        print('User ID: ${googleUser.id}');
        print('Photo URL: ${googleUser.photoUrl}');
        print('========================================');
        print('📋 FULL ACCESS TOKEN (Copy for Postman):');
        print('========================================');
        print(accessToken);
        print('========================================');
        print('Token Length: ${accessToken.length} characters');
        print('First 50 chars: ${accessToken.substring(0, 50)}...');
        print('========================================');
      }

      // 3. Send access token to Django backend
      final result = await _authenticateWithBackend(
        accessToken: accessToken,
        googleUser: googleUser,
      );

      return result;
    } catch (e) {
      if (kDebugMode) {
        print('========================================');
        print('❌ GOOGLE SIGN-IN ERROR');
        print('========================================');
        print('Error: $e');
        print('Error Type: ${e.runtimeType}');
        print('========================================');
      }

      // Sign out from Google on error
      await _googleSignIn.signOut();

      return {
        'success': false,
        'message': 'Google sign in failed: ${e.toString()}',
      };
    }
  }

  /// Authenticate with Django backend using Google access token
  static Future<Map<String, dynamic>> _authenticateWithBackend({
    required String accessToken,
    required GoogleSignInAccount googleUser,
  }) async {
    try {
      // Prepare data for backend - only access_token required
      final data = {'access_token': accessToken};

      if (kDebugMode) {
        print('========================================');
        print('🌐 SENDING TO DJANGO BACKEND');
        print('========================================');
        print('Endpoint: ${Endpoints.googleAuth}');
        print('Method: POST');
        print(
          'Payload: {"access_token": "${accessToken.substring(0, 50)}..."}',
        );
        print('========================================');
      }

      // Send to Django backend
      final response = await postHttpNoAuth(Endpoints.googleAuth, data);

      if (kDebugMode) {
        print('========================================');
        print('📥 BACKEND RESPONSE');
        print('========================================');
        print('Status Code: ${response.statusCode}');
        print('Response Data: ${response.data}');
        print('========================================');
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;

        if (responseData['success'] == true) {
          final backendData = responseData['data'] ?? responseData;

          // Extract JWT tokens from backend response
          // Your backend returns: access_token and refresh_token
          final jwtAccessToken =
              backendData['access_token'] ?? backendData['access'];
          final jwtRefreshToken =
              backendData['refresh_token'] ?? backendData['refresh'];

          if (jwtAccessToken == null) {
            throw Exception('Backend did not return access token');
          }

          // Extract user data from backend
          final userId = backendData['id']?.toString();
          final userRole = backendData['role'];
          final isSeller = backendData['is_seller'];
          final userEmail = backendData['email'] ?? googleUser.email;

          // Save tokens and user data
          await TokenStorage.saveTokens(
            accessToken: jwtAccessToken,
            refreshToken: jwtRefreshToken,
            userData: {
              'id': userId,
              'email': userEmail,
              'name': googleUser.displayName,
              'photoUrl': googleUser.photoUrl,
              'googleId': googleUser.id,
              'role': userRole,
              'is_seller': isSeller,
              ...backendData, // Include all other backend data
            },
          );

          // Update Dio with the new JWT token
          DioSingleton.instance.update(jwtAccessToken);

          if (kDebugMode) {
            print('========================================');
            print('✅ AUTHENTICATION SUCCESSFUL');
            print('========================================');
            print('User ID: $userId');
            print('Email: $userEmail');
            print('Role: $userRole');
            print('Is Seller: $isSeller');
            print('JWT Access Token saved (${jwtAccessToken.length} chars)');
            print(
              'JWT Refresh Token saved (${jwtRefreshToken?.length ?? 0} chars)',
            );
            print('User data saved to local storage');
            print('========================================');
          }

          return {
            'success': true,
            'message': responseData['message'] ?? 'Google sign in successful',
            'data': backendData,
          };
        } else {
          // Backend returned success: false
          await _googleSignIn.signOut();

          return {
            'success': false,
            'message':
                responseData['message'] ?? 'Backend authentication failed',
          };
        }
      } else {
        // Non-200 status code
        await _googleSignIn.signOut();

        return {
          'success': false,
          'message': 'Server error: ${response.statusCode}',
        };
      }
    } catch (e) {
      if (kDebugMode) {
        print('========================================');
        print('❌ BACKEND AUTHENTICATION ERROR');
        print('========================================');
        print('Error: $e');
        print('========================================');
      }

      // Sign out from Google on error
      await _googleSignIn.signOut();

      return {
        'success': false,
        'message': 'Backend authentication failed: ${e.toString()}',
      };
    }
  }

  /// Refresh JWT token using refresh token
  static Future<bool> refreshToken() async {
    try {
      final refreshToken = await TokenStorage.getRefreshToken();
      if (refreshToken == null) {
        if (kDebugMode) {
          print('No refresh token available');
        }
        return false;
      }

      // Call your Django token refresh endpoint
      final response = await postHttpNoAuth(
        'token/refresh/', // Update this to match your Django endpoint
        {'refresh': refreshToken},
      );

      if (response.statusCode == 200) {
        final newAccessToken = response.data['access'];
        await TokenStorage.saveTokens(accessToken: newAccessToken);
        DioSingleton.instance.update(newAccessToken);

        if (kDebugMode) {
          print('✅ Token refreshed successfully');
        }
        return true;
      }

      return false;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Token refresh error: $e');
      }
      return false;
    }
  }

  /// Sign out from Google and clear local data
  static Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await TokenStorage.clearTokens();

      if (kDebugMode) {
        print('========================================');
        print('✅ SIGNED OUT SUCCESSFULLY');
        print('========================================');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Google Sign Out Error: $e');
      }
    }
  }

  /// Get current user data
  static Future<Map<String, dynamic>?> getCurrentUser() async {
    return await TokenStorage.getUserData();
  }

  /// Check if user is authenticated
  static Future<bool> isAuthenticated() async {
    return await TokenStorage.isAuthenticated();
  }
}
