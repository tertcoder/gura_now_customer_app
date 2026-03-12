import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/notification_repository.dart';

/// Use case for getting unread notification count
class GetUnreadCountUseCase implements UseCase<int, NoParams> {
  GetUnreadCountUseCase(this._repository);

  final NotificationRepository _repository;

  @override
  Future<Either<Failure, int>> call(NoParams params) async {
    return await _repository.getUnreadCount();
  }
}
