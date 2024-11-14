sealed class AuthResponse {}

class AuthResponseSuccess extends AuthResponse {
  final String token;

  AuthResponseSuccess(this.token);
}

class AuthResponseUnauthorized extends AuthResponse {
  AuthResponseUnauthorized();
}

class AuthResponseInternalError extends AuthResponse {
  final String message;

  AuthResponseInternalError(this.message);
}
