import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase implements UseCase<User, RegisterParams> {
  RegisterUseCase(this._repository);
  final AuthRepository _repository;

  @override
  Future<Either<Failure, User>> call(RegisterParams params) async =>
      await _repository.register(
        fullName: params.fullName,
        phoneNumber: params.phoneNumber,
        email: params.email,
        password: params.password,
        role: params.role,
      );
}

class RegisterParams extends Equatable {
  final String fullName;
  final String phoneNumber;
  final String password;
  final String role;
  final String? email;

  const RegisterParams({
    required this.fullName,
    required this.phoneNumber,
    required this.password,
    required this.role,
    this.email,
  });

  @override
  List<Object?> get props => [fullName, phoneNumber, password, role, email];
}
