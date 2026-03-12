/// Mock implementation of Delivery Remote Data Source for testing without backend.
library;

import '../../features/driver/data/datasources/delivery_remote_datasource.dart';
import '../../features/driver/data/models/delivery_model.dart';
import '../../features/driver/data/models/driver_stats_model.dart';
import 'mock_data.dart';

/// Mock delivery data source that uses local mock data instead of API calls.
class MockDeliveryRemoteDataSource implements DeliveryRemoteDataSource {
  @override
  Future<PaginatedAvailableDeliveries> getAvailableDeliveries({
    int page = 1,
    int perPage = 20,
  }) async {
    // Simulate network delay
    await MockData.simulateDelay();

    if (!MockData.isLoggedIn) {
      throw Exception('Not authenticated');
    }

    // Only drivers can see available deliveries
    if (MockData.currentUserRole != 'driver') {
      throw Exception('Not authorized');
    }

    // Paginate
    final start = (page - 1) * perPage;
    final paginatedItems =
        MockData.availableDeliveries.skip(start).take(perPage).toList();
    final totalPages = (MockData.availableDeliveries.length / perPage).ceil();

    return PaginatedAvailableDeliveries(
      items: paginatedItems,
      total: MockData.availableDeliveries.length,
      page: page,
      perPage: perPage,
      pages: totalPages,
    );
  }

  @override
  Future<DeliveryModel> acceptDelivery(String deliveryId) async {
    // Simulate network delay
    await MockData.simulateDelay();

    if (!MockData.isLoggedIn) {
      throw Exception('Not authenticated');
    }

    // Find in available deliveries
    final availableIndex =
        MockData.availableDeliveries.indexWhere((d) => d.id == deliveryId);

    if (availableIndex == -1) {
      throw Exception('Delivery not found or already accepted');
    }

    final available = MockData.availableDeliveries[availableIndex];

    // Convert to full delivery model
    final delivery = DeliveryModel(
      id: available.id,
      orderId: available.orderId,
      orderNumber:
          'ORD-${available.orderId.substring(available.orderId.length - 3)}',
      shopId: 'shop-1',
      shopName: available.shopName,
      driverId: MockData.currentUserId,
      driverName: 'Current Driver',
      pickupAddress: available.shopAddress,
      pickupLatitude: available.pickupLatitude,
      pickupLongitude: available.pickupLongitude,
      deliveryAddress: 'Customer Address',
      deliveryLatitude: available.deliveryLatitude,
      deliveryLongitude: available.deliveryLongitude,
      estimatedDistanceKm: available.estimatedDistanceKm,
      deliveryFee: available.deliveryFee,
      status: 'accepted',
      acceptedAt: DateTime.now(),
      createdAt: available.createdAt,
    );

    // Remove from available and add to deliveries
    MockData.availableDeliveries.removeAt(availableIndex);
    MockData.deliveries.add(delivery);

    return delivery;
  }

  @override
  Future<DeliveryModel> confirmPickup(String deliveryId) async {
    // Simulate network delay
    await MockData.simulateDelay();

    if (!MockData.isLoggedIn) {
      throw Exception('Not authenticated');
    }

    final deliveryIndex =
        MockData.deliveries.indexWhere((d) => d.id == deliveryId);

    if (deliveryIndex == -1) {
      throw Exception('Delivery not found');
    }

    final delivery = MockData.deliveries[deliveryIndex];

    // Update delivery
    final updatedDelivery = DeliveryModel(
      id: delivery.id,
      orderId: delivery.orderId,
      orderNumber: delivery.orderNumber,
      shopId: delivery.shopId,
      shopName: delivery.shopName,
      driverId: delivery.driverId,
      driverName: delivery.driverName,
      pickupAddress: delivery.pickupAddress,
      pickupLatitude: delivery.pickupLatitude,
      pickupLongitude: delivery.pickupLongitude,
      pickupPhone: delivery.pickupPhone,
      deliveryAddress: delivery.deliveryAddress,
      deliveryLatitude: delivery.deliveryLatitude,
      deliveryLongitude: delivery.deliveryLongitude,
      deliveryPhone: delivery.deliveryPhone,
      estimatedDistanceKm: delivery.estimatedDistanceKm,
      deliveryFee: delivery.deliveryFee,
      status: 'in_transit',
      acceptedAt: delivery.acceptedAt,
      pickedUpAt: DateTime.now(),
      driverConfirmedPickup: true,
      createdAt: delivery.createdAt,
    );

    MockData.deliveries[deliveryIndex] = updatedDelivery;

    return updatedDelivery;
  }

