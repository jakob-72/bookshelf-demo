sealed class RegisterResponse {
  const RegisterResponse();

  void when({
    required Function() registerSuccess,
    required Function() registerConflict,
    required Function(String message) registerError,
  }) {
    if (this is _Success) {
      registerSuccess();
    } else if (this is _Conflict) {
      registerConflict();
    } else if (this is _Error) {
      registerError((this as _Error).message);
    }
  }

  factory RegisterResponse.success() = _Success;

  factory RegisterResponse.conflict() = _Conflict;

  factory RegisterResponse.error(String message) = _Error;
}

class _Success extends RegisterResponse {}

class _Conflict extends RegisterResponse {}

class _Error extends RegisterResponse {
  final String message;

  _Error(this.message);
}
