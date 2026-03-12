import 'package:equatable/equatable.dart';

class Shop extends Equatable {
  const Shop({
    required this.id,
    required this.name,
    this.description,
    this.logoUrl,
    this.deliveryScope,
    required this.type,
    this.rating = 0.0,
    this.totalReviews = 0,
  });
  final String id;
  final String name;
  final String? description;
  final String? logoUrl;
  final String? deliveryScope; // e.g., "Bujumbura", "National"
  final String type; // "Supermarket", "Pharmacy", etc.
  final double rating;
  final int totalReviews;

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        logoUrl,
        deliveryScope,
        type,
        rating,
        totalReviews
      ];
}
