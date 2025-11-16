import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '/helpers/di.dart';

import '../../constants/app_constants.dart';

import '../endpoints.dart';
import 'log.dart';

final class DioSingleton {
  static final DioSingleton _singleton = DioSingleton._internal();
  static CancelToken cancelToken = CancelToken();
  DioSingleton._internal();

  static DioSingleton get instance => _singleton;

  late Dio dio;

  void create() {
    BaseOptions options = BaseOptions(
      baseUrl: url,
      connectTimeout: const Duration(milliseconds: 100000),
      receiveTimeout: const Duration(milliseconds: 100000),
      headers: {
        NetworkConstants.ACCEPT: NetworkConstants.ACCEPT_TYPE,
        // NetworkConstants.ACCEPT_LANGUAGE:
        //     appData.read(kKeyCountryCode) ?? "pt",
        NetworkConstants.APP_KEY: NetworkConstants.APP_KEY_VALUE,
      },
    );
    dio = Dio(options)..interceptors.add(Logger());
  }

  void update(String auth) {
    if (kDebugMode) {
      print("Dio update");
    }
    
    Map<String, dynamic> headers = {
      NetworkConstants.ACCEPT: NetworkConstants.ACCEPT_TYPE,
      NetworkConstants.ACCEPT_LANGUAGE: appData.read(kKeyLanguage) ?? "pt",
      NetworkConstants.APP_KEY: NetworkConstants.APP_KEY_VALUE,
    };
    
    // Only add Authorization header if token is not empty
    if (auth.isNotEmpty) {
      headers[NetworkConstants.AUTHORIZATION] = "Bearer $auth";
    }
    
    BaseOptions options = BaseOptions(
      baseUrl: url,
      responseType: ResponseType.json,
      headers: headers,
      connectTimeout: const Duration(milliseconds: 100000),
      receiveTimeout: const Duration(milliseconds: 100000),
    );
    dio = Dio(options)..interceptors.add(Logger());
  }

  void updateLanguage(String countryCode) {
    if (kDebugMode) {
      print("Dio update $countryCode");
    }
    BaseOptions options = BaseOptions(
      baseUrl: url,
      responseType: ResponseType.json,
      headers: {
        NetworkConstants.ACCEPT: NetworkConstants.ACCEPT_TYPE,
        NetworkConstants.ACCEPT_LANGUAGE: countryCode,
        NetworkConstants.APP_KEY: NetworkConstants.APP_KEY_VALUE,
        NetworkConstants.AUTHORIZATION:
            "Bearer ${appData.read(kKeyAccessToken)}",
      },
      connectTimeout: const Duration(milliseconds: 100000),
      receiveTimeout: const Duration(milliseconds: 100000),
    );
    dio = Dio(options)..interceptors.add(Logger());
  }
}

Future<Response> postHttp(String path, [dynamic data]) =>
    DioSingleton.instance.dio.post(
      path,
      data: data,
      cancelToken: DioSingleton.cancelToken,
    );

// Post without Authorization header for sign-up, sign-in, send-otp
Future<Response> postHttpNoAuth(String path, [dynamic data]) =>
    DioSingleton.instance.dio.post(
      path,
      data: data,
      cancelToken: DioSingleton.cancelToken,
      options: Options(
        headers: {
          NetworkConstants.ACCEPT: NetworkConstants.ACCEPT_TYPE,
          NetworkConstants.APP_KEY: NetworkConstants.APP_KEY_VALUE,
        },
      ),
    );

Future<Response> putHttp(String path, [dynamic data]) =>
    DioSingleton.instance.dio
        .put(path, data: data, cancelToken: DioSingleton.cancelToken);

Future<Response> getHttp(String path, [dynamic data]) =>
    DioSingleton.instance.dio
        .get(path, cancelToken: DioSingleton.cancelToken, data: data);

Future<Response> deleteHttp(String path, [dynamic data]) =>
    DioSingleton.instance.dio
        .delete(path, data: data, cancelToken: DioSingleton.cancelToken);
