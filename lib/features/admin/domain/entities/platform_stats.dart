import 'package:equatable/equatable.dart';

/// Platform statistics entity - pure business object
class PlatformStats extends Equatable {
  const PlatformStats({
    required this.totalUsers,
    required this.totalCustomers,
    required this.totalDrivers,
    required this.totalShopOwners,
    required this.newUsersToday,
    required this.newUsersThisWeek,
    required this.newUsersThisMonth,
    required this.totalShops,
    required this.activeShops,
    required this.pendingShops,
    required this.suspendedShops,
    required this.totalProducts,
    required this.activeProducts,
    required this.totalOrders,
    required this.ordersToday,
    required this.ordersThisWeek,
    required this.ordersThisMonth,
    required this.pendingOrders,
    required this.inTransitOrders,
    required this.deliveredOrders,
    required this.cancelledOrders,
    required this.totalRevenue,
    required this.revenueToday,
    required this.revenueThisWeek,
    required this.revenueThisMonth,
    required this.totalCommissions,
    required this.pendingPayouts,
    required this.totalReviews,
    required this.averageShopRating,
  });

  factory PlatformStats.fromJson(Map<String, dynamic> json) {
    return PlatformStats(
      totalUsers: json['total_users'] as int? ?? 0,
      totalCustomers: json['total_customers'] as int? ?? 0,
      totalDrivers: json['total_drivers'] as int? ?? 0,
      totalShopOwners: json['total_shop_owners'] as int? ?? 0,
      newUsersToday: json['new_users_today'] as int? ?? 0,
      newUsersThisWeek: json['new_users_this_week'] as int? ?? 0,
      newUsersThisMonth: json['new_users_this_month'] as int? ?? 0,
      totalShops: json['total_shops'] as int? ?? 0,
      activeShops: json['active_shops'] as int? ?? 0,
      pendingShops: json['pending_shops'] as int? ?? 0,
      suspendedShops: json['suspended_shops'] as int? ?? 0,
      totalProducts: json['total_products'] as int? ?? 0,
      activeProducts: json['active_products'] as int? ?? 0,
      totalOrders: json['total_orders'] as int? ?? 0,
      ordersToday: json['orders_today'] as int? ?? 0,
      ordersThisWeek: json['orders_this_week'] as int? ?? 0,
      ordersThisMonth: json['orders_this_month'] as int? ?? 0,
      pendingOrders: json['pending_orders'] as int? ?? 0,
      inTransitOrders: json['in_transit_orders'] as int? ?? 0,
      deliveredOrders: json['delivered_orders'] as int? ?? 0,
      cancelledOrders: json['cancelled_orders'] as int? ?? 0,
      totalRevenue: _parseDouble(json['total_revenue']),
      revenueToday: _parseDouble(json['revenue_today']),
      revenueThisWeek: _parseDouble(json['revenue_this_week']),
      revenueThisMonth: _parseDouble(json['revenue_this_month']),
      totalCommissions: _parseDouble(json['total_commissions']),
      pendingPayouts: _parseDouble(json['pending_payouts']),
      totalReviews: json['total_reviews'] as int? ?? 0,
      averageShopRating: _parseDouble(json['average_shop_rating']),
    );
  }
  final int totalUsers;
  final int totalCustomers;
  final int totalDrivers;
  final int totalShopOwners;
  final int newUsersToday;
  final int newUsersThisWeek;
  final int newUsersThisMonth;
  final int totalShops;
  final int activeShops;
  final int pendingShops;
  final int suspendedShops;
  final int totalProducts;
  final int activeProducts;
  final int totalOrders;
  final int ordersToday;
  final int ordersThisWeek;
  final int ordersThisMonth;
  final int pendingOrders;
  final int inTransitOrders;
  final int deliveredOrders;
  final int cancelledOrders;
  final double totalRevenue;
  final double revenueToday;
  final double revenueThisWeek;
  final double revenueThisMonth;
  final double totalCommissions;
  final double pendingPayouts;
  final int totalReviews;
  final double averageShopRating;

  static double _parseDouble(dynamic value) {
    if (value == null) return 0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0;
  }

  @override
  List<Object?> get props => [
        totalUsers,
        totalCustomers,
        totalDrivers,
        totalShopOwners,
        totalShops,
        totalOrders,
        totalRevenue,
      ];
}
