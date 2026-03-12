/// API Endpoints Configuration for Gura Now.
///
/// Base URL and all API routes for the FastAPI backend.
library;

import '../config/app_config.dart';

class ApiEndpoints {
  ApiEndpoints._();

  /// Base URL from environment configuration
  static String get baseUrl => AppConfig.baseUrl;

  // ==========================================================================
  // AUTHENTICATION ENDPOINTS
  // ==========================================================================
  static const String authRegister = '/auth/register';
  static const String authLogin = '/auth/login';
  static const String authRefresh = '/auth/refresh';
  static const String authLogout = '/auth/logout';
  static const String authMe = '/auth/me';
  static const String authChangePassword = '/auth/change-password';

  // ==========================================================================
  // USER ENDPOINTS
  // ==========================================================================
  static const String usersMe = '/users/me';
  static const String usersProfile = '/users/me';
  static const String usersGetById = '/users/{user_id}';
  static const String usersSuspend = '/users/{user_id}/suspend';

  // ==========================================================================
  // SHOP ENDPOINTS
  // ==========================================================================
  static const String shopsList = '/shops';
  static const String shopsCreate = '/shops';
  static const String shopsDetail = '/shops/{shop_id}';
  static const String shopsUpdate = '/shops/{shop_id}';
  static const String shopsDelete = '/shops/{shop_id}';

  // Shop Employees
  static const String shopEmployeesAdd = '/shops/{shop_id}/employees';
  static const String shopEmployeesList = '/shops/{shop_id}/employees';
  static const String shopEmployeesRemove =
      '/shops/{shop_id}/employees/{user_id}';

  // Shop Trusted Drivers
  static const String shopTrustedDriversAdd =
      '/shops/{shop_id}/trusted-drivers/{driver_id}';
  static const String shopTrustedDriversRemove =
      '/shops/{shop_id}/trusted-drivers/{driver_id}';
  static const String shopTrustedDriversList =
      '/shops/{shop_id}/trusted-drivers';

  // ==========================================================================
  // PRODUCT ENDPOINTS
  // ==========================================================================
  static const String productsList = '/products';
  static const String productsCreate = '/products';
  static const String productsDetail = '/products/{product_id}';
  static const String productsUpdate = '/products/{product_id}';
  static const String productsDelete = '/products/{product_id}';

  // Product Variants
  static const String productVariantsAdd = '/products/{product_id}/variants';
  static const String productVariantsList = '/products/{product_id}/variants';
  static const String productVariantsDelete =
      '/products/{product_id}/variants/{variant_id}';

  // ==========================================================================
  // ORDER ENDPOINTS
  // ==========================================================================
  static const String ordersCreate = '/orders';
  static const String ordersList = '/orders';
  static const String ordersDetail = '/orders/{order_id}';
  static const String ordersConfirmShop = '/orders/{order_id}/confirm-shop';
  static const String ordersConfirmCustomer =
      '/orders/{order_id}/confirm-customer';
  static const String ordersMyOrders = '/orders/my-orders';
  static const String ordersShopOrders = '/orders/shop-orders';
  static const String ordersInvoice = '/orders/{order_id}/invoice';

  // ==========================================================================
  // DELIVERY ENDPOINTS
  // ==========================================================================
  static const String deliveryList = '/deliveries';
  static const String deliveryDetail = '/deliveries/{delivery_id}';
  static const String deliveryAssign = '/deliveries/{delivery_id}/assign';
  static const String deliveryUpdate = '/deliveries/{delivery_id}';

  // ==========================================================================
  // PAYMENT ENDPOINTS
  // ==========================================================================
  static const String paymentsSubmitProof = '/payments/submit-proof';
  static const String paymentsVerify = '/payments/verify';
  static const String paymentsHistory = '/payments/history';

  // ==========================================================================
  // REVIEW ENDPOINTS
  // ==========================================================================
  static const String reviewsCreate = '/reviews';
  static const String reviewsList = '/reviews';
  static const String reviewsDetail = '/reviews/{review_id}';

  // ==========================================================================
  // ADMIN ENDPOINTS
  // ==========================================================================
  static const String adminStats = '/admin/stats';
  static const String adminUsers = '/admin/users';
  static const String adminUserRole = '/admin/users/{user_id}/role';
  static const String adminUserSuspend = '/admin/users/{user_id}/suspend';
  static const String adminUserUnsuspend = '/admin/users/{user_id}/unsuspend';
  static const String adminShops = '/admin/shops';
  static const String adminShopStatus = '/admin/shops/{shop_id}/status';
  static const String adminOrders = '/admin/orders';
  static const String adminTransactions = '/admin/transactions';

  // ==========================================================================
  // DELIVERY ENDPOINTS (Updated)
  // ==========================================================================
  static const String deliveriesAvailable = '/deliveries/available';
  static const String deliveriesAccept = '/deliveries/{delivery_id}/accept';
  static const String deliveriesPickup = '/deliveries/{delivery_id}/pickup';
  static const String deliveriesLocation = '/deliveries/{delivery_id}/location';
  static const String deliveriesComplete = '/deliveries/{delivery_id}/complete';
  static const String deliveriesTrack = '/deliveries/{delivery_id}/track';
  static const String deliveriesConfirmReceived =
      '/deliveries/{delivery_id}/confirm-received';
  static const String deliveriesHistory = '/deliveries/history';

  // ==========================================================================
  // PAYMENT ENDPOINTS (Updated)
  // ==========================================================================
  static const String paymentsProofs = '/payments/proofs';
  static const String paymentsProofDetail = '/payments/proofs/{proof_id}';
  static const String paymentsProofValidate =
      '/payments/proofs/{proof_id}/validate';
  static const String paymentsShopBalance = '/payments/shop-balance/{shop_id}';

  // ==========================================================================
  // REVIEW ENDPOINTS (Updated)
  // ==========================================================================
  static const String reviewsShop = '/reviews/shop/{shop_id}';
  static const String reviewsDriver = '/reviews/driver/{driver_id}';
  static const String reviewsMyReviews = '/reviews/my-reviews';
  static const String reviewsVisibility = '/reviews/{review_id}/visibility';

  // ==========================================================================
  // NOTIFICATION ENDPOINTS
  // ==========================================================================
  static const String notificationsList = '/notifications';
  static const String notificationsMarkRead =
      '/notifications/{notification_id}/read';
  static const String notificationsMarkAllRead = '/notifications/read-all';
  static const String notificationsFcmToken = '/notifications/fcm-token';

  // ==========================================================================
  // UTILITY ENDPOINTS
  // ==========================================================================
  static const String health = '/health';
  static const String info = '/info';
  static const String root = '/';

  /// Replace path parameters with actual values.
  ///
  /// Example: `replacePathParam(shopsDetail, 'shop_id', '123')` => `/shops/123`
  static String replacePathParam(
    String endpoint,
    String paramName,
    String paramValue,
  ) =>
      endpoint.replaceAll('{$paramName}', paramValue);

  /// Replace multiple path parameters at once.
  ///
  /// Example: `replacePathParams(orderDetail, {'order_id': '123'})` => `/orders/123`
  static String replacePathParams(
    String endpoint,
    Map<String, String> params,
  ) {
    var result = endpoint;
    params.forEach((key, value) {
      result = result.replaceAll('{$key}', value);
    });
    return result;
  }
}
