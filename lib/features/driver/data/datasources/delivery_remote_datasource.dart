/// Delivery remote data source for Gura Now application.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/mock/mock_config.dart';
import '../../../../core/mock/mock_delivery_datasource.dart';
import '../../../../core/network/api_client.dart';
import '../models/delivery_model.dart';
import '../models/driver_stats_model.dart';

/// Abstract interface for delivery remote operations.
abstract class DeliveryRemoteDataSource {
  /// Get available deliveries for driver.
  Future<PaginatedAvailableDeliveries> getAvailableDeliveries({
    int page = 1,
    int perPage = 20,
  });

  /// Accept a delivery request.
  Future<DeliveryModel> acceptDelivery(String deliveryId);

  /// Confirm pickup of order.
  Future<DeliveryModel> confirmPickup(String deliveryId);

  /// Update driver location during delivery.
  Future<void> updateLocation(
    String deliveryId,
    LocationUpdateModel location,
  );

  /// Complete a delivery.
  Future<DeliveryModel> completeDelivery(String deliveryId);

  /// Get delivery tracking info (for customer).
  Future<DeliveryTrackingModel> getDeliveryTracking(String deliveryId);

  /// Customer confirms receiving delivery.
  Future<DeliveryModel> confirmReceived(String deliveryId);

  /// Get driver's delivery history.
  Future<PaginatedDeliveries> getDeliveryHistory({
    int page = 1,
    int perPage = 20,
  });

  /// Get driver statistics.
  Future<DriverStatsModel> getDriverStats();
}

/// Implementation of delivery remote data source.
class DeliveryRemoteDataSourceImpl implements DeliveryRemoteDataSource {
  DeliveryRemoteDataSourceImpl(this._apiClient);
  final ApiClient _apiClient;

  @override
  Future<PaginatedAvailableDeliveries> getAvailableDeliveries({
    int page = 1,
    int perPage = 20,
  }) async {
    final response = await _apiClient.get(
      ApiEndpoints.deliveriesAvailable,
      queryParams: {
        'page': page,
        'per_page': perPage,
      },
    );
    return PaginatedAvailableDeliveries.fromJson(response);
  }

  @override
  Future<DeliveryModel> acceptDelivery(String deliveryId) async {
    final endpoint = ApiEndpoints.replacePathParam(
      ApiEndpoints.deliveriesAccept,
      'delivery_id',
      deliveryId,
    );
    final response = await _apiClient.post(endpoint, {});
    return DeliveryModel.fromJson(response);
  }

  @override
  Future<DeliveryModel> confirmPickup(String deliveryId) async {
    final endpoint = ApiEndpoints.replacePathParam(
      ApiEndpoints.deliveriesPickup,
      'delivery_id',
      deliveryId,
    );
    final response = await _apiClient.patch(endpoint);
    return DeliveryModel.fromJson(response);
  }

  @override
  Future<void> updateLocation(
    String deliveryId,
    LocationUpdateModel location,
  ) async {
    final endpoint = ApiEndpoints.replacePathParam(
      ApiEndpoints.deliveriesLocation,
      'delivery_id',
      deliveryId,
    );
    await _apiClient.patch(endpoint, body: location.toJson());
  }

  @override
  Future<DeliveryModel> completeDelivery(String deliveryId) async {
    final endpoint = ApiEndpoints.replacePathParam(
      ApiEndpoints.deliveriesComplete,
      'delivery_id',
      deliveryId,
    );
    final response = await _apiClient.patch(endpoint);
    return DeliveryModel.fromJson(response);
  }

  @override
  Future<DeliveryTrackingModel> getDeliveryTracking(String deliveryId) async {
    final endpoint = ApiEndpoints.replacePathParam(
      ApiEndpoints.deliveriesTrack,
      'delivery_id',
      deliveryId,
    );
    final response = await _apiClient.get(endpoint);
    return DeliveryTrackingModel.fromJson(response);
  }

  @override
  Future<DeliveryModel> confirmReceived(String deliveryId) async {
    final endpoint = ApiEndpoints.replacePathParam(
      ApiEndpoints.deliveriesConfirmReceived,
      'delivery_id',
      deliveryId,
    );
    final response = await _apiClient.post(endpoint, {});
    return DeliveryModel.fromJson(response);
  }

  @override
  Future<PaginatedDeliveries> getDeliveryHistory({
    int page = 1,
    int perPage = 20,
  }) async {
    final response = await _apiClient.get(
      ApiEndpoints.deliveriesHistory,
      queryParams: {
        'page': page,
        'per_page': perPage,
      },
    );
    return PaginatedDeliveries.fromJson(response);
  }

  @override
  Future<DriverStatsModel> getDriverStats() async {
    // Note: This endpoint may need to be added to backend
    // For now, we use a stats endpoint if available
    final response = await _apiClient.get('/deliveries/stats');
    return DriverStatsModel.fromJson(response);
  }
}

/// Provider for delivery remote data source.
final deliveryRemoteDataSourceProvider =
    Provider<DeliveryRemoteDataSource>((ref) {
  // Use mock or real data source based on configuration
  if (useMockData) {
    logMockOperation('Using MockDeliveryRemoteDataSource');
    return MockDeliveryRemoteDataSource();
  } else {
    final apiClient = ref.watch(apiClientProvider);
    return DeliveryRemoteDataSourceImpl(apiClient);
  }
});
