import 'package:get_storage/get_storage.dart';
import 'dart:convert';

/// Service for managing JWT tokens and user data in local storage
class TokenStorage {
  static final GetStorage _storage = GetStorage();

  // Storage keys
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userDataKey = 'user_data';

  /// Save authentication tokens
  static Future<void> saveTokens({
    String? accessToken,
    String? refreshToken,
    Map<String, dynamic>? userData,
  }) async {
    if (accessToken != null) {
      await _storage.write(_accessTokenKey, accessToken);
    }
    if (refreshToken != null) {
      await _storage.write(_refreshTokenKey, refreshToken);
    }
    if (userData != null) {
      await _storage.write(_userDataKey, jsonEncode(userData));
    }
  }

  /// Get access token
  static Future<String?> getAccessToken() async {
    return _storage.read(_accessTokenKey);
  }

  /// Get refresh token
  static Future<String?> getRefreshToken() async {
    return _storage.read(_refreshTokenKey);
  }

  /// Get user data
  static Future<Map<String, dynamic>?> getUserData() async {
    final userDataString = _storage.read(_userDataKey);
    if (userDataString == null) return null;

    try {
      return jsonDecode(userDataString) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  /// Clear all tokens and user data (logout)
  static Future<void> clearTokens() async {
    await _storage.remove(_accessTokenKey);
    await _storage.remove(_refreshTokenKey);
    await _storage.remove(_userDataKey);
  }

  /// Check if user is authenticated
  static Future<bool> isAuthenticated() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }
}
