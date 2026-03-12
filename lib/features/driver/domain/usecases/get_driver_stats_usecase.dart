import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/delivery.dart';
import '../repositories/delivery_repository.dart';

class GetDriverStatsUseCase implements UseCase<DriverStats, NoParams> {
  GetDriverStatsUseCase(this._repository);
  final DeliveryRepository _repository;

  @override
  Future<Either<Failure, DriverStats>> call(NoParams params) async {
    return await _repository.getDriverStats();
  }
}
