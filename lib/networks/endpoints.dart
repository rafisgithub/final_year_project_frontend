// ignore_for_file: constant_identifier_names, unnecessary_string_interpolations

// Live setup
// const String url = "https://test.drinkwithme.click/api/";
// const String imageUrl = "https://test.drinkwithme.click";
// const String websocketUrl = "wss://test.drinkwithme.click/ws/chat/";

// Local setup

const String url = "http://172.16.200.94:8000/api/";
const String imageUrl = "http://172.16.200.94:8000/";
const String websocketUrl = "ws://172.16.200.94:8000/ws/chat/";

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
  static const String storeProductSearch = "store-product-search/";

  // search
  static const String searchProductAndSeller = "search-product-and-seller/";

  // products
  static const String productDetails = "product-details/";
  static const String productCategories = "product-categories/";
  static const String diseasedCategories = "diseased-categories/";
  static const String targetStages = "target-stages/";
  static const String addProduct = "add-product/";
  static const String sellerProducts = "seller-products/";
  static const String updateStock = "update-product-stock/";
  static const String updateProduct = "update-product/";
  static const String editProduct = "edit-product/";
  static const String productDelete = "product-delete/";
  static const String sellerOrders = "seller-orders/";
  static const String orderDetails = "order-details/";
  static const String customerOrders = "customer-orders/";
  static const String orderStatusUpdate = "order-status-update/";
  static const String allCustomers = "all-customers/";
  static const String addDues = "add-dues/";
  static const String duesFilter = "dues-filter/";
  static const String updateDuesStatus = "update-dues-status/";
  static const String updateDues = "update-dues/";
  static const String editDues = "edit-dues/";
  static const String deleteDues = "delete-dues/";

  // chat
  static const String chatList = "my-chat-list-users/";
  static const String chatSearch = "search-users/";
  static const String chatMessages = "messages/";
  static const String chatReaction = "messages/reaction/";
  static const String chatSendFile = "messages/send-file/";
  static const String chatMarkRead = "messages/mark-read/";
  static const String allUnreadMessagesCount = "all-unread-new-messages-count/";
  static const String getSingleUser = "get-single-user/";

  // cart
  static const String addToCart = "add-to-cart/";
  static const String cart = "cart/";
  static const String clearCart = "clear-cart/";
  static const String removeFromCart = "remove-from-cart/";
  static const String updateCartItem = "update-cart-item/";
  static const String placeOrder = "place-order/";

  // ai agent
  static const String detectDisease = "detect-disease/";
}
