// ignore_for_file: constant_identifier_names, unnecessary_string_interpolations

const String url = "http://172.16.200.94:8000/api/";

const String imageUrl = "http://172.16.200.94:8000/api/";
// String imageUrl = String.fromEnvironment("IMAGE_URL");

final class NetworkConstants {
  NetworkConstants._();
  static const ACCEPT = "Accept";
  static const APP_KEY = "App-Key";
  static const ACCEPT_LANGUAGE = "Accept-Language";
  static const ACCEPT_LANGUAGE_VALUE = "pt";
  static const APP_KEY_VALUE = String.fromEnvironment("APP_KEY_VALUE");
  static const ACCEPT_TYPE = "application/json";
  static const AUTHORIZATION = "Authorization";
  static const CONTENT_TYPE = "content-Type";
}

final class Endpoints {
  Endpoints._();

  // auth
}
