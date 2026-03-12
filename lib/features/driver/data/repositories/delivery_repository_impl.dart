import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/delivery.dart';
import '../../domain/repositories/delivery_repository.dart';
import '../datasources/delivery_remote_datasource.dart';
import '../models/delivery_model.dart';
import '../models/driver_stats_model.dart';

class DeliveryRepositoryImpl implements DeliveryRepository {
  DeliveryRepositoryImpl(this._remoteDataSource);
  final DeliveryRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, List<Delivery>>> getAvailableDeliveries({
    int page = 1,
    int perPage = 20,
  }) async {
    try {
      final result = await _remoteDataSource.getAvailableDeliveries(
        page: page,
        perPage: perPage,
      );
      final deliveries = result.items.map(_availableModelToEntity).toList();
      return Right(deliveries);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Delivery>> acceptDelivery(String deliveryId) async {
    try {
      final model = await _remoteDataSource.acceptDelivery(deliveryId);
      return Right(_modelToEntity(model));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Delivery>> confirmPickup(String deliveryId) async {
    try {
      final model = await _remoteDataSource.confirmPickup(deliveryId);
      return Right(_modelToEntity(model));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateLocation(
    String deliveryId,
    double latitude,
    double longitude, {
    double? heading,
    double? speed,
  }) async {
    try {
      await _remoteDataSource.updateLocation(
        deliveryId,
        LocationUpdateModel(
          latitude: latitude,
          longitude: longitude,
          heading: heading,
          speed: speed,
        ),
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Delivery>> completeDelivery(String deliveryId) async {
    try {
      final model = await _remoteDataSource.completeDelivery(deliveryId);
      return Right(_modelToEntity(model));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Delivery>> getDeliveryTracking(String deliveryId) async {
    try {
      final model = await _remoteDataSource.getDeliveryTracking(deliveryId);
      return Right(_trackingModelToEntity(model));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Delivery>> confirmReceived(String deliveryId) async {
    try {
      final model = await _remoteDataSource.confirmReceived(deliveryId);
      return Right(_modelToEntity(model));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Delivery>>> getDeliveryHistory({
    int page = 1,
    int perPage = 20,
  }) async {
    try {
      final result = await _remoteDataSource.getDeliveryHistory(
        page: page,
        perPage: perPage,
      );
      final deliveries = result.items.map((m) => _modelToEntity(m)).toList();
      return Right(deliveries);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, DriverStats>> getDriverStats() async {
    try {
      final model = await _remoteDataSource.getDriverStats();
      return Right(_statsModelToEntity(model));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  Delivery _availableModelToEntity(AvailableDeliveryModel model) {
    return Delivery(
      id: model.id,
      orderId: model.orderId,
      orderNumber: null,
      shopId: '',
      shopName: model.shopName,
      driverId: null,
      driverName: null,
      pickupAddress: model.shopAddress,
      pickupLatitude: model.pickupLatitude,
      pickupLongitude: model.pickupLongitude,
      pickupPhone: null,
      deliveryAddress: '',
      deliveryLatitude: model.deliveryLatitude,
      deliveryLongitude: model.deliveryLongitude,
      deliveryPhone: null,
      estimatedDistanceKm: model.estimatedDistanceKm,
      deliveryFee: model.deliveryFee,
      status: 'available',
      acceptedAt: null,
      pickedUpAt: null,
      completedAt: null,
      driverConfirmedPickup: false,
      driverConfirmedDelivery: false,
      customerConfirmedDelivery: false,
      expiresAt: model.expiresAt,
      createdAt: model.createdAt,
    );
  }

  Delivery _trackingModelToEntity(DeliveryTrackingModel model) {
    return Delivery(
      id: model.deliveryId,
      orderId: model.orderId,
      orderNumber: null,
      shopId: '',
      shopName: null,
      driverId: null,
      driverName: model.driverName,
      pickupAddress: '',
      pickupLatitude: model.pickupLatitude,
      pickupLongitude: model.pickupLongitude,
      pickupPhone: model.driverPhone,
      deliveryAddress: '',
      deliveryLatitude: model.deliveryLatitude,
      deliveryLongitude: model.deliveryLongitude,
      deliveryPhone: model.driverPhone,
      estimatedDistanceKm: null,
      deliveryFee: 0,
      status: model.status,
      acceptedAt: model.acceptedAt,
      pickedUpAt: model.pickedUpAt,
      completedAt: null,
      driverConfirmedPickup: false,
      driverConfirmedDelivery: false,
      customerConfirmedDelivery: false,
      expiresAt: null,
      createdAt: model.acceptedAt ?? DateTime.now(),
    );
  }

  Delivery _modelToEntity(DeliveryModel model) {
    return Delivery(
      id: model.id,
      orderId: model.orderId,
      orderNumber: model.orderNumber,
      shopId: model.shopId,
      shopName: model.shopName,
      driverId: model.driverId,
      driverName: model.driverName,
      pickupAddress: model.pickupAddress,
      pickupLatitude: model.pickupLatitude,
      pickupLongitude: model.pickupLongitude,
      pickupPhone: model.pickupPhone,
      deliveryAddress: model.deliveryAddress,
      deliveryLatitude: model.deliveryLatitude,
      deliveryLongitude: model.deliveryLongitude,
      deliveryPhone: model.deliveryPhone,
      estimatedDistanceKm: model.estimatedDistanceKm,
      deliveryFee: model.deliveryFee,
      status: model.status,
      acceptedAt: model.acceptedAt,
      pickedUpAt: model.pickedUpAt,
      completedAt: model.completedAt,
      driverConfirmedPickup: model.driverConfirmedPickup,
      driverConfirmedDelivery: model.driverConfirmedDelivery,
      customerConfirmedDelivery: model.customerConfirmedDelivery,
      expiresAt: model.expiresAt,
      createdAt: model.createdAt,
    );
  }

  DriverStats _statsModelToEntity(DriverStatsModel model) {
    return DriverStats(
      driverId: model.driverId,
      totalDeliveries: model.totalDeliveries,
      successfulDeliveries: model.successfulDeliveries,
      completionRate: model.completionRate,
      averageRating: model.averageRating,
      totalEarnings: model.totalEarnings,
      earningsToday: model.earningsToday,
      earningsThisWeek: model.earningsThisWeek,
      earningsThisMonth: model.earningsThisMonth,
    );
  }
}
