import 'package:equatable/equatable.dart';
import 'cart_item.dart';

/// Domain entity for cart - pure business object
class CartEntity extends Equatable {
  const CartEntity({
    this.items = const [],
  });

  final List<CartItemEntity> items;

  double get totalPrice =>
      items.fold(0.0, (total, item) => total + item.totalPrice);
  
  int get itemCount => items.fold(0, (count, item) => count + item.quantity);

  CartEntity copyWith({
    List<CartItemEntity>? items,
  }) =>
      CartEntity(
        items: items ?? this.items,
      );

  @override
  List<Object?> get props => [items];
}
