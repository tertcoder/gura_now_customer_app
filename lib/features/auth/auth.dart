// ═══════════════════════════════════════════════════════════════════
// AUTH FEATURE - Barrel Export
// Follows the pattern in docs/ARCHITECTURE_GUIDE.md
// ═══════════════════════════════════════════════════════════════════

// Domain - Entities
export 'domain/entities/user.dart';

// Domain - Repositories (Interface)
export 'domain/repositories/auth_repository.dart';

// Domain - Use Cases
export 'domain/usecases/login_usecase.dart';
export 'domain/usecases/logout_usecase.dart';
export 'domain/usecases/register_usecase.dart';
export 'domain/usecases/get_me_usecase.dart';

// Data - Models
export 'data/models/user_model.dart';
export 'data/models/auth_response_model.dart';

// Data - Data Sources
export 'data/datasources/auth_remote_datasource.dart';

// Data - Repository Implementation
export 'data/repositories/auth_repository_impl.dart';

// Presentation - BLoC
export 'presentation/bloc/auth_bloc.dart';

// Presentation - Pages
export 'presentation/pages/forgot_password_screen.dart';
export 'presentation/pages/login_screen.dart';
export 'presentation/pages/onboarding_screen.dart';
export 'presentation/pages/otp_verification_screen.dart';
export 'presentation/pages/register_screen.dart';
export 'presentation/pages/reset_password_screen.dart';
export 'presentation/pages/splash_screen.dart';
export 'presentation/pages/welcome_screen.dart';
