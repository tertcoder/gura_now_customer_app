import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/notification.dart';

/// Abstract repository interface for notification operations
abstract class NotificationRepository {
  Future<Either<Failure, List<Notification>>> getNotifications({
    bool unreadOnly = false,
    int skip = 0,
    int limit = 50,
  });

  Future<Either<Failure, int>> getUnreadCount();

  Future<Either<Failure, Notification>> markAsRead(String notificationId);

  Future<Either<Failure, int>> markAllAsRead();

  Future<Either<Failure, void>> deleteNotification(String notificationId);
}
