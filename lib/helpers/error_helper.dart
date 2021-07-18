import 'package:shop_app/models/http_exception.dart';

String getErrorMessage(HttpException error) {
  switch (error.toString()) {
    case 'EMAIL_EXISTS': return 'User already exists';
    case 'OPERATION_NOT_ALLOWED': return 'Authentication not allowed';
    case 'TOO_MANY_ATTEMPTS_TRY_LATER': return 'Too many attempts. Please try again later.';
    case 'EMAIL_NOT_FOUND': return 'Email or password is wrong.';
    case 'INVALID_PASSWORD': return 'Email or password is wrong.';
    case 'USER_DISABLED': return 'This account has been blocked';
    case 'WEAK_PASSWORD': return 'This password is too weak.';
  }
  return 'Authentication failed.';
}
