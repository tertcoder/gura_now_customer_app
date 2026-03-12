/// Mock implementation of Admin Remote Data Source for testing without backend.
library;

import '../../features/admin/data/datasources/admin_remote_datasource.dart';
import '../../features/admin/domain/entities/platform_stats.dart';
import '../../features/orders/domain/entities/order.dart';
import 'mock_data.dart';

/// Mock admin data source that uses local mock data instead of API calls.
class MockAdminRemoteDataSource extends AdminRemoteDataSource {
  MockAdminRemoteDataSource() : super(null as dynamic);

  @override
  Future<PlatformStats> getStats() async {
    // Simulate network delay
    await MockData.simulateDelay();

    if (!MockData.isLoggedIn) {
      throw Exception('Not authenticated');
    }

    if (MockData.currentUserRole != 'admin') {
      throw Exception('Not authorized');
    }

    // Calculate stats from mock data
    final totalUsers = MockData.users.length;
    final totalCustomers =
        MockData.users.where((u) => u.role == 'customer').length;
    final totalDrivers = MockData.users.where((u) => u.role == 'driver').length;
    final totalShopOwners =
        MockData.users.where((u) => u.role == 'shop_owner').length;

    final totalOrders = MockData.orders.length;
    final pendingOrders =
        MockData.orders.where((o) => o.status == OrderStatus.pending).length;
    final deliveredOrders =
        MockData.orders.where((o) => o.status == OrderStatus.delivered).length;
    final cancelledOrders =
        MockData.orders.where((o) => o.status == OrderStatus.cancelled).length;
    final inTransitOrders =
        MockData.orders.where((o) => o.status == OrderStatus.shipped).length;

    final totalRevenue = MockData.orders
        .where((o) => o.status == OrderStatus.delivered)
        .fold<double>(0, (sum, order) => sum + order.total);

    return PlatformStats(
      totalUsers: totalUsers,
      totalCustomers: totalCustomers,
      totalDrivers: totalDrivers,
      totalShopOwners: totalShopOwners,
      newUsersToday: 3,
      newUsersThisWeek: 12,
      newUsersThisMonth: 45,
      totalShops: MockData.shops.length,
      activeShops: MockData.shops.length,
      pendingShops: 0,
      suspendedShops: 0,
      totalProducts: 150,
      activeProducts: 145,
      totalOrders: totalOrders,
      ordersToday: 5,
      ordersThisWeek: 23,
      ordersThisMonth: 87,
      pendingOrders: pendingOrders,
      inTransitOrders: inTransitOrders,
      deliveredOrders: deliveredOrders,
      cancelledOrders: cancelledOrders,
      totalRevenue: totalRevenue,
      revenueToday: 125000,
      revenueThisWeek: 650000,
      revenueThisMonth: 2850000,
      totalCommissions: totalRevenue * 0.05,
      pendingPayouts: 50000,
      totalReviews: 234,
      averageShopRating: 4.5,
    );
  }

  @override
  Future<Map<String, dynamic>> getUsers({
    int page = 1,
    int perPage = 20,
    String? role,
    bool? isActive,
    String? search,
  }) async {
    // Simulate network delay
    await MockData.simulateDelay();

    if (!MockData.isLoggedIn) {
      throw Exception('Not authenticated');
    }

    if (MockData.currentUserRole != 'admin') {
      throw Exception('Not authorized');
    }

    var filtered = MockData.users;

    // Apply filters
    if (role != null) {
      filtered = filtered.where((u) => u.role == role).toList();
    }
    if (isActive != null) {
      filtered = filtered.where((u) => u.isActive == isActive).toList();
    }
    if (search != null && search.isNotEmpty) {
      filtered = filtered
          .where((u) =>
              u.fullName?.toLowerCase().contains(search.toLowerCase()) ==
                  true ||
              u.phoneNumber.toLowerCase().contains(search.toLowerCase()) ||
              u.email?.toLowerCase().contains(search.toLowerCase()) == true)
          .toList();
    }

    // Paginate
    final start = (page - 1) * perPage;
    final paginatedItems = filtered.skip(start).take(perPage).toList();
    final totalPages = (filtered.length / perPage).ceil();

    return {
      'items': paginatedItems.map((u) => u.toJson()).toList(),
      'total': filtered.length,
      'page': page,
      'per_page': perPage,
      'pages': totalPages,
    };
  }

  @override
  Future<Map<String, dynamic>> updateUserRole(
    String userId,
    String newRole,
  ) async {
    // Simulate network delay
    await MockData.simulateDelay();

    if (!MockData.isLoggedIn) {
      throw Exception('Not authenticated');
    }

    if (MockData.currentUserRole != 'admin') {
      throw Exception('Not authorized');
    }

    final userIndex = MockData.users.indexWhere((u) => u.id == userId);
    if (userIndex == -1) {
      throw Exception('User not found');
    }

    final user = MockData.users[userIndex];
    final updatedUser = user.copyWith(role: newRole);
    MockData.users[userIndex] = updatedUser;

    return updatedUser.toJson();
  }

