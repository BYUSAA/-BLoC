import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/auth_repository_impl.dart';

enum AuthStatus { unknown, unauthenticated, loading, authenticated }
class AuthState {
  const AuthState({this.status = AuthStatus.unknown, this.error});
  final AuthStatus status;
  final String? error;
  AuthState copyWith({AuthStatus? status, String? error, bool clearError = false}) => AuthState(
    status: status ?? this.status,
    error: clearError ? null : error ?? this.error,
  );
}
class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._repository) : super(const AuthState());
  final AuthRepositoryImpl _repository;
  Future<void> restoreSession() async {
    emit(AuthState(status: _repository.currentUser == null ? AuthStatus.unauthenticated : AuthStatus.authenticated));
  }
  Future<void> submit(String email, String password, {required bool register}) async {
    emit(state.copyWith(status: AuthStatus.loading, clearError: true));
    try {
      if (register) await _repository.register(email, password);
      else await _repository.signIn(email, password);
      emit(const AuthState(status: AuthStatus.authenticated));
    } on FirebaseAuthException catch (error) {
      emit(AuthState(status: AuthStatus.unauthenticated, error: error.message ?? 'Authentication failed.'));
    } catch (_) {
      emit(const AuthState(status: AuthStatus.unauthenticated, error: 'Something went wrong. Please try again.'));
    }
  }
  Future<void> googleSignIn() async {
    emit(state.copyWith(status: AuthStatus.loading, clearError: true));
    try {
      await _repository.signInWithGoogle();
      emit(const AuthState(status: AuthStatus.authenticated));
    } on FirebaseAuthException catch (error) {
      emit(AuthState(status: AuthStatus.unauthenticated, error: error.message ?? 'Google sign-in failed.'));
    } catch (_) {
      emit(const AuthState(status: AuthStatus.unauthenticated, error: 'Google sign-in was cancelled or failed.'));
    }
  }
  Future<void> resetPassword(String email) async {
    try { await _repository.sendPasswordReset(email); }
    catch (error) { emit(state.copyWith(error: error.toString())); }
  }
  Future<void> signOut() async {
    await _repository.signOut();
    emit(const AuthState(status: AuthStatus.unauthenticated));
  }
}
