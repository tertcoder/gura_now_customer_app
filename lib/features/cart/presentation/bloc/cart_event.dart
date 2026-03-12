part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();
  @override
  List<Object?> get props => [];
}

class CartLoadRequested extends CartEvent {
  const CartLoadRequested();
}

class CartItemAdded extends CartEvent {
  const CartItemAdded(this.product, {this.quantity = 1});
  final Product product; // Product is imported in cart_bloc.dart
  final int quantity;
  @override
  List<Object?> get props => [product, quantity];
}

class CartItemRemoved extends CartEvent {
  const CartItemRemoved(this.productId);
  final String productId;
  @override
  List<Object?> get props => [productId];
}

class CartQuantityUpdated extends CartEvent {
  const CartQuantityUpdated(this.productId, this.quantity);
  final String productId;
  final int quantity;
  @override
  List<Object?> get props => [productId, quantity];
}

class CartCleared extends CartEvent {
  const CartCleared();
}
