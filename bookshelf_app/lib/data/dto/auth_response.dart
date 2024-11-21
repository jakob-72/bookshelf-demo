sealed class AuthResponse {}

class AuthSuccess extends AuthResponse {
  final String token;

  AuthSuccess(this.token);
}

class RegisterSuccess extends AuthResponse {}

class Unauthorized extends AuthResponse {
  Unauthorized();
}

class RegisterConflict extends AuthResponse {}

class AuthError extends AuthResponse {
  final String message;

  AuthError(this.message);
}
