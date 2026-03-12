import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase implements UseCase<User, LoginParams> {
  LoginUseCase(this._repository);
  final AuthRepository _repository;

  @override
  Future<Either<Failure, User>> call(LoginParams params) async =>
      await _repository.login(params.phoneNumber, params.password);
}

class LoginParams extends Equatable {
  final String phoneNumber;
  final String password;

  const LoginParams({
    required this.phoneNumber,
    required this.password,
  });

  @override
  List<Object> get props => [phoneNumber, password];
}
