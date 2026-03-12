/// Application configuration loaded from compile-time environment variables.
///
/// Usage in build:
/// ```
/// flutter build apk --dart-define=API_URL=https://api.gura_now.bi --dart-define=ENV=production
/// ```
class AppConfig {
  AppConfig._();

  /// API base URL (defaults to localhost for development)
  static const String baseUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'http://localhost:8000',
  );

  /// Environment mode
  static const String environment = String.fromEnvironment(
    'ENV',
    defaultValue: 'development',
  );

  /// Check if running in production
  static bool get isProduction => environment == 'production';

  /// Check if running in development
  static bool get isDevelopment => environment == 'development';

  /// Network timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
}
