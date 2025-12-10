// ignore_for_file: constant_identifier_names, unnecessary_string_interpolations

// const String url = "https://test.drinkwithme.click/api/";
const String url = "http://172.16.200.94:8000/api/";

// const String imageUrl = "https://test.drinkwithme.click/";
const String imageUrl = "http://172.16.200.94:8000";
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
  static const String signup = "signup/";
  static const String signin = "signin/";
  static const String sendOtp = "send-otp/";
  static const String resendOtp = "resend-otp/";
  static const String verifyOtp = "verify-otp/";
  static const String resetPassword = "reset-password/";
  static const String signout = "signout/";

  static const String googleAuth = "google-auth/";

  // profile
  static const String profileGet = "profile-get/";
  static const String avatarUpdate = "avatar-update/";
  static const String switchRole = "switch-role/";
  static const String profileUpdate = "profile-update/";

  // advertisements
  static const String advertisements = "advertisements/";

  // stores
  static const String storeList = "store-list/";
  static const String storeDetails = "store-details/";
  static const String storeProducts = "store-products/";

  // search
  static const String searchProductAndSeller = "search-product-and-seller/";

  // products
  static const String productDetails = "product-details/";
}
