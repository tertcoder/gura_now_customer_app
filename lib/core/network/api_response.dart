/// API Response Wrapper.
///
/// Standardizes the response format from the backend.
library;

class ApiResponse<T> {
  const ApiResponse({
    required this.success,
    this.data,
    this.message,
    this.statusCode,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      ApiResponse<T>(
        success: json['success'] as bool? ?? true,
        data: json.containsKey('data')
            ? fromJsonT(json['data'])
            : fromJsonT(json),
        message: json['detail'] as String? ?? json['message'] as String?,
        statusCode: json['status_code'] as int?,
      );

  factory ApiResponse.error({
    required String message,
    int? statusCode,
  }) =>
      ApiResponse<T>(
        success: false,
        message: message,
        statusCode: statusCode,
      );

  final bool success;
  final T? data;
  final String? message;
  final int? statusCode;
}
