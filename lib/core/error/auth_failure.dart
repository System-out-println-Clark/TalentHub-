sealed class AuthFailure {
  final String message;
  const AuthFailure(this.message);
}

class InvalidCredentialsFailure extends AuthFailure {
  const InvalidCredentialsFailure([super.message = 'Invalid email or password']);
}

class NetworkFailure extends AuthFailure {
  const NetworkFailure([super.message = 'No internet connection available']);
}

class UserAlreadyExistsFailure extends AuthFailure {
  const UserAlreadyExistsFailure([super.message = 'An account with this email already exists']);
}

class ServerFailure extends AuthFailure {
  const ServerFailure([super.message = 'A server error occurred. Please try again later']);
}

class UnknownAuthFailure extends AuthFailure {
  const UnknownAuthFailure([super.message = 'An unexpected error occurred']);
}
