import '../../../core/errors/app_exception.dart';

class AuthException extends AppException {
  const AuthException({
    required super.code,
    required super.message,
    super.cause,
  });
}
