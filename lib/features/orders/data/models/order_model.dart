import '../../domain/entities/order.dart';
import 'order_item_model.dart';

class OrderModel extends Order {
  const OrderModel({
    required super.id,
    required super.customerId,
    required super.shopId,
    required List<OrderItemModel> super.items,
    required super.status,
    required super.total,
    required super.createdAt,
    required super.updatedAt,
    required super.shippingAddress,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        id: json['id'] as String,
        customerId: json['customer_id'] as String,
        shopId: json['shop_id'] as String,
        items: (json['items'] as List<dynamic>)
            .map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        status: _mapStatus(json['status'] as String),
        total: (json['total_amount'] as num).toDouble(),
        createdAt: DateTime.parse(json['created_at'] as String),
        updatedAt: DateTime.parse(json['updated_at'] as String),
        shippingAddress: json['shipping_address'] as String,
      );

  static OrderStatus _mapStatus(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return OrderStatus.pending;
      case 'confirmed':
        return OrderStatus.confirmed;
      case 'shipped':
        return OrderStatus.shipped;
      case 'delivered':
        return OrderStatus.delivered;
      case 'cancelled':
        return OrderStatus.cancelled;
      default:
        return OrderStatus.pending;
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'customer_id': customerId,
        'shop_id': shopId,
        'items': items.map((e) => (e as OrderItemModel).toJson()).toList(),
        'status': status.name,
        'total_amount': total,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
        'shipping_address': shippingAddress,
      };
}
