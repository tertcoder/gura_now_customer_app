import 'package:equatable/equatable.dart';

// ══════════════════════════════════════════════════════════════════
// FAILURES - Returned in DOMAIN LAYER (UseCases return Either<Failure, T>)
// Based on docs/ARCHITECTURE_GUIDE.md
// ══════════════════════════════════════════════════════════════════

/// Base failure class
abstract class Failure extends Equatable {
  final String message;
  final String? code;

  const Failure(this.message, {this.code});

  @override
  List<Object?> get props => [message, code];
}

/// Network failures (no connection, timeout)
class NetworkFailure extends Failure {
  const NetworkFailure(super.message, {super.code});
}

/// Server failures (5xx / backend errors)
class ServerFailure extends Failure {
  const ServerFailure(super.message, {super.code});
}

/// Cache failures (local storage errors)
class CacheFailure extends Failure {
  const CacheFailure(super.message, {super.code});
}

/// Authentication failures
class AuthFailure extends Failure {
  const AuthFailure(super.message, {super.code});
}

/// Validation failures (422 etc.)
class ValidationFailure extends Failure {
  const ValidationFailure(super.message, {super.code});
}

/// Business logic failures
class BusinessFailure extends Failure {
  const BusinessFailure(super.message, {super.code});
}

/// Unknown/Generic failures
class UnknownFailure extends Failure {
  const UnknownFailure(super.message, {super.code});
}

