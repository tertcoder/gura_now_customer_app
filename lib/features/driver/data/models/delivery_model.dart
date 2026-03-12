/// Delivery models for Gura Now application.
library;

import 'package:equatable/equatable.dart';

/// Delivery request model matching backend DeliveryRequestResponse.
class DeliveryModel extends Equatable {
  const DeliveryModel({
    required this.id,
    required this.orderId,
    required this.shopId,
    required this.pickupAddress,
    required this.deliveryAddress,
    required this.deliveryFee,
    required this.status,
    required this.createdAt,
    this.orderNumber,
    this.shopName,
    this.driverId,
    this.driverName,
    this.pickupLatitude,
    this.pickupLongitude,
    this.pickupPhone,
    this.deliveryLatitude,
    this.deliveryLongitude,
    this.deliveryPhone,
    this.estimatedDistanceKm,
    this.acceptedAt,
    this.pickedUpAt,
    this.completedAt,
    this.driverConfirmedPickup = false,
    this.driverConfirmedDelivery = false,
    this.customerConfirmedDelivery = false,
    this.expiresAt,
  });

  factory DeliveryModel.fromJson(Map<String, dynamic> json) => DeliveryModel(
        id: json['id'] as String,
        orderId: json['order_id'] as String,
        orderNumber: json['order_number'] as String?,
        shopId: json['shop_id'] as String,
        shopName: json['shop_name'] as String?,
        driverId: json['driver_id'] as String?,
        driverName: json['driver_name'] as String?,
        pickupAddress: json['pickup_address'] as String,
        pickupLatitude: _parseDouble(json['pickup_latitude']),
        pickupLongitude: _parseDouble(json['pickup_longitude']),
        pickupPhone: json['pickup_phone'] as String?,
        deliveryAddress: json['delivery_address'] as String,
        deliveryLatitude: _parseDouble(json['delivery_latitude']),
        deliveryLongitude: _parseDouble(json['delivery_longitude']),
        deliveryPhone: json['delivery_phone'] as String?,
        estimatedDistanceKm: _parseDouble(json['estimated_distance_km']),
        deliveryFee: _parseDouble(json['delivery_fee']) ?? 0.0,
        status: json['status'] as String,
        acceptedAt: _parseDateTime(json['accepted_at']),
        pickedUpAt: _parseDateTime(json['picked_up_at']),
        completedAt: _parseDateTime(json['completed_at']),
        driverConfirmedPickup:
            json['driver_confirmed_pickup'] as bool? ?? false,
        driverConfirmedDelivery:
            json['driver_confirmed_delivery'] as bool? ?? false,
        customerConfirmedDelivery:
            json['customer_confirmed_delivery'] as bool? ?? false,
        expiresAt: _parseDateTime(json['expires_at']),
        createdAt: DateTime.parse(json['created_at'] as String),
      );
  final String id;
  final String orderId;
  final String? orderNumber;
  final String shopId;
  final String? shopName;
  final String? driverId;
  final String? driverName;

  // Pickup
  final String pickupAddress;
  final double? pickupLatitude;
  final double? pickupLongitude;
  final String? pickupPhone;

  // Delivery
  final String deliveryAddress;
  final double? deliveryLatitude;
  final double? deliveryLongitude;
  final String? deliveryPhone;

  // Info
  final double? estimatedDistanceKm;
  final double deliveryFee;

  // Status
  final String status;
  final DateTime? acceptedAt;
  final DateTime? pickedUpAt;
  final DateTime? completedAt;

  // Confirmations
  final bool driverConfirmedPickup;
  final bool driverConfirmedDelivery;
  final bool customerConfirmedDelivery;

  final DateTime? expiresAt;
  final DateTime createdAt;

  Map<String, dynamic> toJson() => {
        'id': id,
        'order_id': orderId,
        'order_number': orderNumber,
        'shop_id': shopId,
        'shop_name': shopName,
        'driver_id': driverId,
        'driver_name': driverName,
        'pickup_address': pickupAddress,
        'pickup_latitude': pickupLatitude,
        'pickup_longitude': pickupLongitude,
        'pickup_phone': pickupPhone,
        'delivery_address': deliveryAddress,
        'delivery_latitude': deliveryLatitude,
        'delivery_longitude': deliveryLongitude,
        'delivery_phone': deliveryPhone,
        'estimated_distance_km': estimatedDistanceKm,
        'delivery_fee': deliveryFee,
        'status': status,
        'accepted_at': acceptedAt?.toIso8601String(),
        'picked_up_at': pickedUpAt?.toIso8601String(),
        'completed_at': completedAt?.toIso8601String(),
        'driver_confirmed_pickup': driverConfirmedPickup,
        'driver_confirmed_delivery': driverConfirmedDelivery,
        'customer_confirmed_delivery': customerConfirmedDelivery,
        'expires_at': expiresAt?.toIso8601String(),
        'created_at': createdAt.toIso8601String(),
      };

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  @override
  List<Object?> get props => [
        id,
        orderId,
        status,
        createdAt,
      ];
}

/// Available delivery model for driver listing.
class AvailableDeliveryModel extends Equatable {
  const AvailableDeliveryModel({
    required this.id,
    required this.orderId,
    required this.shopName,
    required this.shopAddress,
    required this.deliveryFee,
    required this.createdAt,
    this.pickupLatitude,
    this.pickupLongitude,
    this.deliveryLatitude,
    this.deliveryLongitude,
    this.estimatedDistanceKm,
    this.expiresAt,
  });