  @override
  Future<void> updateLocation(
    String deliveryId,
    LocationUpdateModel location,
  ) async {
    // Simulate network delay
    await MockData.simulateDelay(milliseconds: 100);

    if (!MockData.isLoggedIn) {
      throw Exception('Not authenticated');
    }

    // In mock mode, just simulate location update
    // No actual state change needed
  }

  @override
  Future<DeliveryModel> completeDelivery(String deliveryId) async {
    // Simulate network delay
    await MockData.simulateDelay();

    if (!MockData.isLoggedIn) {
      throw Exception('Not authenticated');
    }

    final deliveryIndex =
        MockData.deliveries.indexWhere((d) => d.id == deliveryId);

    if (deliveryIndex == -1) {
      throw Exception('Delivery not found');
    }

    final delivery = MockData.deliveries[deliveryIndex];

    // Update delivery
    final updatedDelivery = DeliveryModel(
      id: delivery.id,
      orderId: delivery.orderId,
      orderNumber: delivery.orderNumber,
      shopId: delivery.shopId,
      shopName: delivery.shopName,
      driverId: delivery.driverId,
      driverName: delivery.driverName,
      pickupAddress: delivery.pickupAddress,
      pickupLatitude: delivery.pickupLatitude,
      pickupLongitude: delivery.pickupLongitude,
      pickupPhone: delivery.pickupPhone,
      deliveryAddress: delivery.deliveryAddress,
      deliveryLatitude: delivery.deliveryLatitude,
      deliveryLongitude: delivery.deliveryLongitude,
      deliveryPhone: delivery.deliveryPhone,
      estimatedDistanceKm: delivery.estimatedDistanceKm,
      deliveryFee: delivery.deliveryFee,
      status: 'completed',
      acceptedAt: delivery.acceptedAt,
      pickedUpAt: delivery.pickedUpAt,
      completedAt: DateTime.now(),
      driverConfirmedPickup: delivery.driverConfirmedPickup,
      driverConfirmedDelivery: true,
      createdAt: delivery.createdAt,
    );

    MockData.deliveries[deliveryIndex] = updatedDelivery;

    return updatedDelivery;
  }

  @override
  Future<DeliveryTrackingModel> getDeliveryTracking(String deliveryId) async {
    // Simulate network delay
    await MockData.simulateDelay();

    final delivery = MockData.getDeliveryById(deliveryId);

    if (delivery == null) {
      throw Exception('Delivery not found');
    }

    return DeliveryTrackingModel(
      deliveryId: delivery.id,
      orderId: delivery.orderId,
      status: delivery.status,
      driverName: delivery.driverName,
      driverPhone: delivery.driverId != null ? '+250788345678' : null,
      vehicleType: 'Motorcycle',
      vehiclePlate: 'RAD 123 A',
      currentLatitude: delivery.pickupLatitude,
      currentLongitude: delivery.pickupLongitude,
      lastLocationUpdate: DateTime.now(),
      pickupLatitude: delivery.pickupLatitude,
      pickupLongitude: delivery.pickupLongitude,
      deliveryLatitude: delivery.deliveryLatitude,
      deliveryLongitude: delivery.deliveryLongitude,
      estimatedArrivalMinutes: 15,
      acceptedAt: delivery.acceptedAt,
      pickedUpAt: delivery.pickedUpAt,
      estimatedDeliveryAt: DateTime.now().add(const Duration(minutes: 15)),
    );
  }

