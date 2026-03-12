part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Check auth status on app start (token + getMe).
class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

/// User requested login.
class AuthLoginRequested extends AuthEvent {
  const AuthLoginRequested({
    required this.phoneNumber,
    required this.password,
  });

  final String phoneNumber;
  final String password;

  @override
  List<Object?> get props => [phoneNumber, password];
}

/// User requested registration.
class AuthRegisterRequested extends AuthEvent {
  const AuthRegisterRequested({
    required this.fullName,
    required this.phoneNumber,
    required this.password,
    required this.role,
    this.email,
  });

  final String fullName;
  final String phoneNumber;
  final String password;
  final String role;
  final String? email;

  @override
  List<Object?> get props => [fullName, phoneNumber, password, role, email];
}

/// User requested logout.
class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

/// Force set unauthenticated (e.g. after 401).
class AuthSetUnauthenticatedRequested extends AuthEvent {
  const AuthSetUnauthenticatedRequested();
}
