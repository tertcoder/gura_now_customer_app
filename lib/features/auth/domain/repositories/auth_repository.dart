import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login(String phoneNumber, String password);
  Future<Either<Failure, User>> register({
    required String fullName,
    required String phoneNumber,
    required String password,
    required String role,
    String? email,
  });
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, User>> getMe();
}
