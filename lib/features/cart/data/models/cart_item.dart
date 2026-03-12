import '../../domain/entities/cart_item.dart' as domain;
import '../../../shop/domain/entities/product.dart';

/// Data model for cart item - extends domain entity, adds serialization
class CartItemModel extends domain.CartItemEntity {
  const CartItemModel({
    required super.product,
    super.quantity = 1,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      product: Product.fromJson(
        Map<String, dynamic>.from(json['product'] as Map),
      ),
      quantity: json['quantity'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        'product': product.toJson(),
        'quantity': quantity,
      };

  /// Entity → Model (for caching)
  factory CartItemModel.fromEntity(domain.CartItemEntity entity) {
    return CartItemModel(
      product: entity.product,
      quantity: entity.quantity,
    );
  }
}

/// Alias for backward compatibility
@Deprecated('Use CartItemModel instead')
typedef CartItem = CartItemModel;
