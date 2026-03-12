import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/notification.dart';
import '../repositories/notification_repository.dart';

/// Use case for marking a notification as read
class MarkAsReadUseCase implements UseCase<Notification, MarkAsReadParams> {
  MarkAsReadUseCase(this._repository);

  final NotificationRepository _repository;

  @override
  Future<Either<Failure, Notification>> call(MarkAsReadParams params) async {
    return await _repository.markAsRead(params.notificationId);
  }
}

class MarkAsReadParams extends Equatable {
  const MarkAsReadParams({required this.notificationId});

  final String notificationId;

  @override
  List<Object?> get props => [notificationId];
}
