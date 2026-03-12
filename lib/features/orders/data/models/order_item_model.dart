import '../../domain/entities/order.dart';

class OrderItemModel extends OrderItem {
  const OrderItemModel({
    required super.productId,
    required super.quantity,
    required super.price,
    super.variant,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) => OrderItemModel(
        productId: json['product_id'] as String,
        quantity: json['quantity'] as int,
        price: (json['price'] as num).toDouble(),
        variant: json['variant'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'product_id': productId,
        'quantity': quantity,
        'price': price,
        'variant': variant,
      };
}
