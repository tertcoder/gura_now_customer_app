/// Driver statistics model for Gura Now application.
library;

import 'package:equatable/equatable.dart';

/// Driver statistics model matching backend DriverStats.
class DriverStatsModel extends Equatable {
  const DriverStatsModel({
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

  factory DriverStatsModel.fromJson(Map<String, dynamic> json) =>
      DriverStatsModel(
        driverId: json['driver_id'] as String,
        totalDeliveries: json['total_deliveries'] as int? ?? 0,
        successfulDeliveries: json['successful_deliveries'] as int? ?? 0,
        completionRate: _parseDouble(json['completion_rate']) ?? 0.0,
        averageRating: _parseDouble(json['average_rating']) ?? 0.0,
        totalEarnings: _parseDouble(json['total_earnings']) ?? 0.0,
        earningsToday: _parseDouble(json['earnings_today']) ?? 0.0,
        earningsThisWeek: _parseDouble(json['earnings_this_week']) ?? 0.0,
        earningsThisMonth: _parseDouble(json['earnings_this_month']) ?? 0.0,
      );

  /// Creates an empty stats model for initial state.
  factory DriverStatsModel.empty(String driverId) => DriverStatsModel(
        driverId: driverId,
        totalDeliveries: 0,
        successfulDeliveries: 0,
        completionRate: 0,
        averageRating: 0,
        totalEarnings: 0,
        earningsToday: 0,
        earningsThisWeek: 0,
        earningsThisMonth: 0,
      );
  final String driverId;
  final int totalDeliveries;
  final int successfulDeliveries;
  final double completionRate;
  final double averageRating;
  final double totalEarnings;
  final double earningsToday;
  final double earningsThisWeek;
  final double earningsThisMonth;

  Map<String, dynamic> toJson() => {
        'driver_id': driverId,
        'total_deliveries': totalDeliveries,
        'successful_deliveries': successfulDeliveries,
        'completion_rate': completionRate,
        'average_rating': averageRating,
        'total_earnings': totalEarnings,
        'earnings_today': earningsToday,
        'earnings_this_week': earningsThisWeek,
        'earnings_this_month': earningsThisMonth,
      };

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

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

/// Location update data for driver GPS tracking.
class LocationUpdateModel {
  const LocationUpdateModel({
    required this.latitude,
    required this.longitude,
    this.heading,
    this.speed,
  });
  final double latitude;
  final double longitude;
  final double? heading;
  final double? speed;

  Map<String, dynamic> toJson() => {
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        if (heading != null) 'heading': heading,
        if (speed != null) 'speed': speed,
      };
}
