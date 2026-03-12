import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/platform_stats.dart';

/// Remote data source for admin operations.
class AdminRemoteDataSource {
  AdminRemoteDataSource(this._apiClient);
  final ApiClient _apiClient;

  /// Get platform statistics.
  Future<PlatformStats> getStats() async {
    final response = await _apiClient.get(ApiEndpoints.adminStats);
    return PlatformStats.fromJson(response);
  }

  /// Get paginated list of users.
  Future<Map<String, dynamic>> getUsers({
    int page = 1,
    int perPage = 20,
    String? role,
    bool? isActive,
    String? search,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'per_page': perPage,
    };
    if (role != null) queryParams['role'] = role;
    if (isActive != null) queryParams['is_active'] = isActive;
    if (search != null) queryParams['search'] = search;

    return await _apiClient.get(
      ApiEndpoints.adminUsers,
      queryParams: queryParams,
    );
  }

  /// Update user role.
  Future<Map<String, dynamic>> updateUserRole(
    String userId,
    String newRole,
  ) async {
    final endpoint = ApiEndpoints.replacePathParam(
      ApiEndpoints.adminUserRole,
      'user_id',
      userId,
    );
    return await _apiClient.patch(
      endpoint,
      body: {'role': newRole},
    );
  }

  /// Suspend a user.
  Future<Map<String, dynamic>> suspendUser(
    String userId, {
    String? suspendedUntil,
    String reason = 'Violation of terms of service',
  }) async {
    final endpoint = ApiEndpoints.replacePathParam(
      ApiEndpoints.adminUserSuspend,
      'user_id',
      userId,
    );
    return await _apiClient.post(
      endpoint,
      {
        'suspended_until': suspendedUntil,
        'reason': reason,
      },
    );
  }

  /// Unsuspend a user.
  Future<Map<String, dynamic>> unsuspendUser(String userId) async {
    final endpoint = ApiEndpoints.replacePathParam(
      ApiEndpoints.adminUserUnsuspend,
      'user_id',
      userId,
    );
    return await _apiClient.post(endpoint, {});
  }

  /// Get paginated list of shops.
  Future<Map<String, dynamic>> getShops({
    int page = 1,
    int perPage = 20,
    String? status,
    String? city,
    String? search,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'per_page': perPage,
    };
    if (status != null) queryParams['status'] = status;
    if (city != null) queryParams['city'] = city;
    if (search != null) queryParams['search'] = search;

    return await _apiClient.get(
      ApiEndpoints.adminShops,
      queryParams: queryParams,
    );
  }

  /// Update shop status.
  Future<Map<String, dynamic>> updateShopStatus(
    String shopId,
    String newStatus, {
    String? reason,
  }) async {
    final endpoint = ApiEndpoints.replacePathParam(
      ApiEndpoints.adminShopStatus,
      'shop_id',
      shopId,
    );
    return await _apiClient.patch(
      endpoint,
      body: {
        'status': newStatus,
        'reason': reason,
      },
    );
  }

  /// Get paginated list of orders.
  Future<Map<String, dynamic>> getOrders({
    int page = 1,
    int perPage = 20,
    String? status,
    String? paymentStatus,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'per_page': perPage,
    };
    if (status != null) queryParams['status'] = status;
    if (paymentStatus != null) queryParams['payment_status'] = paymentStatus;

    return await _apiClient.get(
      ApiEndpoints.adminOrders,
      queryParams: queryParams,
    );
  }

  /// Get paginated list of transactions.
  Future<Map<String, dynamic>> getTransactions({
    int page = 1,
    int perPage = 20,
    String? type,
    String? status,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'per_page': perPage,
    };
    if (type != null) queryParams['type'] = type;
    if (status != null) queryParams['status'] = status;

    return await _apiClient.get(
      ApiEndpoints.adminTransactions,
      queryParams: queryParams,
    );
  }
}
