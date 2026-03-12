import 'package:equatable/equatable.dart';

/// Domain entity for delivery - pure business object
class Delivery extends Equatable {
  const Delivery({
    required this.id,
    required this.orderId,
    this.orderNumber,
    required this.shopId,
    this.shopName,
    this.driverId,
    this.driverName,
    required this.pickupAddress,
    this.pickupLatitude,
    this.pickupLongitude,
    this.pickupPhone,
    required this.deliveryAddress,
    this.deliveryLatitude,
    this.deliveryLongitude,
    this.deliveryPhone,
    this.estimatedDistanceKm,
    required this.deliveryFee,
    required this.status,
    this.acceptedAt,
    this.pickedUpAt,
    this.completedAt,
    this.driverConfirmedPickup = false,
    this.driverConfirmedDelivery = false,
    this.customerConfirmedDelivery = false,
    this.expiresAt,
    required this.createdAt,
  });

  final String id;
  final String orderId;
  final String? orderNumber;
  final String shopId;
  final String? shopName;
  final String? driverId;
  final String? driverName;
  final String pickupAddress;
  final double? pickupLatitude;
  final double? pickupLongitude;
  final String? pickupPhone;
  final String deliveryAddress;
  final double? deliveryLatitude;
  final double? deliveryLongitude;
  final String? deliveryPhone;
  final double? estimatedDistanceKm;
  final double deliveryFee;
  final String status;
  final DateTime? acceptedAt;
  final DateTime? pickedUpAt;
  final DateTime? completedAt;
  final bool driverConfirmedPickup;
  final bool driverConfirmedDelivery;
  final bool customerConfirmedDelivery;
  final DateTime? expiresAt;
  final DateTime createdAt;

  @override
  List<Object?> get props => [
        id,
        orderId,
        status,
        createdAt,
      ];
}

/// Domain entity for driver statistics
class DriverStats extends Equatable {
  const DriverStats({
    required this.driverId,
    required this.totalDeliveries,
    required this.successfulDeliveries,
    required this.completionRate,
    required this.averageRating,
    required this.totalEarnings,
    required this.earningsToday,
    required this.earningsThisWeek,
    required this.earningsThisMonth,
  });

  final String driverId;
  final int totalDeliveries;
  final int successfulDeliveries;
  final double completionRate;
  final double averageRating;
  final double totalEarnings;
  final double earningsToday;
  final double earningsThisWeek;
  final double earningsThisMonth;

  @override
  List<Object?> get props => [
        driverId,
        totalDeliveries,
        successfulDeliveries,
        completionRate,
        averageRating,
        totalEarnings,
      ];
}
