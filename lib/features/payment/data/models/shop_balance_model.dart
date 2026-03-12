/// Shop balance model for Gura Now application.
library;

import 'package:equatable/equatable.dart';

/// Shop balance model matching backend ShopBalance.
class ShopBalanceModel extends Equatable {
  const ShopBalanceModel({
    required this.shopId,
    required this.shopName,
    required this.totalSales,
    required this.totalCommissions,
    required this.pendingOrdersValue,
    required this.availableBalance,
    required this.totalWithdrawn,
  });

  factory ShopBalanceModel.fromJson(Map<String, dynamic> json) =>
      ShopBalanceModel(
        shopId: json['shop_id'] as String,
        shopName: json['shop_name'] as String,
        totalSales: _parseDouble(json['total_sales']) ?? 0.0,
        totalCommissions: _parseDouble(json['total_commissions']) ?? 0.0,
        pendingOrdersValue: _parseDouble(json['pending_orders_value']) ?? 0.0,
        availableBalance: _parseDouble(json['available_balance']) ?? 0.0,
        totalWithdrawn: _parseDouble(json['total_withdrawn']) ?? 0.0,
      );

  /// Creates an empty balance model for initial state.
  factory ShopBalanceModel.empty(String shopId) => ShopBalanceModel(
        shopId: shopId,
        shopName: '',
        totalSales: 0,
        totalCommissions: 0,
        pendingOrdersValue: 0,
        availableBalance: 0,
        totalWithdrawn: 0,
      );
  final String shopId;
  final String shopName;
  final double totalSales;
  final double totalCommissions;
  final double pendingOrdersValue;
  final double availableBalance;
  final double totalWithdrawn;

  Map<String, dynamic> toJson() => {
        'shop_id': shopId,
        'shop_name': shopName,
        'total_sales': totalSales,
        'total_commissions': totalCommissions,
        'pending_orders_value': pendingOrdersValue,
        'available_balance': availableBalance,
        'total_withdrawn': totalWithdrawn,
      };

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  /// Get formatted total sales string.
  String get formattedTotalSales => '${totalSales.toStringAsFixed(0)} BIF';

  /// Get formatted available balance string.
  String get formattedAvailableBalance =>
      '${availableBalance.toStringAsFixed(0)} BIF';

  /// Get formatted commissions string.
  String get formattedCommissions =>
      '${totalCommissions.toStringAsFixed(0)} BIF';

  /// Get net earnings (total sales minus commissions).
  double get netEarnings => totalSales - totalCommissions;

  /// Get formatted net earnings string.
  String get formattedNetEarnings => '${netEarnings.toStringAsFixed(0)} BIF';

  @override
  List<Object?> get props => [
        shopId,
        totalSales,
        totalCommissions,
        availableBalance,
      ];
}
