import 'package:equatable/equatable.dart';

class ProductVariant extends Equatable {
  const ProductVariant({
    required this.type,
    required this.options,
  });

  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    return ProductVariant(
      type: json['type'] as String,
      options: (json['options'] as List).cast<String>(),
    );
  }
  final String type;
  final List<String> options;

  Map<String, dynamic> toJson() => {
        'type': type,
        'options': options,
      };

  @override
  List<Object?> get props => [type, options];
}

class Product extends Equatable {
  const Product({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    this.originalPrice,
    this.currency = 'BIF',
    this.imageUrl,
    this.images = const [],
    required this.shopId,
    this.shopName,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.stock = 0,
    this.isActive = true,
    this.variants = const [],
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      price: (json['price'] as num).toDouble(),
      originalPrice: json['original_price'] != null
          ? (json['original_price'] as num).toDouble()
          : null,
      currency: json['currency'] as String? ?? 'BIF',
      imageUrl: json['image_url'] as String?,
      images:
          json['images'] != null ? (json['images'] as List).cast<String>() : [],
      shopId: json['shop_id'] as String,
      shopName: json['shop_name'] as String?,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: json['review_count'] as int? ?? 0,
      stock: json['stock'] as int? ?? 0,
      isActive: json['is_active'] as bool? ?? true,
      variants: json['variants'] != null
          ? (json['variants'] as List)
              .map((v) => ProductVariant.fromJson(v as Map<String, dynamic>))
              .toList()
          : [],
    );
  }
  final String id;
  final String name;
  final String? description;
  final double price;
  final double? originalPrice;
  final String currency;
  final String? imageUrl;
  final List<String> images;
  final String shopId;
  final String? shopName;
  final double rating;
  final int reviewCount;
  final int stock;
  final bool isActive;
  final List<ProductVariant> variants;

  bool get hasDiscount => originalPrice != null && originalPrice! > price;

  int get discountPercentage {
    if (!hasDiscount) return 0;
    return (100 - (price / originalPrice! * 100)).round();
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'price': price,
        'original_price': originalPrice,
        'currency': currency,
        'image_url': imageUrl,
        'images': images,
        'shop_id': shopId,
        'shop_name': shopName,
        'rating': rating,
        'review_count': reviewCount,
        'stock': stock,
        'is_active': isActive,
        'variants': variants.map((v) => v.toJson()).toList(),
      };

  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    double? originalPrice,
    String? currency,
    String? imageUrl,
    List<String>? images,
    String? shopId,
    String? shopName,
    double? rating,
    int? reviewCount,
    int? stock,
    bool? isActive,
    List<ProductVariant>? variants,
  }) =>
      Product(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        price: price ?? this.price,
        originalPrice: originalPrice ?? this.originalPrice,
        currency: currency ?? this.currency,
        imageUrl: imageUrl ?? this.imageUrl,
        images: images ?? this.images,
        shopId: shopId ?? this.shopId,
        shopName: shopName ?? this.shopName,
        rating: rating ?? this.rating,
        reviewCount: reviewCount ?? this.reviewCount,
        stock: stock ?? this.stock,
        isActive: isActive ?? this.isActive,
        variants: variants ?? this.variants,
      );

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        price,
        originalPrice,
        currency,
        imageUrl,
        images,
        shopId,
        shopName,
        rating,
        reviewCount,
        stock,
        isActive,
        variants,
      ];
}
