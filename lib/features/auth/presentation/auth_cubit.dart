import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/auth_repository.dart';

enum AuthStatus { unknown, unauthenticated, loading, authenticated }

class AuthState extends Equatable {
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

  @override
  List<Object?> get props => [status, error, notice];
}

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._repository) : super(const AuthState());

  final AuthRepository _repository;

  Future<void> restoreSession() async {
    if (_repository.emailVerificationRequired) {
      try {
        await _repository.signOut();
      } catch (_) {
        // A blocked, unverified session must never enter the workspace.
      }
      emit(const AuthState(status: AuthStatus.unauthenticated));
      return;
    }

    emit(
      AuthState(
        status: _repository.hasActiveSession
            ? AuthStatus.authenticated
            : AuthStatus.unauthenticated,
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
    } catch (_) {
      emit(
        const AuthState(
          status: AuthStatus.unauthenticated,
          error:
              'Authentication failed. Check your details and verify your email if you just registered.',
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
    } catch (_) {
      emit(
        const AuthState(
          status: AuthStatus.unauthenticated,
          error: 'Google sign-in failed. Check the OAuth configuration.',
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
    } catch (_) {
      emit(
        state.copyWith(
          clearNotice: true,
          error: 'Unable to send password reset email. Check the email address.',
        ),
      );
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
