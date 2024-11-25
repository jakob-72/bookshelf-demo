sealed class RegisterResponse {
  void when({
    required Function(RegisterSuccess) registerSuccess,
    required Function(RegisterConflict) registerConflict,
    required Function(RegisterError) registerError,
  }) {
    if (this is RegisterSuccess) {
      registerSuccess(this as RegisterSuccess);
    } else if (this is RegisterConflict) {
      registerConflict(this as RegisterConflict);
    } else if (this is RegisterError) {
      registerError(this as RegisterError);
    }
  }
}

class RegisterSuccess extends RegisterResponse {}

class RegisterConflict extends RegisterResponse {}

class RegisterError extends RegisterResponse {
  final String message;

  RegisterError(this.message);
}
