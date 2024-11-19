sealed class AuthResponse {}

class AuthSuccess extends AuthResponse {
  final String token;

  AuthSuccess(this.token);
}

class Unauthorized extends AuthResponse {
  Unauthorized();
}

class AuthError extends AuthResponse {
  final String message;

  AuthError(this.message);
}
