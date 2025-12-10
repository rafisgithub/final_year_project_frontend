import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:final_year_project_frontend/constants/app_constants.dart';
import 'package:final_year_project_frontend/helpers/di.dart';
import 'package:final_year_project_frontend/networks/dio/dio.dart';
import 'package:final_year_project_frontend/networks/endpoints.dart';

class GoogleAuthService {
  static final GoogleSignIn _googleSignIn = GoogleSignIn();
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Sign in with Google and authenticate with backend
  static Future<Map<String, dynamic>> signInWithGoogle() async {
    try {
      // Trigger the Google Sign-In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User cancelled the sign-in
        return {'success': false, 'message': 'Sign in cancelled'};
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      // Get the Firebase ID token (access token)
      final String? accessToken = await userCredential.user?.getIdToken();

      if (accessToken == null) {
        return {'success': false, 'message': 'Failed to get access token'};
      }

      if (kDebugMode) {
        print('========================================');
        print('🔑 GOOGLE SIGN-IN SUCCESS');
        print('========================================');
        print('User Email: ${userCredential.user?.email}');
        print('User Display Name: ${userCredential.user?.displayName}');
        print('User ID: ${userCredential.user?.uid}');
        print('----------------------------------------');
        print('📱 FIREBASE ACCESS TOKEN (ID Token):');
        print(accessToken);
        print('----------------------------------------');
        print('Token Length: ${accessToken.length} characters');
        print('========================================');
      }

      // Call backend API with the access token
      final result = await _authenticateWithBackend(accessToken);

      return result;
    } catch (e) {
      if (kDebugMode) {
        print('Google Sign In Error: $e');
      }

      // Sign out from Google and Firebase on error
      await _googleSignIn.signOut();
      await _auth.signOut();

      return {
        'success': false,
        'message': 'Google sign in failed: ${e.toString()}',
      };
    }
  }

  /// Authenticate with backend using Firebase access token
  static Future<Map<String, dynamic>> _authenticateWithBackend(
    String accessToken,
  ) async {
    try {
      final data = {'access_token': accessToken};

      if (kDebugMode) {
        print('========================================');
        print('🌐 SENDING TO BACKEND API');
        print('========================================');
        print('Endpoint: ${Endpoints.googleAuth}');
        print('Method: POST');
        print('Payload:');
        print('  access_token: ${accessToken.substring(0, 50)}...');
        print('  (Full token length: ${accessToken.length} chars)');
        print('========================================');
      }

      final response = await postHttpNoAuth(Endpoints.googleAuth, data);

      if (kDebugMode) {
        print('========================================');
        print('📥 BACKEND API RESPONSE');
        print('========================================');
        print('Status Code: ${response.statusCode}');
        print('Response Data: ${response.data}');
        print('========================================');
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
          await appData.write(kKeyIsLoggedIn, true);
          if (userData['role'] != null) {
            await appData.write(kKeyRole, userData['role']);
          }

          // Update Dio with the new token
          DioSingleton.instance.update(userData['access_token']);

          return {
            'success': true,
            'message': responseData['message'] ?? 'Google sign in successful',
            'data': userData,
          };
        } else {
          // Sign out from Google and Firebase on backend failure
          await _googleSignIn.signOut();
          await _auth.signOut();

          return {
            'success': false,
            'message':
                responseData['message'] ?? 'Backend authentication failed',
          };
        }
      } else {
        // Sign out from Google and Firebase on error
        await _googleSignIn.signOut();
        await _auth.signOut();

        return {
          'success': false,
          'message': 'Server error: ${response.statusCode}',
        };
      }
    } catch (e) {
      if (kDebugMode) {
        print('Backend Auth Error: $e');
      }

      // Sign out from Google and Firebase on error
      await _googleSignIn.signOut();
      await _auth.signOut();

      return {
        'success': false,
        'message': 'Backend authentication failed: ${e.toString()}',
      };
    }
  }

  /// Sign out from Google
  static Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (e) {
      if (kDebugMode) {
        print('Google Sign Out Error: $e');
      }
    }
  }
}