  @override
  Future<DeliveryModel> confirmReceived(String deliveryId) async {
    // Simulate network delay
    await MockData.simulateDelay();

    if (!MockData.isLoggedIn) {
      throw Exception('Not authenticated');
    }

    final deliveryIndex =
        MockData.deliveries.indexWhere((d) => d.id == deliveryId);

    if (deliveryIndex == -1) {
      throw Exception('Delivery not found');
    }

    final delivery = MockData.deliveries[deliveryIndex];

    // Update delivery
    final updatedDelivery = DeliveryModel(
      id: delivery.id,
      orderId: delivery.orderId,
      orderNumber: delivery.orderNumber,
      shopId: delivery.shopId,
      shopName: delivery.shopName,
      driverId: delivery.driverId,
      driverName: delivery.driverName,
      pickupAddress: delivery.pickupAddress,
      pickupLatitude: delivery.pickupLatitude,
      pickupLongitude: delivery.pickupLongitude,
      pickupPhone: delivery.pickupPhone,
      deliveryAddress: delivery.deliveryAddress,
      deliveryLatitude: delivery.deliveryLatitude,
      deliveryLongitude: delivery.deliveryLongitude,
      deliveryPhone: delivery.deliveryPhone,
      estimatedDistanceKm: delivery.estimatedDistanceKm,
      deliveryFee: delivery.deliveryFee,
      status: delivery.status,
      acceptedAt: delivery.acceptedAt,
      pickedUpAt: delivery.pickedUpAt,
      completedAt: delivery.completedAt,
      driverConfirmedPickup: delivery.driverConfirmedPickup,
      driverConfirmedDelivery: delivery.driverConfirmedDelivery,
      customerConfirmedDelivery: true,
      createdAt: delivery.createdAt,
    );

    MockData.deliveries[deliveryIndex] = updatedDelivery;

    return updatedDelivery;
  }

  @override
  Future<PaginatedDeliveries> getDeliveryHistory({
    int page = 1,
    int perPage = 20,
  }) async {
    // Simulate network delay
    await MockData.simulateDelay();

    if (!MockData.isLoggedIn) {
      throw Exception('Not authenticated');
    }

    // Filter deliveries for current driver
    final driverDeliveries = MockData.deliveries
        .where((d) => d.driverId == MockData.currentUserId)
        .toList();

    // Paginate
    final start = (page - 1) * perPage;
    final paginatedItems = driverDeliveries.skip(start).take(perPage).toList();
    final totalPages = (driverDeliveries.length / perPage).ceil();

    return PaginatedDeliveries(
      items: paginatedItems,
      total: driverDeliveries.length,
      page: page,
      perPage: perPage,
      pages: totalPages,
    );
  }

  @override
  Future<DriverStatsModel> getDriverStats() async {
    // Simulate network delay
    await MockData.simulateDelay();

    if (!MockData.isLoggedIn) {
      throw Exception('Not authenticated');
    }

    if (MockData.currentUserRole != 'driver') {
      throw Exception('Not authorized');
    }

    // Calculate stats from deliveries
    final driverDeliveries = MockData.deliveries
        .where((d) => d.driverId == MockData.currentUserId)
        .toList();

    final totalDeliveries = driverDeliveries.length;
    final successfulDeliveries =
        driverDeliveries.where((d) => d.status == 'completed').length;
    final totalEarnings = driverDeliveries
        .where((d) => d.status == 'completed')
        .fold<double>(0, (sum, d) => sum + d.deliveryFee);

    return DriverStatsModel(
      driverId: MockData.currentUserId!,
      totalDeliveries: totalDeliveries,
      successfulDeliveries: successfulDeliveries,
      completionRate:
          totalDeliveries > 0 ? (successfulDeliveries / totalDeliveries) : 0.0,
      averageRating: 4.7,
      totalEarnings: totalEarnings,
      earningsToday: 5000,
      earningsThisWeek: 25000,
      earningsThisMonth: 85000,
    );
  }
}
