import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/platform_stats.dart';

/// Abstract repository interface for admin operations
abstract class AdminRepository {
  Future<Either<Failure, PlatformStats>> getStats();

  Future<Either<Failure, Map<String, dynamic>>> getUsers({
    int page = 1,
    int perPage = 20,
    String? role,
    bool? isActive,
    String? search,
  });

  Future<Either<Failure, Map<String, dynamic>>> updateUserRole(
    String userId,
    String newRole,
  );

  Future<Either<Failure, Map<String, dynamic>>> suspendUser(
    String userId, {
    String? suspendedUntil,
    String reason = 'Violation of terms of service',
  });

  Future<Either<Failure, Map<String, dynamic>>> unsuspendUser(String userId);

  Future<Either<Failure, Map<String, dynamic>>> getShops({
    int page = 1,
    int perPage = 20,
    String? status,
    String? city,
    String? search,
  });

  Future<Either<Failure, Map<String, dynamic>>> updateShopStatus(
    String shopId,
    String newStatus, {
    String? reason,
  });

  Future<Either<Failure, Map<String, dynamic>>> getOrders({
    int page = 1,
    int perPage = 20,
    String? status,
    String? paymentStatus,
  });

  Future<Either<Failure, Map<String, dynamic>>> getTransactions({
    int page = 1,
    int perPage = 20,
    String? type,
    String? status,
  });
}
