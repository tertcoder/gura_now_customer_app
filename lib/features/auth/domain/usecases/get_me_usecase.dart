import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class GetMeUseCase implements UseCase<User, NoParams> {
  GetMeUseCase(this._repository);
  final AuthRepository _repository;

  @override
  Future<Either<Failure, User>> call(NoParams params) async =>
      await _repository.getMe();
}
