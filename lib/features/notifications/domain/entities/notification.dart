import 'package:equatable/equatable.dart';

/// Domain entity for notification - pure business object
class Notification extends Equatable {
  const Notification({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    this.type,
    this.relatedOrderId,
    this.relatedShopId,
    required this.isRead,
    this.readAt,
    required this.createdAt,
  });

  final String id;
  final String userId;
  final String title;
  final String message;
  final String? type;
  final String? relatedOrderId;
  final String? relatedShopId;
  final bool isRead;
  final DateTime? readAt;
  final DateTime createdAt;

  @override
  List<Object?> get props => [
        id,
        userId,
        title,
        message,
        type,
        relatedOrderId,
        relatedShopId,
        isRead,
        readAt,
        createdAt,
      ];
}
