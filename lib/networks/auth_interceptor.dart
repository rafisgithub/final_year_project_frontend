import 'package:dio/dio.dart';
import 'package:final_year_project_frontend/networks/token_storage.dart';
import 'package:final_year_project_frontend/networks/google_auth_service.dart';
import 'package:flutter/foundation.dart';

/// Dio Interceptor for automatic JWT token refresh
class AuthInterceptor extends Interceptor {
  final Dio dio;

  AuthInterceptor(this.dio);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Add JWT token to every request
    final token = await TokenStorage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    if (kDebugMode) {
      print('🌐 API Request: ${options.method} ${options.path}');
      if (token != null) {
        print('🔑 Token: ${token.substring(0, 20)}...');
      }
    }

    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Handle 401 Unauthorized errors (token expired)
    if (err.response?.statusCode == 401) {
      if (kDebugMode) {
        print('❌ 401 Unauthorized - Attempting token refresh...');
      }

      try {
        // Try to refresh the token
        final refreshed = await GoogleAuthService.refreshToken();

        if (refreshed) {
          // Retry the original request with new token
          final token = await TokenStorage.getAccessToken();
          final opts = err.requestOptions;
          opts.headers['Authorization'] = 'Bearer $token';

          if (kDebugMode) {
            print('✅ Token refreshed - Retrying request...');
          }

          final response = await dio.request(
            opts.path,
            data: opts.data,
            queryParameters: opts.queryParameters,
            options: Options(method: opts.method, headers: opts.headers),
          );

          return handler.resolve(response);
        } else {
          // Refresh failed - logout user
          if (kDebugMode) {
            print('❌ Token refresh failed - Logging out...');
          }
          await GoogleAuthService.signOut();
          // You might want to navigate to login screen here
          // NavigationService.navigateToReplacement('/login');
        }
      } catch (refreshError) {
        if (kDebugMode) {
          print('❌ Token refresh error: $refreshError');
        }
        await GoogleAuthService.signOut();
      }
    }

    return handler.next(err);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      print(
        '✅ API Response: ${response.statusCode} ${response.requestOptions.path}',
      );
    }
    return handler.next(response);
  }
}
