import 'package:equatable/equatable.dart';
import '../../../shop/domain/entities/product.dart';

/// Domain entity for cart item - pure business object
class CartItemEntity extends Equatable {
  const CartItemEntity({
    required this.product,
    this.quantity = 1,
  });

  final Product product;
  final int quantity;

  double get totalPrice => product.price * quantity;

  CartItemEntity copyWith({
    Product? product,
    int? quantity,
  }) =>
      CartItemEntity(
        product: product ?? this.product,
        quantity: quantity ?? this.quantity,
      );

  @override
  List<Object?> get props => [product, quantity];
}
