part of 'cart_bloc.dart';

enum CartStatus { initial, loading, success, failure }

class CartState extends Equatable {
  const CartState({
    this.status = CartStatus.initial,
    this.items = const [],
    this.error,
  });

  final CartStatus status;
  final List<CartItemModel> items;
  final String? error;

  double get totalPrice => items.fold(0.0, (total, item) => total + item.totalPrice);
  int get itemCount => items.fold(0, (count, item) => count + item.quantity);

  @override
  List<Object?> get props => [status, items, error];

  CartState copyWith({
    CartStatus? status,
    List<CartItemModel>? items,
    String? error,
  }) {
    return CartState(
      status: status ?? this.status,
      items: items ?? this.items,
      error: error,
    );
  }
}
