import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/auth_repository_impl.dart';

enum AuthStatus { unknown, unauthenticated, loading, authenticated }

class AuthState {
  const AuthState({
    this.status = AuthStatus.unknown,
    this.error,
    this.notice,
  });

  final AuthStatus status;
  final String? error;
  final String? notice;

  AuthState copyWith({
    AuthStatus? status,
    String? error,
    String? notice,
    bool clearError = false,
    bool clearNotice = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      error: clearError ? null : error ?? this.error,
      notice: clearNotice ? null : notice ?? this.notice,
    );
  }
}

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._repository) : super(const AuthState());

  final AuthRepositoryImpl _repository;

  Future<void> restoreSession() async {
    emit(
      AuthState(
        status: _repository.currentUser == null
            ? AuthStatus.unauthenticated
            : AuthStatus.authenticated,
      ),
    );
  }

  Future<void> submit(
    String email,
    String password, {
    required bool register,
  }) async {
    emit(
      state.copyWith(
        status: AuthStatus.loading,
        clearError: true,
        clearNotice: true,
      ),
    );

    try {
      if (register) {
        await _repository.register(email, password);
        emit(
          const AuthState(
            status: AuthStatus.unauthenticated,
            notice:
                'Account created. Check your email for the verification link, then sign in.',
          ),
        );
        return;
      }

      await _repository.signIn(email, password);
      emit(const AuthState(status: AuthStatus.authenticated));
    } on FirebaseAuthException catch (error) {
      emit(
        AuthState(
          status: AuthStatus.unauthenticated,
          error: error.message ?? 'Authentication failed.',
        ),
      );
    } catch (_) {
      emit(
        const AuthState(
          status: AuthStatus.unauthenticated,
          error: 'Something went wrong. Please try again.',
        ),
      );
    }
  }

  Future<void> googleSignIn() async {
    emit(
      state.copyWith(
        status: AuthStatus.loading,
        clearError: true,
        clearNotice: true,
      ),
    );

    try {
      final signedIn = await _repository.signInWithGoogle();
      emit(
        AuthState(
          status: signedIn
              ? AuthStatus.authenticated
              : AuthStatus.unauthenticated,
        ),
      );
    } on FirebaseAuthException catch (error) {
      emit(
        AuthState(
          status: AuthStatus.unauthenticated,
          error: error.message ?? 'Google sign-in failed.',
        ),
      );
    } catch (_) {
      emit(
        const AuthState(
          status: AuthStatus.unauthenticated,
          error: 'Google sign-in failed. Please try again.',
        ),
      );
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _repository.sendPasswordReset(email);
      emit(
        state.copyWith(
          clearError: true,
          notice: 'Password reset instructions have been sent to your email.',
        ),
      );
    } on FirebaseAuthException catch (error) {
      emit(
        state.copyWith(
          error: error.message ?? 'Unable to send password reset email.',
        ),
      );
    } catch (_) {
      emit(state.copyWith(error: 'Unable to send password reset email.'));
    }
  }

  Future<void> signOut() async {
    try {
      await _repository.signOut();
      emit(const AuthState(status: AuthStatus.unauthenticated));
    } catch (_) {
      emit(state.copyWith(error: 'Unable to sign out. Please try again.'));
    }
  }
}
