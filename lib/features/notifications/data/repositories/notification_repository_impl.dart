import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/notification.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/notification_remote_datasource.dart';
import '../models/notification_model.dart' as model;

/// Implementation of NotificationRepository
class NotificationRepositoryImpl implements NotificationRepository {
  NotificationRepositoryImpl(this._remoteDataSource);

  final NotificationRemoteDataSource _remoteDataSource;

  Notification _modelToEntity(model.NotificationModel model) {
    return Notification(
      id: model.id,
      userId: model.userId,
      title: model.title,
      message: model.message,
      type: model.type,
      relatedOrderId: model.relatedOrderId,
      relatedShopId: model.relatedShopId,
      isRead: model.isRead,
      readAt: model.readAt,
      createdAt: model.createdAt,
    );
  }

  @override
  Future<Either<Failure, List<Notification>>> getNotifications({
    bool unreadOnly = false,
    int skip = 0,
    int limit = 50,
  }) async {
    try {
      final models = await _remoteDataSource.getNotifications(
        unreadOnly: unreadOnly,
        skip: skip,
        limit: limit,
      );
      final entities = models.map(_modelToEntity).toList();
      return Right(entities);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> getUnreadCount() async {
    try {
      final count = await _remoteDataSource.getUnreadCount();
      return Right(count);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Notification>> markAsRead(String notificationId) async {
    try {
      final model = await _remoteDataSource.markAsRead(notificationId);
      return Right(_modelToEntity(model));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> markAllAsRead() async {
    try {
      final count = await _remoteDataSource.markAllAsRead();
      return Right(count);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteNotification(String notificationId) async {
    try {
      await _remoteDataSource.deleteNotification(notificationId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
