// ══════════════════════════════════════════════════════════════════
// EXCEPTIONS - Thrown in DATA LAYER (DataSources, Repositories)
// Based on docs/ARCHITECTURE_GUIDE.md
// ══════════════════════════════════════════════════════════════════

/// Base server exception (for HTTP / backend failures)
class ServerException implements Exception {
  const ServerException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => 'ServerException: $message';
}

/// 400 - Bad Request
class BadRequestException extends ServerException {
  const BadRequestException(super.message) : super(statusCode: 400);
}

/// 401 - Unauthorized
class UnauthorizedException extends ServerException {
  const UnauthorizedException(super.message) : super(statusCode: 401);
}

/// 403 - Forbidden
class ForbiddenException extends ServerException {
  const ForbiddenException(super.message) : super(statusCode: 403);
}

/// 404 - Not Found
class NotFoundException extends ServerException {
  const NotFoundException(super.message) : super(statusCode: 404);
}

/// 422 - Validation Error
class ValidationException extends ServerException {
  const ValidationException(super.message, this.errors)
      : super(statusCode: 422);
  final List<dynamic> errors;
}

/// Cache/Local storage exception
class CacheException implements Exception {
  const CacheException(this.message);
  final String message;
}

/// Network connectivity exception
class NetworkException implements Exception {
  const NetworkException(this.message);
  final String message;
}
