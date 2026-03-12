import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/delivery.dart';

/// Abstract repository interface for delivery operations
abstract class DeliveryRepository {
  Future<Either<Failure, List<Delivery>>> getAvailableDeliveries({
    int page = 1,
    int perPage = 20,
  });

  Future<Either<Failure, Delivery>> acceptDelivery(String deliveryId);

  Future<Either<Failure, Delivery>> confirmPickup(String deliveryId);

  Future<Either<Failure, void>> updateLocation(
    String deliveryId,
    double latitude,
    double longitude, {
    double? heading,
    double? speed,
  });

  Future<Either<Failure, Delivery>> completeDelivery(String deliveryId);

  Future<Either<Failure, Delivery>> getDeliveryTracking(String deliveryId);

  Future<Either<Failure, Delivery>> confirmReceived(String deliveryId);

  Future<Either<Failure, List<Delivery>>> getDeliveryHistory({
    int page = 1,
    int perPage = 20,
  });

  Future<Either<Failure, DriverStats>> getDriverStats();
}
