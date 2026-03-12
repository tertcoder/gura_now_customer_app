/// Notification model for Gura Now application.
library;

import 'package:equatable/equatable.dart';

/// Notification model matching backend NotificationResponse.
class NotificationModel extends Equatable {
  const NotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.isRead,
    required this.createdAt,
    this.type,
    this.relatedOrderId,
    this.relatedShopId,
    this.readAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        id: json['id'] as String,
        userId: json['user_id'] as String,
        title: json['title'] as String,
        message: json['message'] as String,
        type: json['type'] as String?,
        relatedOrderId: json['related_order_id'] as String?,
        relatedShopId: json['related_shop_id'] as String?,
        isRead: json['is_read'] as bool? ?? false,
        readAt: _parseDateTime(json['read_at']),
        createdAt: DateTime.parse(json['created_at'] as String),
      );
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

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'title': title,
        'message': message,
        'type': type,
        'related_order_id': relatedOrderId,
        'related_shop_id': relatedShopId,
        'is_read': isRead,
        'read_at': readAt?.toIso8601String(),
        'created_at': createdAt.toIso8601String(),
      };

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  /// Create a copy with isRead set to true.
  NotificationModel markAsRead() => NotificationModel(
        id: id,
        userId: userId,
        title: title,
        message: message,
        type: type,
        relatedOrderId: relatedOrderId,
        relatedShopId: relatedShopId,
        isRead: true,
        readAt: DateTime.now(),
        createdAt: createdAt,
      );

  /// Check if notification is of type info.
  bool get isInfo => type == 'info' || type == null;

  /// Check if notification is of type success.
  bool get isSuccess => type == 'success';

  /// Check if notification is of type warning.
  bool get isWarning => type == 'warning';

  /// Check if notification is of type error.
  bool get isError => type == 'error';

  @override
  List<Object?> get props => [id, userId, isRead, createdAt];
}

/// FCM token model matching backend FCMTokenResponse.
class FCMTokenModel extends Equatable {
  const FCMTokenModel({
    required this.id,
    required this.userId,
    required this.fcmToken,
    required this.isActive,
    required this.createdAt,
    required this.lastUsedAt,
    this.deviceType,
    this.deviceName,
  });

  factory FCMTokenModel.fromJson(Map<String, dynamic> json) => FCMTokenModel(
        id: json['id'] as String,
        userId: json['user_id'] as String,
        fcmToken: json['fcm_token'] as String,
        deviceType: json['device_type'] as String?,
        deviceName: json['device_name'] as String?,
        isActive: json['is_active'] as bool? ?? true,
        createdAt: DateTime.parse(json['created_at'] as String),
        lastUsedAt: DateTime.parse(json['last_used_at'] as String),
      );
  final String id;
  final String userId;
  final String fcmToken;
  final String? deviceType;
  final String? deviceName;
  final bool isActive;
  final DateTime createdAt;
  final DateTime lastUsedAt;

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'fcm_token': fcmToken,
        'device_type': deviceType,
        'device_name': deviceName,
        'is_active': isActive,
        'created_at': createdAt.toIso8601String(),
        'last_used_at': lastUsedAt.toIso8601String(),
      };

  @override
  List<Object?> get props => [id, userId, fcmToken, isActive];
}

/// Request model for creating FCM token.
class FCMTokenCreateRequest {
  const FCMTokenCreateRequest({
    required this.fcmToken,
    this.deviceType,
    this.deviceName,
  });
  final String fcmToken;
  final String? deviceType;
  final String? deviceName;

  Map<String, dynamic> toJson() => {
        'fcm_token': fcmToken,
        if (deviceType != null) 'device_type': deviceType,
        if (deviceName != null) 'device_name': deviceName,
      };
}

/// Unread count response.
class UnreadCountResponse {
  const UnreadCountResponse({required this.count});

  factory UnreadCountResponse.fromJson(Map<String, dynamic> json) =>
      UnreadCountResponse(count: json['count'] as int? ?? 0);
  final int count;
}

/// Mark all as read response.
class MarkAllReadResponse {
  const MarkAllReadResponse({required this.markedRead});

  factory MarkAllReadResponse.fromJson(Map<String, dynamic> json) =>
      MarkAllReadResponse(markedRead: json['marked_read'] as int? ?? 0);
  final int markedRead;
}
