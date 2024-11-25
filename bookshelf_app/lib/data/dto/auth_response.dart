sealed class AuthResponse {
  void when({
    required Function(AuthSuccess) authSuccess,
    required Function(Unauthorized) unauthorized,
    required Function(String) authError,
  }) {
    if (this is AuthSuccess) {
      authSuccess(this as AuthSuccess);
    } else if (this is Unauthorized) {
      unauthorized(this as Unauthorized);
    } else if (this is AuthError) {
      authError((this as AuthError).message);
    }
  }
}

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
