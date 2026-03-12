# 🚀 Flutter Clean Architecture + BLoC Complete Guide

> **The Ultimate Template for Scalable Flutter Applications**
>
> This guide is your universal reference for building **production-ready Flutter apps** using Clean Architecture, BLoC state management, and SOLID principles.
>
> 📅 Last Updated: December 2024

---

## 📑 Table of Contents

1. [Quick Start](#-quick-start)
2. [Project Structure](#-project-structure)
3. [Architecture Overview](#-architecture-overview)
4. [Core Layer](#-core-layer-in-depth)
5. [Features Layer](#-features-layer-in-depth)
6. [Data Layer](#-data-layer)
7. [Domain Layer](#-domain-layer)
8. [Presentation Layer](#-presentation-layer)
9. [Dependency Injection](#-dependency-injection)
10. [Error Handling](#-error-handling)
11. [Complete Code Templates](#-complete-code-templates)
12. [API Integration](#-api-integration)
13. [State Management with BLoC](#-state-management-with-bloc)
14. [Navigation & Routing](#-navigation--routing)
15. [UI Components](#-ui-components)
16. [Best Practices](#-best-practices)
17. [Checklist](#-new-feature-checklist)

---

## 🏁 Quick Start

### Required Dependencies (pubspec.yaml)

```yaml
dependencies:
  flutter:
    sdk: flutter

  # Architecture & State Management
  flutter_bloc: ^9.1.1 # BLoC state management
  get_it: ^9.0.5 # Dependency injection
  dartz: ^0.10.1 # Functional programming (Either)
  equatable: ^2.0.7 # Value equality

  # Navigation
  go_router: ^17.0.0 # Declarative routing

  # Network & Storage
  dio: ^5.4.0 # HTTP client (Dio)
  shared_preferences: ^2.2.2 # Local storage

  # UI
  google_fonts: ^6.3.2 # Typography
  intl: ^0.20.2 # Internationalization
  flutter_svg: ^2.2.2 # SVG support
  fl_chart: ^1.1.1 # Charts (optional)

dev_dependencies:
  flutter_lints: ^5.0.0
```

### Initialize New Project

```bash
# 1. Create project
flutter create my_app

# 2. Add dependencies
flutter pub add flutter_bloc get_it dartz equatable go_router dio shared_preferences google_fonts intl

# 3. Create folder structure (see below)
```

---

## 📁 Project Structure

```
lib/
├── core/                          # 🔧 Global utilities & shared code
│   ├── config/
│   │   └── api_config.dart        # API endpoints & configuration
│   ├── constants/
│   │   └── app_constants.dart     # App-wide constants
│   ├── di/
│   │   └── injection_container.dart # Dependency injection setup
│   ├── errors/
│   │   ├── exceptions.dart        # Exception classes (data layer)
│   │   └── failures.dart          # Failure classes (domain layer)
│   ├── network/
│   │   └── api_client.dart        # Dio-based API client wrapper
│   ├── router/
│   │   └── app_router.dart        # Route definitions
│   ├── theme/
│   │   ├── app_colors.dart        # Color palette
│   │   └── app_theme.dart         # Theme configuration
│   ├── usecases/
│   │   └── usecase.dart           # Base usecase interface
│   ├── utils/
│   │   ├── extensions.dart        # Dart extensions
│   │   ├── formatters.dart        # Date/currency formatters
│   │   └── validators.dart        # Form validators
│   ├── widgets/                   # Reusable widgets
│   │   ├── custom_button.dart
│   │   ├── custom_text_field.dart
│   │   ├── loading_indicator.dart
│   │   └── ...
│   └── core.dart                  # Barrel export for core
│
├── features/                      # 🎯 Feature modules
│   └── [feature_name]/
│       ├── data/                  # 📦 External data handling
│       │   ├── datasources/
│       │   │   ├── [feature]_local_datasource.dart
│       │   │   └── [feature]_remote_datasource.dart
│       │   ├── models/
│       │   │   └── [entity]_model.dart
│       │   └── repositories/
│       │       └── [feature]_repository_impl.dart
│       │
│       ├── domain/                # 🧠 Business logic (pure Dart)
│       │   ├── entities/
│       │   │   └── [entity].dart
│       │   ├── repositories/
│       │   │   └── [feature]_repository.dart  # Abstract interface
│       │   └── usecases/
│       │       └── [action]_usecase.dart
│       │
│       ├── presentation/          # 🎨 UI & State
│       │   ├── bloc/
│       │   │   ├── [feature]_bloc.dart
│       │   │   ├── [feature]_event.dart
│       │   │   └── [feature]_state.dart
│       │   ├── pages/
│       │   │   └── [feature]_screen.dart
│       │   └── widgets/
│       │       └── [feature]_widget.dart
│       │
│       └── [feature].dart         # Barrel export for feature
│
├── app.dart                       # App widget (providers, theme, router)
├── main.dart                      # Entry point
└── main_screen.dart               # Main scaffold with bottom nav
```

---

## 🏛 Architecture Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                        PRESENTATION LAYER                        │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │  Screens (Pages)  ←→  BLoC  ←→  Widgets                 │    │
│  │     ↓ dispatches events, listens to states              │    │
│  └─────────────────────────────────────────────────────────┘    │
│                              ↓ calls                             │
├─────────────────────────────────────────────────────────────────┤
│                         DOMAIN LAYER                             │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │  UseCases  ←→  Repository (Interface)  ←→  Entities     │    │
│  │     ↓ Pure Dart, no Flutter imports                     │    │
│  └─────────────────────────────────────────────────────────┘    │
│                              ↓ implements                        │
├─────────────────────────────────────────────────────────────────┤
│                          DATA LAYER                              │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │  RepositoryImpl  ←→  DataSources  ←→  Models            │    │
│  │     ↓ Remote (API)        ↓ Local (DB/Cache)            │    │
│  └─────────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────────┘
```

### Data Flow

```
UI Event → BLoC → UseCase → Repository → DataSource → API/DB
    ↑         ↓         ↓            ↓              ↓
UI State ← BLoC ← Either<Failure,T> ← Repository ← Model/Exception
```

---

## 🔧 Core Layer In-Depth

### 1. API Configuration (`core/config/api_config.dart`)

```dart
class ApiConfig {
  // Environment URLs
  static const String localUrl = 'http://localhost:3000/api';
  static const String productionUrl = 'https://api.myapp.com/api';

  // Current environment - change for production
  static const String baseUrl = productionUrl;

  // ═══════════════════════════════════════════════════════════════
  // AUTH ENDPOINTS
  // ═══════════════════════════════════════════════════════════════
  static const String login = '$baseUrl/auth/login';
  static const String register = '$baseUrl/auth/register';
  static const String profile = '$baseUrl/auth/profile';
  static const String logout = '$baseUrl/auth/logout';
  static const String changePassword = '$baseUrl/auth/change-password';

  // ═══════════════════════════════════════════════════════════════
  // FEATURE ENDPOINTS (example)
  // ═══════════════════════════════════════════════════════════════
  static const String items = '$baseUrl/items';
  static String itemById(String id) => '$baseUrl/items/$id';

  // ═══════════════════════════════════════════════════════════════
  // CONFIGURATION
  // ═══════════════════════════════════════════════════════════════
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static Map<String, String> authHeaders(String token) => {
    ...defaultHeaders,
    'Authorization': 'Bearer $token',
  };
}
```

### 2. App Constants (`core/constants/app_constants.dart`)

```dart
class AppConstants {
  // ═══════════════════════════════════════════════════════════════
  // ANIMATION
  // ═══════════════════════════════════════════════════════════════
  static const int shortAnimationMs = 200;
  static const int mediumAnimationMs = 300;
  static const int longAnimationMs = 500;

  // ═══════════════════════════════════════════════════════════════
  // UI DIMENSIONS
  // ═══════════════════════════════════════════════════════════════
  static const double paddingXS = 4.0;
  static const double paddingSM = 8.0;
  static const double paddingMD = 16.0;
  static const double paddingLG = 24.0;
  static const double paddingXL = 32.0;

  static const double borderRadius = 12.0;
  static const double cardElevation = 2.0;

  // ═══════════════════════════════════════════════════════════════
  // TEXT SIZES
  // ═══════════════════════════════════════════════════════════════
  static const double fontXS = 10.0;
  static const double fontSM = 12.0;
  static const double fontMD = 14.0;
  static const double fontLG = 16.0;
  static const double fontXL = 18.0;
  static const double fontXXL = 24.0;
  static const double fontHuge = 32.0;

  // ═══════════════════════════════════════════════════════════════
  // FORMATTING
  // ═══════════════════════════════════════════════════════════════
  static const String currencySymbol = 'USD';
  static const String dateFormat = 'dd MMM yyyy';
  static const String dateTimeFormat = 'dd MMM yyyy HH:mm';
  static const String timeFormat = 'HH:mm';

  // ═══════════════════════════════════════════════════════════════
  // VALIDATION
  // ═══════════════════════════════════════════════════════════════
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 50;
  static const int maxNameLength = 50;
  static const int maxDescriptionLength = 500;
}
```

### 3. Exceptions (`core/errors/exceptions.dart`)

```dart
// ══════════════════════════════════════════════════════════════════
// EXCEPTIONS - Thrown in DATA LAYER (DataSources, Repositories)
// ══════════════════════════════════════════════════════════════════

/// Base server exception
class ServerException implements Exception {
  final String message;
  final int? statusCode;

  const ServerException(this.message, {this.statusCode});

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
  final List<dynamic> errors;

  const ValidationException(super.message, this.errors) : super(statusCode: 422);
}

/// Cache/Local storage exception
class CacheException implements Exception {
  final String message;
  const CacheException(this.message);
}

/// Network connectivity exception
class NetworkException implements Exception {
  final String message;
  const NetworkException(this.message);
}
```

### 4. Failures (`core/errors/failures.dart`)

```dart
import 'package:equatable/equatable.dart';

// ══════════════════════════════════════════════════════════════════
// FAILURES - Returned in DOMAIN LAYER (UseCases return Either<Failure, T>)
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

/// Server failures (5xx errors)
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

/// Validation failures
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
```

### 5. Base UseCase (`core/usecases/usecase.dart`)

```dart
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
```

### 6. API Client – Dio (`core/network/api_client.dart`)

The app uses **Dio** for HTTP. The API client wraps `DioClient` and returns decoded JSON plus maps errors to `core/errors/exceptions.dart`.

```dart
import 'dart:convert';
import 'package:dio/dio.dart';
import '../config/api_config.dart';
import '../errors/exceptions.dart';
import 'dio_client.dart';
import 'network_exceptions.dart' as net_exceptions;

/// Dio-based API client. Data sources use this for get/post/put/patch/delete.
class ApiClient {
  ApiClient(this._dioClient);
  final DioClient _dioClient;

  Future<Map<String, dynamic>> get(String path, {Map<String, dynamic>? queryParams, Options? options}) async {
    final response = await _dioClient.dio.get(path, queryParameters: queryParams, options: options);
    return _decodeJson(response);
  }

  Future<Map<String, dynamic>> post(String path, Map<String, dynamic> body, {Map<String, dynamic>? queryParams, Options? options}) async {
    final response = await _dioClient.dio.post(path, data: body, queryParameters: queryParams, options: options);
    return _decodeJson(response);
  }

  Future<Map<String, dynamic>> put(String path, Map<String, dynamic> body, {Map<String, dynamic>? queryParams, Options? options}) async {
    final response = await _dioClient.dio.put(path, data: body, queryParameters: queryParams, options: options);
    return _decodeJson(response);
  }

  Future<Map<String, dynamic>> patch(String path, {Map<String, dynamic>? body, Map<String, dynamic>? queryParams, Options? options}) async {
    final response = await _dioClient.dio.patch(path, data: body, queryParameters: queryParams, options: options);
    return _decodeJson(response);
  }

  Future<Map<String, dynamic>> delete(String path, {Map<String, dynamic>? queryParams, Options? options}) async {
    final response = await _dioClient.dio.delete(path, queryParameters: queryParams, options: options);
    return _decodeJson(response);
  }

  Map<String, dynamic> _decodeJson(Response response) {
    final data = response.data;
    if (data is Map<String, dynamic>) return data;
    if (data is String) {
      try {
        final decoded = jsonDecode(data);
        if (decoded is Map<String, dynamic>) return decoded;
      } catch (_) {}
    }
    return <String, dynamic>{'statusCode': response.statusCode, 'data': data};
  }
}
```

### 7. Theme & Colors

#### `core/theme/app_colors.dart`

```dart
import 'package:flutter/material.dart';

class AppColors {
  // ═══════════════════════════════════════════════════════════════
  // PRIMARY COLORS
  // ═══════════════════════════════════════════════════════════════
  static const Color primary = Color(0xFF60A5FA);
  static const Color primaryLight = Color(0xFF93C5FD);
  static const Color primaryDark = Color(0xFF3B82F6);

  static const Color secondary = Color(0xFFFBBF24);
  static const Color secondaryLight = Color(0xFFFDE047);
  static const Color secondaryDark = Color(0xFFF59E0B);

  // ═══════════════════════════════════════════════════════════════
  // SEMANTIC COLORS
  // ═══════════════════════════════════════════════════════════════
  static const Color success = Color(0xFF34D399);
  static const Color successLight = Color(0xFF6EE7B7);
  static const Color successDark = Color(0xFF10B981);

  static const Color warning = Color(0xFFFB923C);
  static const Color warningLight = Color(0xFFFDBA74);
  static const Color warningDark = Color(0xFFF97316);

  static const Color error = Color(0xFFF87171);
  static const Color errorLight = Color(0xFFFCA5A5);
  static const Color errorDark = Color(0xFFEF4444);

  // ═══════════════════════════════════════════════════════════════
  // BACKGROUNDS (Dark Theme)
  // ═══════════════════════════════════════════════════════════════
  static const Color background = Color(0xFF0F172A);
  static const Color surface = Color(0xFF1E293B);
  static const Color surfaceVariant = Color(0xFF334155);
  static const Color surfaceBright = Color(0xFF475569);

  // ═══════════════════════════════════════════════════════════════
  // TEXT COLORS
  // ═══════════════════════════════════════════════════════════════
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFFCBD5E1);
  static const Color textTertiary = Color(0xFF94A3B8);
  static const Color textDisabled = Color(0xFF64748B);

  // ═══════════════════════════════════════════════════════════════
  // BORDERS
  // ═══════════════════════════════════════════════════════════════
  static const Color border = Color(0xFF475569);
  static const Color borderLight = Color(0xFF64748B);
  static const Color borderDark = Color(0xFF334155);

  // ═══════════════════════════════════════════════════════════════
  // OVERLAYS
  // ═══════════════════════════════════════════════════════════════
  static const Color overlay = Color(0x80000000);
  static const Color shadow = Color(0x40000000);
}
```

#### `core/theme/app_theme.dart`

```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.dark,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        error: AppColors.error,
        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
        onPrimary: AppColors.background,
        onSecondary: AppColors.background,
        outline: AppColors.border,
      ),
      textTheme: GoogleFonts.poppinsTextTheme().copyWith(
        headlineLarge: GoogleFonts.poppins(
          fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.textPrimary,
        ),
        headlineMedium: GoogleFonts.poppins(
          fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary,
        ),
        headlineSmall: GoogleFonts.poppins(
          fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.textPrimary,
        ),
        titleLarge: GoogleFonts.poppins(
          fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary,
        ),
        titleMedium: GoogleFonts.poppins(
          fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary,
        ),
        bodyLarge: GoogleFonts.poppins(
          fontSize: 16, fontWeight: FontWeight.normal, color: AppColors.textPrimary,
        ),
        bodyMedium: GoogleFonts.poppins(
          fontSize: 14, fontWeight: FontWeight.normal, color: AppColors.textPrimary,
        ),
        bodySmall: GoogleFonts.poppins(
          fontSize: 12, fontWeight: FontWeight.normal, color: AppColors.textSecondary,
        ),
      ),
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  static ThemeData get lightTheme => darkTheme; // Implement if needed
}
```

### 8. Validators (`core/utils/validators.dart`)

```dart
class Validators {
  /// Required field
  static String? required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  /// Email validation
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  /// Phone validation
  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }

    final cleaned = value.replaceAll(RegExp(r'[\s\-\(\)]'), '');

    if (!RegExp(r'^\+?\d{9,15}$').hasMatch(cleaned)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  /// Password validation
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  /// Confirm password
  static String? Function(String?) confirmPassword(String password) {
    return (String? value) {
      if (value == null || value.isEmpty) {
        return 'Please confirm your password';
      }
      if (value != password) {
        return 'Passwords do not match';
      }
      return null;
    };
  }

  /// Amount validation
  static String? validateAmount(String? value, {double? min, double? max}) {
    if (value == null || value.trim().isEmpty) {
      return 'Amount is required';
    }

    final amount = double.tryParse(value);
    if (amount == null) {
      return 'Please enter a valid number';
    }

    if (min != null && amount < min) {
      return 'Amount must be at least $min';
    }

    if (max != null && amount > max) {
      return 'Amount must not exceed $max';
    }
    return null;
  }
}
```

---

## 🎯 Features Layer In-Depth

Each feature is a **self-contained module** with its own data, domain, and presentation layers.

### Feature Barrel Export (`features/auth/auth.dart`)

```dart
// ═══════════════════════════════════════════════════════════════════
// AUTH FEATURE - Barrel Export
// ═══════════════════════════════════════════════════════════════════
// Usage: import 'package:my_app/features/auth/auth.dart';

// Domain - Entities
export 'domain/entities/user.dart';

// Domain - Repositories (Interface)
export 'domain/repositories/auth_repository.dart';

// Domain - Use Cases
export 'domain/usecases/login_usecase.dart';
export 'domain/usecases/logout_usecase.dart';
export 'domain/usecases/register_usecase.dart';

// Data - Models
export 'data/models/user_model.dart';

// Data - Data Sources
export 'data/datasources/auth_local_datasource.dart';
export 'data/datasources/auth_remote_datasource.dart';

// Data - Repository Implementation
export 'data/repositories/auth_repository_impl.dart';

// Presentation - BLoC
export 'presentation/bloc/auth_bloc.dart';

// Presentation - Pages
export 'presentation/pages/login_screen.dart';
export 'presentation/pages/register_screen.dart';
```

---

## 📦 Data Layer

The data layer handles **all external communication** (API, database, cache).

### 1. Entity (`domain/entities/user.dart`)

```dart
import 'package:equatable/equatable.dart';

/// Domain entity - pure business object
/// No JSON, no Flutter dependencies
class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? avatar;
  final DateTime createdAt;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.avatar,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, name, email, phone, avatar, createdAt];
}
```

### 2. Model (`data/models/user_model.dart`)

```dart
import '../../domain/entities/user.dart';

/// Data model - extends entity, adds serialization
class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.phone,
    super.avatar,
    required super.createdAt,
  });

  /// JSON → Model
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      avatar: json['avatar'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  /// Model → JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'avatar': avatar,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Entity → Model (for caching)
  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      name: user.name,
      email: user.email,
      phone: user.phone,
      avatar: user.avatar,
      createdAt: user.createdAt,
    );
  }
}
```

### 3. Remote DataSource (`data/datasources/auth_remote_datasource.dart`)

```dart
import '../../../../core/config/api_config.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/user_model.dart';

/// Abstract interface for remote data operations
abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register(String name, String email, String phone, String password);
  Future<UserModel> getProfile();
  Future<void> logout();
}

/// Implementation
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final response = await apiClient.post(
        ApiConfig.login,
        {'email': email, 'password': password},
        requiresAuth: false,
      );

      if (response['success'] == true && response['data'] != null) {
        final userData = response['data'];
        await apiClient.saveAuthToken(userData['token']);
        return UserModel.fromJson(userData['user']);
      } else {
        throw ServerException(response['message'] ?? 'Login failed');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Login failed: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> register(
    String name,
    String email,
    String phone,
    String password,
  ) async {
    try {
      final response = await apiClient.post(
        ApiConfig.register,
        {
          'name': name,
          'email': email,
          'phone': phone,
          'password': password,
        },
        requiresAuth: false,
      );

      if (response['success'] == true && response['data'] != null) {
        final userData = response['data'];
        await apiClient.saveAuthToken(userData['token']);
        return UserModel.fromJson(userData['user']);
      } else {
        throw ServerException(response['message'] ?? 'Registration failed');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Registration failed: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> getProfile() async {
    try {
      final response = await apiClient.get(ApiConfig.profile);

      if (response['success'] == true && response['data'] != null) {
        return UserModel.fromJson(response['data']['user']);
      } else {
        throw ServerException(response['message'] ?? 'Failed to get profile');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Failed to get profile: ${e.toString()}');
    }
  }

  @override
  Future<void> logout() async {
    await apiClient.clearAuthToken();
  }
}
```

### 4. Local DataSource (`data/datasources/auth_local_datasource.dart`)

```dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<UserModel?> getCachedUser();
  Future<void> cacheUser(UserModel user);
  Future<void> clearUser();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences prefs;
  static const String cachedUserKey = 'CACHED_USER';

  AuthLocalDataSourceImpl({required this.prefs});

  @override
  Future<UserModel?> getCachedUser() async {
    final jsonString = prefs.getString(cachedUserKey);
    if (jsonString != null) {
      return UserModel.fromJson(jsonDecode(jsonString));
    }
    return null;
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    await prefs.setString(cachedUserKey, jsonEncode(user.toJson()));
  }

  @override
  Future<void> clearUser() async {
    await prefs.remove(cachedUserKey);
  }
}
```

### 5. Repository Implementation (`data/repositories/auth_repository_impl.dart`)

```dart
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../datasources/auth_local_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    try {
      final user = await remoteDataSource.login(email, password);
      await localDataSource.cacheUser(user);
      return Right(user);
    } on ServerException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> register(
    String name,
    String email,
    String phone,
    String password,
  ) async {
    try {
      final user = await remoteDataSource.register(name, email, phone, password);
      await localDataSource.cacheUser(user);
      return Right(user);
    } on ServerException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      await localDataSource.clearUser();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final cachedUser = await localDataSource.getCachedUser();
      if (cachedUser != null) {
        return Right(cachedUser);
      }

      try {
        final user = await remoteDataSource.getProfile();
        await localDataSource.cacheUser(user);
        return Right(user);
      } on UnauthorizedException {
        return const Right(null);
      }
    } on ServerException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }
}
```

---

## 🧠 Domain Layer

The domain layer is **pure Dart** - no Flutter imports, no external dependencies.

### 1. Repository Interface (`domain/repositories/auth_repository.dart`)

```dart
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';

/// Abstract repository interface
/// Implemented by data layer, used by use cases
abstract class AuthRepository {
  Future<Either<Failure, User>> login(String email, String password);
  Future<Either<Failure, User>> register(String name, String email, String phone, String password);
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, User?>> getCurrentUser();
}
```

### 2. UseCase (`domain/usecases/login_usecase.dart`)

```dart
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class LoginUsecase implements UseCase<User, LoginParams> {
  final AuthRepository repository;

  LoginUsecase(this.repository);

  @override
  Future<Either<Failure, User>> call(LoginParams params) async {
    return await repository.login(params.email, params.password);
  }
}

class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}
```

---

## 🎨 Presentation Layer

### 1. BLoC (`presentation/bloc/auth_bloc.dart`)

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUsecase loginUsecase;
  final RegisterUsecase registerUsecase;
  final LogoutUsecase logoutUsecase;

  AuthBloc({
    required this.loginUsecase,
    required this.registerUsecase,
    required this.logoutUsecase,
  }) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await loginUsecase(
      LoginParams(email: event.email, password: event.password),
    );

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await registerUsecase(
      RegisterParams(
        name: event.name,
        email: event.email,
        phone: event.phone,
        password: event.password,
      ),
    );

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await logoutUsecase(NoParams());

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(AuthUnauthenticated()),
    );
  }
}
```

### 2. Events (`presentation/bloc/auth_event.dart`)

```dart
part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginRequested({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class RegisterRequested extends AuthEvent {
  final String name;
  final String email;
  final String phone;
  final String password;

  const RegisterRequested({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
  });

  @override
  List<Object> get props => [name, email, phone, password];
}

class LogoutRequested extends AuthEvent {}
```

### 3. States (`presentation/bloc/auth_state.dart`)

```dart
part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final User user;

  const AuthAuthenticated(this.user);

  @override
  List<Object> get props => [user];
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object> get props => [message];
}
```

### 4. Screen/Page (`presentation/pages/login_screen.dart`)

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/utils/validators.dart';
import '../bloc/auth_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        LoginRequested(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          } else if (state is AuthAuthenticated) {
            context.go('/dashboard');
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 60),
                  // Header
                  Text(
                    'Welcome Back',
                    style: Theme.of(context).textTheme.headlineLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),

                  // Email
                  CustomTextField(
                    label: 'Email',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.validateEmail,
                  ),
                  const SizedBox(height: 16),

                  // Password
                  CustomTextField(
                    label: 'Password',
                    controller: _passwordController,
                    obscureText: true,
                    validator: Validators.validatePassword,
                  ),
                  const SizedBox(height: 32),

                  // Login Button
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return CustomButton(
                        label: 'Login',
                        onPressed: _handleLogin,
                        isLoading: state is AuthLoading,
                        isFullWidth: true,
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // Register Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? "),
                      TextButton(
                        onPressed: () => context.go('/register'),
                        child: const Text('Sign Up'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
```

---

## 🛠 Dependency Injection

### `core/di/injection_container.dart`

```dart
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../network/api_client.dart';
import '../network/dio_client.dart';

// Import all features
import '../../features/auth/auth.dart';
// import '../../features/[feature]/[feature].dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ═══════════════════════════════════════════════════════════════
  // CORE DEPENDENCIES
  // ═══════════════════════════════════════════════════════════════
  await _initCore();

  // ═══════════════════════════════════════════════════════════════
  // FEATURES
  // ═══════════════════════════════════════════════════════════════
  _initAuth();
  // _initFeature2();
  // _initFeature3();
}

Future<void> _initCore() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => DioClient(sl()));
  sl.registerLazySingleton(() => ApiClient(sl()));
}

void _initAuth() {
  // ─────────────────────────────────────────────────────────────────
  // BLoC (Factory = new instance each time)
  // ─────────────────────────────────────────────────────────────────
  sl.registerFactory(() => AuthBloc(
    loginUsecase: sl(),
    logoutUsecase: sl(),
    registerUsecase: sl(),
  ));

  // ─────────────────────────────────────────────────────────────────
  // Use Cases (Singleton)
  // ─────────────────────────────────────────────────────────────────
  sl.registerLazySingleton(() => LoginUsecase(sl()));
  sl.registerLazySingleton(() => LogoutUsecase(sl()));
  sl.registerLazySingleton(() => RegisterUsecase(sl()));

  // ─────────────────────────────────────────────────────────────────
  // Repository (Singleton, registered with interface type)
  // ─────────────────────────────────────────────────────────────────
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // ─────────────────────────────────────────────────────────────────
  // Data Sources (Singleton, registered with interface type)
  // ─────────────────────────────────────────────────────────────────
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(apiClient: sl()),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(prefs: sl()),
  );
}
```

---

## 🧭 Navigation & Routing

### `core/router/app_router.dart`

```dart
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/splash_screen.dart';
import '../../features/auth/presentation/pages/login_screen.dart';
import '../../features/auth/presentation/pages/register_screen.dart';
import '../../main_screen.dart';
import '../../dashboard_screen.dart';

class AppRouter {
  AppRouter._();

  static const String initialRoute = '/splash';

  // ═══════════════════════════════════════════════════════════════
  // ROUTE PATHS
  // ═══════════════════════════════════════════════════════════════
  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';
  static const String dashboard = '/dashboard';
  static const String profile = '/profile';

  // ═══════════════════════════════════════════════════════════════
  // ROUTER
  // ═══════════════════════════════════════════════════════════════
  static final GoRouter router = GoRouter(
    initialLocation: initialRoute,
    debugLogDiagnostics: false,
    routes: [
      // Public Routes
      GoRoute(
        path: splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: register,
        builder: (context, state) => const RegisterScreen(),
      ),

      // Protected Routes with Shell (Bottom Navigation)
      ShellRoute(
        builder: (context, state, child) => MainScreen(child: child),
        routes: [
          GoRoute(
            path: dashboard,
            builder: (context, state) => const DashboardScreen(),
          ),
          // Add more routes here
        ],
      ),
    ],
  );
}
```

---

## 📱 Entry Files

### `main.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/di/injection_container.dart' as di;
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // System UI
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  // Initialize DI
  await di.init();

  runApp(const MyApp());
}
```

### `app.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'core/di/injection_container.dart' as di;
import 'features/auth/presentation/bloc/auth_bloc.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => di.sl<AuthBloc>(),
        ),
        // Add more BLoC providers here
      ],
      child: MaterialApp.router(
        title: 'My App',
        theme: AppTheme.darkTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.dark,
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
```

---

## 🎯 UI Components

### Custom Button (`core/widgets/custom_button.dart`)

```dart
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum ButtonType { primary, secondary, outline, text }

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final ButtonType type;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.type = ButtonType.primary,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    final buttonChild = Row(
      mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading)
          const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
          )
        else if (icon != null) ...[
          Icon(icon, size: 20),
          const SizedBox(width: 8),
        ],
        Text(label),
      ],
    );

    switch (type) {
      case ButtonType.primary:
        return SizedBox(
          width: isFullWidth ? double.infinity : null,
          child: ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: buttonChild,
          ),
        );
      case ButtonType.outline:
        return SizedBox(
          width: isFullWidth ? double.infinity : null,
          child: OutlinedButton(
            onPressed: isLoading ? null : onPressed,
            child: buttonChild,
          ),
        );
      default:
        return ElevatedButton(onPressed: onPressed, child: buttonChild);
    }
  }
}
```

### Custom Text Field (`core/widgets/custom_text_field.dart`)

```dart
import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? prefixIcon;
  final String? Function(String?)? validator;
  final int maxLines;

  const CustomTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.prefixIcon,
    this.validator,
    this.maxLines = 1,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.controller,
          obscureText: widget.obscureText && _obscureText,
          keyboardType: widget.keyboardType,
          validator: widget.validator,
          maxLines: widget.obscureText ? 1 : widget.maxLines,
          decoration: InputDecoration(
            hintText: widget.hint,
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.obscureText
                ? IconButton(
                    icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _obscureText = !_obscureText),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
```

---

## ✅ New Feature Checklist

When adding a new feature, follow this checklist:

### 1. Domain Layer (Start Here)

- [ ] Create entity in `domain/entities/`
- [ ] Create repository interface in `domain/repositories/`
- [ ] Create use cases in `domain/usecases/`

### 2. Data Layer

- [ ] Create model in `data/models/` (extends entity)
- [ ] Create remote data source in `data/datasources/`
- [ ] Create local data source in `data/datasources/` (if caching needed)
- [ ] Create repository implementation in `data/repositories/`

### 3. Presentation Layer

- [ ] Create BLoC in `presentation/bloc/`
  - [ ] Events file
  - [ ] States file
  - [ ] BLoC file
- [ ] Create pages in `presentation/pages/`
- [ ] Create widgets in `presentation/widgets/` (if needed)

### 4. Integration

- [ ] Register dependencies in `core/di/injection_container.dart`
- [ ] Add routes in `core/router/app_router.dart`
- [ ] Add BLoC provider in `app.dart`
- [ ] Create barrel export file `features/[feature]/[feature].dart`

### 5. API (If applicable)

- [ ] Add endpoints in `core/config/api_config.dart`

---

## 🏆 Best Practices Summary

1. **Domain layer is pure Dart** - No Flutter imports
2. **One UseCase = One Action** - Single responsibility
3. **BLoC receives UseCases, not Repositories** - Proper abstraction
4. **Use Either<Failure, T>** - Functional error handling
5. **Register interfaces, not implementations** - Dependency inversion
6. **Factory for BLoCs, Singleton for others** - Proper lifecycle
7. **Keep entities simple** - Just data, no logic
8. **Models handle serialization** - Keep it in data layer
9. **Use barrel exports** - Clean imports
10. **Validate at boundaries** - Forms, API responses

---

## 📋 File Templates Quick Reference

Copy-paste ready templates for each layer:

| File                 | Template                                                              |
| -------------------- | --------------------------------------------------------------------- |
| Entity               | `class X extends Equatable { ... }`                                   |
| Model                | `class XModel extends X { fromJson(), toJson() }`                     |
| Repository Interface | `abstract class XRepository { Future<Either<Failure, T>> method(); }` |
| Repository Impl      | `class XRepositoryImpl implements XRepository { ... }`                |
| UseCase              | `class XUsecase implements UseCase<T, Params> { call() }`             |
| BLoC                 | `class XBloc extends Bloc<XEvent, XState> { on<Event>(handler); }`    |
| Event                | `abstract class XEvent extends Equatable { ... }`                     |
| State                | `abstract class XState extends Equatable { ... }`                     |

---

> 📌 **This guide is your blueprint for every Flutter project. Keep it updated as patterns evolve!**
