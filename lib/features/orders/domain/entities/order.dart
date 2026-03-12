import 'package:equatable/equatable.dart';

enum OrderStatus {
  pending,
  confirmed,
  shipped,
  delivered,
  cancelled,
}

class OrderItem extends Equatable {
  const OrderItem({
    required this.productId,
    required this.quantity,
    required this.price,
    this.variant,
  });
  final String productId;
  final int quantity;
  final double price;
  final String? variant;

  @override
  List<Object?> get props => [productId, quantity, price, variant];
}

class Order extends Equatable {
  const Order({
    required this.id,
    required this.customerId,
    required this.shopId,
    required this.items,
    required this.status,
    required this.total,
    required this.createdAt,
    required this.updatedAt,
    required this.shippingAddress,
  });
  final String id;
  final String customerId;
  final String shopId;
  final List<OrderItem> items;
  final OrderStatus status;
  final double total;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String shippingAddress;

  @override
  List<Object?> get props => [
        id,
        customerId,
        shopId,
        items,
        status,
        total,
        createdAt,
        updatedAt,
        shippingAddress
      ];
}
