part of 'auth_cubit.dart';

@immutable
abstract class AuthState {}

/// Initial state when the authentication process has not started yet.
class AuthInitial extends AuthState {}

/// State emitted while an authentication-related operation is in progress.
class AuthLoading extends AuthState {}

/// State emitted when the user is successfully authenticated.
/// Contains the authenticated [User] object.
class AuthAuthenticated extends AuthState {
  final User user;
  AuthAuthenticated(this.user);
}

/// State emitted when no user is authenticated.
class AuthUnauthenticated extends AuthState {}

/// State emitted when the user is authenticated but their email
/// has not yet been verified.
/// Contains the [User] who needs to verify their email.
class AuthNeedsEmailVerification extends AuthState {
  final User user;
  AuthNeedsEmailVerification(this.user);
}

/// State emitted when the user is authenticated and email verified,
/// but phone verification is still required.
/// Contains the [User] who needs to verify their phone.
class AuthNeedsPhoneVerification extends AuthState {
  final User user;
  AuthNeedsPhoneVerification(this.user);
}

/// State emitted when an authentication error occurs.
/// Contains a descriptive error message.
class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}
