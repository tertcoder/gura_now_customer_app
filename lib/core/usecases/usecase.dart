import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../errors/failures.dart';

/// Base interface for all use cases
/// Type = Return type, Params = Input parameters
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// Use when no parameters are needed
class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}