  factory AvailableDeliveryModel.fromJson(Map<String, dynamic> json) =>
      AvailableDeliveryModel(
        id: json['id'] as String,
        orderId: json['order_id'] as String,
        shopName: json['shop_name'] as String,
        shopAddress: json['shop_address'] as String,
        pickupLatitude: DeliveryModel._parseDouble(json['pickup_latitude']),
        pickupLongitude: DeliveryModel._parseDouble(json['pickup_longitude']),
        deliveryLatitude: DeliveryModel._parseDouble(json['delivery_latitude']),
        deliveryLongitude:
            DeliveryModel._parseDouble(json['delivery_longitude']),
        estimatedDistanceKm:
            DeliveryModel._parseDouble(json['estimated_distance_km']),
        deliveryFee: DeliveryModel._parseDouble(json['delivery_fee']) ?? 0.0,
        createdAt: DateTime.parse(json['created_at'] as String),
        expiresAt: DeliveryModel._parseDateTime(json['expires_at']),
      );
  final String id;
  final String orderId;
  final String shopName;
  final String shopAddress;
  final double? pickupLatitude;
  final double? pickupLongitude;
  final double? deliveryLatitude;
  final double? deliveryLongitude;
  final double? estimatedDistanceKm;
  final double deliveryFee;
  final DateTime createdAt;
  final DateTime? expiresAt;

  @override
  List<Object?> get props => [id, orderId, shopName];
}

/// Delivery tracking model for customer view.
class DeliveryTrackingModel extends Equatable {
  const DeliveryTrackingModel({
    required this.deliveryId,
    required this.orderId,
    required this.status,
    this.driverName,
    this.driverPhone,
    this.driverPhoto,
    this.vehicleType,
    this.vehiclePlate,
    this.currentLatitude,
    this.currentLongitude,
    this.lastLocationUpdate,
    this.pickupLatitude,
    this.pickupLongitude,
    this.deliveryLatitude,
    this.deliveryLongitude,
    this.estimatedArrivalMinutes,
    this.acceptedAt,
    this.pickedUpAt,
    this.estimatedDeliveryAt,
  });

  factory DeliveryTrackingModel.fromJson(Map<String, dynamic> json) =>
      DeliveryTrackingModel(
        deliveryId: json['delivery_id'] as String,
        orderId: json['order_id'] as String,
        status: json['status'] as String,
        driverName: json['driver_name'] as String?,
        driverPhone: json['driver_phone'] as String?,
        driverPhoto: json['driver_photo'] as String?,
        vehicleType: json['vehicle_type'] as String?,
        vehiclePlate: json['vehicle_plate'] as String?,
        currentLatitude: DeliveryModel._parseDouble(json['current_latitude']),
        currentLongitude: DeliveryModel._parseDouble(json['current_longitude']),
        lastLocationUpdate:
            DeliveryModel._parseDateTime(json['last_location_update']),
        pickupLatitude: DeliveryModel._parseDouble(json['pickup_latitude']),
        pickupLongitude: DeliveryModel._parseDouble(json['pickup_longitude']),
        deliveryLatitude: DeliveryModel._parseDouble(json['delivery_latitude']),
        deliveryLongitude:
            DeliveryModel._parseDouble(json['delivery_longitude']),
        estimatedArrivalMinutes: json['estimated_arrival_minutes'] as int?,
        acceptedAt: DeliveryModel._parseDateTime(json['accepted_at']),
        pickedUpAt: DeliveryModel._parseDateTime(json['picked_up_at']),
        estimatedDeliveryAt:
            DeliveryModel._parseDateTime(json['estimated_delivery_at']),
      );
  final String deliveryId;
  final String orderId;
  final String status;
  final String? driverName;
  final String? driverPhone;
  final String? driverPhoto;
  final String? vehicleType;
  final String? vehiclePlate;
  final double? currentLatitude;
  final double? currentLongitude;
  final DateTime? lastLocationUpdate;
  final double? pickupLatitude;
  final double? pickupLongitude;
  final double? deliveryLatitude;
  final double? deliveryLongitude;
  final int? estimatedArrivalMinutes;
  final DateTime? acceptedAt;
  final DateTime? pickedUpAt;
  final DateTime? estimatedDeliveryAt;

  @override
  List<Object?> get props => [deliveryId, orderId, status];
}

/// Paginated deliveries response.
class PaginatedDeliveries {
  const PaginatedDeliveries({
    required this.items,
    required this.total,
    required this.page,
    required this.perPage,
    required this.pages,
  });

  factory PaginatedDeliveries.fromJson(Map<String, dynamic> json) =>
      PaginatedDeliveries(
        items: (json['items'] as List<dynamic>)
            .map((e) => DeliveryModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        total: json['total'] as int,
        page: json['page'] as int,
        perPage: json['per_page'] as int,
        pages: json['pages'] as int,
      );
  final List<DeliveryModel> items;
  final int total;
  final int page;
  final int perPage;
  final int pages;
}

/// Paginated available deliveries response.
class PaginatedAvailableDeliveries {
  const PaginatedAvailableDeliveries({
    required this.items,
    required this.total,
    required this.page,
    required this.perPage,
    required this.pages,
  });

  factory PaginatedAvailableDeliveries.fromJson(Map<String, dynamic> json) =>
      PaginatedAvailableDeliveries(
        items: (json['items'] as List<dynamic>)
            .map((e) =>
                AvailableDeliveryModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        total: json['total'] as int,
        page: json['page'] as int,
        perPage: json['per_page'] as int,
        pages: json['pages'] as int,
      );
  final List<AvailableDeliveryModel> items;
  final int total;
  final int page;
  final int perPage;
  final int pages;
}