  @override
  Future<Map<String, dynamic>> suspendUser(
    String userId, {
    String? suspendedUntil,
    String reason = 'Violation of terms of service',
  }) async {
    // Simulate network delay
    await MockData.simulateDelay();

    if (!MockData.isLoggedIn) {
      throw Exception('Not authenticated');
    }

    if (MockData.currentUserRole != 'admin') {
      throw Exception('Not authorized');
    }

    final userIndex = MockData.users.indexWhere((u) => u.id == userId);
    if (userIndex == -1) {
      throw Exception('User not found');
    }

    final user = MockData.users[userIndex];
    final updatedUser = user.copyWith(isActive: false);
    MockData.users[userIndex] = updatedUser;

    return updatedUser.toJson();
  }

  @override
  Future<Map<String, dynamic>> unsuspendUser(String userId) async {
    // Simulate network delay
    await MockData.simulateDelay();

    if (!MockData.isLoggedIn) {
      throw Exception('Not authenticated');
    }

    if (MockData.currentUserRole != 'admin') {
      throw Exception('Not authorized');
    }

    final userIndex = MockData.users.indexWhere((u) => u.id == userId);
    if (userIndex == -1) {
      throw Exception('User not found');
    }

    final user = MockData.users[userIndex];
    final updatedUser = user.copyWith(isActive: true);
    MockData.users[userIndex] = updatedUser;

    return updatedUser.toJson();
  }

  @override
  Future<Map<String, dynamic>> getShops({
    int page = 1,
    int perPage = 20,
    String? status,
    String? city,
    String? search,
  }) async {
    // Simulate network delay
    await MockData.simulateDelay();

    if (!MockData.isLoggedIn) {
      throw Exception('Not authenticated');
    }

    if (MockData.currentUserRole != 'admin') {
      throw Exception('Not authorized');
    }

    var filtered = MockData.shops;

    // Apply filters
    if (search != null && search.isNotEmpty) {
      filtered = filtered
          .where((s) => s.name.toLowerCase().contains(search.toLowerCase()))
          .toList();
    }

    // Paginate
    final start = (page - 1) * perPage;
    final paginatedItems = filtered.skip(start).take(perPage).toList();
    final totalPages = (filtered.length / perPage).ceil();

    return {
      'items': paginatedItems.map((s) => s.toJson()).toList(),
      'total': filtered.length,
      'page': page,
      'per_page': perPage,
      'pages': totalPages,
    };
  }

  @override
  Future<Map<String, dynamic>> updateShopStatus(
    String shopId,
    String newStatus, {
    String? reason,
  }) async {
    // Simulate network delay
    await MockData.simulateDelay();

    if (!MockData.isLoggedIn) {
      throw Exception('Not authenticated');
    }

    if (MockData.currentUserRole != 'admin') {
      throw Exception('Not authorized');
    }

    final shop = MockData.getShopById(shopId);
    if (shop == null) {
      throw Exception('Shop not found');
    }

    return shop.toJson();
  }

  @override
  Future<Map<String, dynamic>> getOrders({
    int page = 1,
    int perPage = 20,
    String? status,
    String? paymentStatus,
  }) async {
    // Simulate network delay
    await MockData.simulateDelay();

    if (!MockData.isLoggedIn) {
      throw Exception('Not authenticated');
    }

    if (MockData.currentUserRole != 'admin') {
      throw Exception('Not authorized');
    }

    var filtered = MockData.orders;

    // Apply filters
    if (status != null) {
      filtered = filtered.where((o) => o.status.name == status).toList();
    }

    // Paginate
    final start = (page - 1) * perPage;
    final paginatedItems = filtered.skip(start).take(perPage).toList();
    final totalPages = (filtered.length / perPage).ceil();

    return {
      'items': paginatedItems.map((o) => o.toJson()).toList(),
      'total': filtered.length,
      'page': page,
      'per_page': perPage,
      'pages': totalPages,
    };
  }

  @override
  Future<Map<String, dynamic>> getTransactions({
    int page = 1,
    int perPage = 20,
    String? type,
    String? status,
  }) async {
    // Simulate network delay
    await MockData.simulateDelay();

    if (!MockData.isLoggedIn) {
      throw Exception('Not authenticated');
    }

    if (MockData.currentUserRole != 'admin') {
      throw Exception('Not authorized');
    }

    // Return mock transactions
    return {
      'items': [],
      'total': 0,
      'page': page,
      'per_page': perPage,
      'pages': 0,
    };
  }
}
