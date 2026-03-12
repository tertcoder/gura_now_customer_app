import '../../domain/entities/shop.dart';

class ShopModel extends Shop {
  const ShopModel({
    required super.id,
    required super.name,
    super.description,
    super.logoUrl,
    super.deliveryScope,
    required super.type,
    super.rating,
    super.totalReviews,
  });

  factory ShopModel.fromJson(Map<String, dynamic> json) => ShopModel(
        id: json['id'] as String,
        name: json['name'] as String,
        description: json['description'] as String?,
        logoUrl: json['image_url']
            as String?, // Mapping 'image_url' from backend to 'logoUrl'
        deliveryScope: json['delivery_scope'] as String?,
        // Backend might return 'shop_type' via a join or included field.
        // For now assume top level or default.
        type: json['category_id']?.toString() ?? 'General',
        rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
        totalReviews: json['total_reviews'] as int? ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'image_url': logoUrl,
        'delivery_scope': deliveryScope,
        'category_id': type,
        'rating': rating,
        'total_reviews': totalReviews,
      };

  Shop toEntity() => Shop(
        id: id,
        name: name,
        description: description,
        logoUrl: logoUrl,
        deliveryScope: deliveryScope,
        type: type,
        rating: rating,
        totalReviews: totalReviews,
      );
}
