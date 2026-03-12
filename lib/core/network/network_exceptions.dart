/// Network Exceptions.
///
/// Handles various network errors (HTTP 4xx, 5xx, timeouts).
library;

class NetworkException implements Exception {
  const NetworkException(this.message, {this.prefix, this.statusCode});

  final String message;
  final String? prefix;
  final int? statusCode;

  @override
  String toString() => '$prefix$message';
}

class FetchDataException extends NetworkException {
  FetchDataException(super.message, {super.statusCode})
      : super(prefix: 'Error During Communication: ');
}

class BadRequestException extends NetworkException {
  BadRequestException(super.message, {super.statusCode})
      : super(prefix: 'Invalid Request: ');
}

class UnauthorizedException extends NetworkException {
  UnauthorizedException(super.message, {super.statusCode})
      : super(prefix: 'Unauthorized: ');
}

class InvalidInputException extends NetworkException {
  InvalidInputException(super.message, {super.statusCode})
      : super(prefix: 'Invalid Input: ');
}

class NotFoundException extends NetworkException {
  NotFoundException(super.message, {super.statusCode})
      : super(prefix: 'Not Found: ');
}

class ServerException extends NetworkException {
  ServerException(super.message, {super.statusCode})
      : super(prefix: 'Server Error: ');
}

class TimeoutException extends NetworkException {
  TimeoutException(super.message, {super.statusCode})
      : super(prefix: 'Request Timeout: ');
}

class NoInternetException extends NetworkException {
  NoInternetException(super.message) : super(prefix: 'No Internet Connection: ');
}
