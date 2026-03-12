import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/platform_stats.dart';
import '../../domain/repositories/admin_repository.dart';
import '../datasources/admin_remote_datasource.dart';

/// Implementation of AdminRepository
class AdminRepositoryImpl implements AdminRepository {
  AdminRepositoryImpl(this._remoteDataSource);

  final AdminRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, PlatformStats>> getStats() async {
    try {
      final stats = await _remoteDataSource.getStats();
      return Right(stats);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getUsers({
    int page = 1,
    int perPage = 20,
    String? role,
    bool? isActive,
    String? search,
  }) async {
    try {
      final result = await _remoteDataSource.getUsers(
        page: page,
        perPage: perPage,
        role: role,
        isActive: isActive,
        search: search,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> updateUserRole(
    String userId,
    String newRole,
  ) async {
    try {
      final result = await _remoteDataSource.updateUserRole(userId, newRole);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> suspendUser(
    String userId, {
    String? suspendedUntil,
    String reason = 'Violation of terms of service',
  }) async {
    try {
      final result = await _remoteDataSource.suspendUser(
        userId,
        suspendedUntil: suspendedUntil,
        reason: reason,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> unsuspendUser(
    String userId,
  ) async {
    try {
      final result = await _remoteDataSource.unsuspendUser(userId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getShops({
    int page = 1,
    int perPage = 20,
    String? status,
    String? city,
    String? search,
  }) async {
    try {
      final result = await _remoteDataSource.getShops(
        page: page,
        perPage: perPage,
        status: status,
        city: city,
        search: search,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> updateShopStatus(
    String shopId,
    String newStatus, {
    String? reason,
  }) async {
    try {
      final result = await _remoteDataSource.updateShopStatus(
        shopId,
        newStatus,
        reason: reason,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getOrders({
    int page = 1,
    int perPage = 20,
    String? status,
    String? paymentStatus,
  }) async {
    try {
      final result = await _remoteDataSource.getOrders(
        page: page,
        perPage: perPage,
        status: status,
        paymentStatus: paymentStatus,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getTransactions({
    int page = 1,
    int perPage = 20,
    String? type,
    String? status,
  }) async {
    try {
      final result = await _remoteDataSource.getTransactions(
        page: page,
        perPage: perPage,
        type: type,
        status: status,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
