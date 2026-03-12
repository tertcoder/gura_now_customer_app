import '../../domain/entities/cart.dart' as domain;
import 'cart_item.dart';

/// Data model for cart state - extends domain entity, adds serialization
class CartStateModel extends domain.CartEntity {
  const CartStateModel({
    super.items = const [],
  });

  factory CartStateModel.fromJson(Map<String, dynamic> json) {
    return CartStateModel(
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => CartItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'items': items.map((item) => (item as CartItemModel).toJson()).toList(),
      };

  /// Entity → Model (for caching)
  factory CartStateModel.fromEntity(domain.CartEntity entity) {
    return CartStateModel(
      items: entity.items
          .map((item) => CartItemModel.fromEntity(item))
          .toList(),
    );
  }
}

/// Alias for backward compatibility
@Deprecated('Use CartStateModel instead')
typedef CartState = CartStateModel;
