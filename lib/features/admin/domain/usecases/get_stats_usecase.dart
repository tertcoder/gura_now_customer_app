import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/platform_stats.dart';
import '../repositories/admin_repository.dart';

/// Use case for getting platform statistics
class GetStatsUseCase implements UseCase<PlatformStats, NoParams> {
  GetStatsUseCase(this._repository);

  final AdminRepository _repository;

  @override
  Future<Either<Failure, PlatformStats>> call(NoParams params) async {
    return await _repository.getStats();
  }
}
