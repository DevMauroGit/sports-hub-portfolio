import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:go_router/go_router.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthCubit() : super(AuthInitial());

  /// Checks the current user's authentication and verification status,
  /// then navigates accordingly using GoRouter.
  void checkUserStatus(GoRouter router) {
    final User? user = _auth.currentUser;

    if (user == null) {
      // User is not logged in
      emit(AuthUnauthenticated());
      router.go('/login');
    } else {
      // User is logged in, check email verification
      if (user.emailVerified) {
        // Email verified, check phone verification
        if (user.phoneNumber != null && user.phoneNumber!.length >= 4) {
          // Phone verified
          emit(AuthAuthenticated(user));
          router.go('/home');
        } else {
          // Phone verification required
          emit(AuthNeedsPhoneVerification(user));
          router.go('/verify-phone');
        }
      } else {
        // Email verification required
        emit(AuthNeedsEmailVerification(user));
        router.go('/verify-email');
      }
    }
  }

  /// Registers a new user with email and password.
  /// Emits loading state, then success or error states.
  Future<void> register(String email, String password) async {
    try {
      emit(AuthLoading());
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email, 
        password: password,
      );
      emit(AuthAuthenticated(userCredential.user!));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  /// Logs in a user using email and password.
  /// Emits loading state, then success or error states.
  Future<void> login(String email, String password, double w) async {
    try {
      emit(AuthLoading());
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      emit(AuthAuthenticated(userCredential.user!));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  /// Logs out the current user and emits unauthenticated state.
  Future<void> logout() async {
    await _auth.signOut();
    emit(AuthUnauthenticated());
  }
}
