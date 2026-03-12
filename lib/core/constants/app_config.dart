/// Application configuration settings.
/// These values can be overridden at compile-time using --dart-define.
library;

class AppConfig {
  AppConfig._();

  // ==========================================================================
  // Environment (development, staging, production)
  // ==========================================================================
  static const String environment = String.fromEnvironment(
    'ENV',
    defaultValue: 'development',
  );

  static bool get isDevelopment => environment == 'development';
  static bool get isStaging => environment == 'staging';
  static bool get isProduction => environment == 'production';

  // ==========================================================================
  // API Configuration
  // ==========================================================================
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8000/api/v1', // Android emulator localhost
  );

  static const String wsBaseUrl = String.fromEnvironment(
    'WS_BASE_URL',
    defaultValue: 'ws://10.0.2.2:8000/ws', // WebSocket endpoint
  );

  // ==========================================================================
  // API Timeouts (in seconds)
  // ==========================================================================
  static const int connectTimeout = 30;
  static const int receiveTimeout = 30;
  static const int sendTimeout = 30;

  // ==========================================================================
  // WebSocket Configuration
  // ==========================================================================
  static const int wsReconnectDelaySeconds = 5;
  static const int wsPingIntervalSeconds = 30;

  // ==========================================================================
  // Storage Keys
  // ==========================================================================
  static const String storageKeyAccessToken = 'access_token';
  static const String storageKeyRefreshToken = 'refresh_token';
  static const String storageKeyUser = 'current_user';
  static const String storageKeyCart = 'cart_data';

  // ==========================================================================
  // Feature Flags
  // ==========================================================================
  static const bool enableAnalytics = bool.fromEnvironment(
    'ENABLE_ANALYTICS',
    defaultValue: false,
  );

  static const bool enableCrashReporting = bool.fromEnvironment(
    'ENABLE_CRASH_REPORTING',
    defaultValue: false,
  );

  static const bool enableDebugLogs = bool.fromEnvironment(
    'ENABLE_DEBUG_LOGS',
    defaultValue: true,
  );

  // ==========================================================================
  // External Services (placeholders for future integration)
  // ==========================================================================
  static const String firebaseProjectId = String.fromEnvironment(
    'FIREBASE_PROJECT_ID',
    defaultValue: '',
  );

  static const String cloudflareR2Bucket = String.fromEnvironment(
    'R2_BUCKET',
    defaultValue: '',
  );

  static const String cloudflareR2Endpoint = String.fromEnvironment(
    'R2_ENDPOINT',
    defaultValue: '',
  );

  // ==========================================================================
  // Maps Configuration
  // ==========================================================================
  static const String mapTileUrl =
      'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
  static const String mapUserAgent = 'com.gura_now.app';

  // ==========================================================================
  // Default Coordinates (Bujumbura, Burundi)
  // ==========================================================================
  static const double defaultLatitude = -3.3731;
  static const double defaultLongitude = 29.3644;
  static const double defaultZoom = 13;
}
