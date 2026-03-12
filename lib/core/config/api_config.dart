/// API configuration helpers.
///
/// This file is the bridge between the architecture described in
/// `docs/ARCHITECTURE_GUIDE.md` (which references `ApiConfig`) and the
/// existing runtime configuration in `AppConfig` / `ApiEndpoints`.
///
/// - Use `ApiConfig.baseUrl` instead of reading `AppConfig` directly.
/// - Use `ApiConfig.defaultHeaders` / `authHeaders` for HTTP clients.
///
/// Feature endpoints remain defined in `core/constants/api_endpoints.dart`.
library;

import 'app_config.dart';

class ApiConfig {
  ApiConfig._();

  /// Base URL for the backend API.
  ///
  /// Backed by `AppConfig.baseUrl` which reads from `--dart-define`.
  static String get baseUrl => AppConfig.baseUrl;

  /// Default connection timeout for HTTP clients.
  static Duration get connectTimeout => AppConfig.connectTimeout;

  /// Default receive timeout for HTTP clients.
  static Duration get receiveTimeout => AppConfig.receiveTimeout;

  /// Default send timeout for HTTP clients.
  static Duration get sendTimeout => AppConfig.sendTimeout;

  /// Default headers for JSON APIs.
  static Map<String, String> get defaultHeaders => const {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  /// Authenticated headers with Bearer token.
  static Map<String, String> authHeaders(String token) => {
        ...defaultHeaders,
        'Authorization': 'Bearer $token',
      };
}
