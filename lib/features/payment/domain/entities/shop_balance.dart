import 'package:equatable/equatable.dart';

/// Domain entity for shop balance - pure business object
class ShopBalance extends Equatable {
  const ShopBalance({
    required this.shopId,
    required this.shopName,
    required this.totalSales,
    required this.totalCommissions,
    required this.pendingOrdersValue,
    required this.availableBalance,
    required this.totalWithdrawn,
  });

  final String shopId;
  final String shopName;
  final double totalSales;
  final double totalCommissions;
  final double pendingOrdersValue;
  final double availableBalance;
  final double totalWithdrawn;

  @override
  List<Object?> get props => [
        shopId,
        totalSales,
        totalCommissions,
        availableBalance,
      ];
}
