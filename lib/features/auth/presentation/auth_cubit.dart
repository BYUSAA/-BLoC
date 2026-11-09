import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/auth_exception.dart';
import '../domain/auth_repository.dart';

enum AuthStatus { unknown, unauthenticated, authenticated }

class AuthState extends Equatable {
  const AuthState({
    this.status = AuthStatus.unknown,
    this.isBusy = false,
    this.error,
    this.notice,
  });

  final AuthStatus status;
  final bool isBusy;
  final String? error;
  final String? notice;

  AuthState copyWith({
    AuthStatus? status,
    bool? isBusy,
    String? error,
    String? notice,
    bool clearError = false,
    bool clearNotice = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      isBusy: isBusy ?? this.isBusy,
      error: clearError ? null : error ?? this.error,
      notice: clearNotice ? null : notice ?? this.notice,
    );
  }

  @override
  List<Object?> get props => [status, isBusy, error, notice];
}

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._repository) : super(const AuthState());

  final AuthRepository _repository;

  Future<void> restoreSession() async {
    if (isClosed) return;

    if (_repository.emailVerificationRequired) {
      try {
        await _repository.signOut();
      } catch (_) {
        // Never grant workspace access to an unverified password account.
      }
      if (!isClosed) {
        emit(const AuthState(status: AuthStatus.unauthenticated));
      }
      return;
    }

    if (!isClosed) {
      emit(
        AuthState(
          status: _repository.hasActiveSession
              ? AuthStatus.authenticated
              : AuthStatus.unauthenticated,
        ),
      );
    }
  }

  Future<void> submit(
    String email,
    String password, {
    required bool register,
  }) async {
    if (isClosed || state.isBusy) return;

    emit(
      state.copyWith(
        isBusy: true,
        clearError: true,
        clearNotice: true,
      ),
    );

    try {
      if (register) {
        await _repository.register(email, password);
        if (!isClosed) {
          emit(
            const AuthState(
              status: AuthStatus.unauthenticated,
              notice:
                  'Account created. Check your email for the verification link, then sign in.',
            ),
          );
        }
        return;
      }

      await _repository.signIn(email, password);
      if (!isClosed) {
        emit(const AuthState(status: AuthStatus.authenticated));
      }
    } catch (error) {
      if (!isClosed) {
        emit(
          AuthState(
            status: AuthStatus.unauthenticated,
            error: _messageFor(error),
          ),
        );
      }
    }
  }

  Future<void> googleSignIn() async {
    if (isClosed || state.isBusy) return;

    emit(
      state.copyWith(
        isBusy: true,
        clearError: true,
        clearNotice: true,
      ),
    );

    try {
      final signedIn = await _repository.signInWithGoogle();
      if (!isClosed) {
        emit(
          AuthState(
            status: signedIn
                ? AuthStatus.authenticated
                : AuthStatus.unauthenticated,
          ),
        );
      }
    } catch (error) {
      if (!isClosed) {
        emit(
          AuthState(
            status: AuthStatus.unauthenticated,
            error: _messageFor(error),
          ),
        );
      }
    }
  }

  Future<void> resetPassword(String email) async {
    if (isClosed || state.isBusy) return;

    emit(
      state.copyWith(
        isBusy: true,
        clearError: true,
        clearNotice: true,
      ),
    );

    try {
      await _repository.sendPasswordReset(email);
      if (!isClosed) {
        emit(
          const AuthState(
            status: AuthStatus.unauthenticated,
            notice: 'Password reset instructions have been sent to your email.',
          ),
        );
      }
    } catch (error) {
      if (!isClosed) {
        emit(
          AuthState(
            status: AuthStatus.unauthenticated,
            error: _messageFor(error),
          ),
        );
      }
    }
  }

  Future<void> signOut() async {
    if (isClosed || state.isBusy) return;

    emit(state.copyWith(isBusy: true, clearError: true));
    try {
      await _repository.signOut();
      if (!isClosed) {
        emit(const AuthState(status: AuthStatus.unauthenticated));
      }
    } catch (error) {
      if (!isClosed) {
        emit(
          state.copyWith(
            isBusy: false,
            error: _messageFor(error),
          ),
        );
      }
    }
  }

  void clearFeedback() {
    if (!isClosed) {
      emit(state.copyWith(clearError: true, clearNotice: true));
    }
  }

  String _messageFor(Object error) {
    if (error is AuthException) return error.message;
    return 'Something went wrong. Please try again.';
  }
}
