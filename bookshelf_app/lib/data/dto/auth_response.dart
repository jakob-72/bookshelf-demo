sealed class AuthResponse {
  const AuthResponse();

  void when({
    required Function(String token) success,
    required Function() unauthorized,
    required Function(String) error,
  }) {
    if (this is _Success) {
      success((this as _Success).token);
    } else if (this is _Unauthorized) {
      unauthorized();
    } else if (this is _Error) {
      error((this as _Error).message);
    }
  }

  factory AuthResponse.success(String token) = _Success;

  factory AuthResponse.unauthorized() = _Unauthorized;

  factory AuthResponse.error(String message) = _Error;
}

class _Success extends AuthResponse {
  final String token;

  _Success(this.token);
}

class _Unauthorized extends AuthResponse {}

class _Error extends AuthResponse {
  final String message;

  _Error(this.message);
}
