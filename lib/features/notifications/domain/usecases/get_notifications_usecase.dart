import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/notification.dart';
import '../repositories/notification_repository.dart';

/// Use case for getting notifications
class GetNotificationsUseCase
    implements UseCase<List<Notification>, GetNotificationsParams> {
  GetNotificationsUseCase(this._repository);

  final NotificationRepository _repository;

  @override
  Future<Either<Failure, List<Notification>>> call(
    GetNotificationsParams params,
  ) async {
    return await _repository.getNotifications(
      unreadOnly: params.unreadOnly,
      skip: params.skip,
      limit: params.limit,
    );
  }
}

class GetNotificationsParams extends Equatable {
  const GetNotificationsParams({
    this.unreadOnly = false,
    this.skip = 0,
    this.limit = 50,
  });

  final bool unreadOnly;
  final int skip;
  final int limit;

  @override
  List<Object?> get props => [unreadOnly, skip, limit];
}
