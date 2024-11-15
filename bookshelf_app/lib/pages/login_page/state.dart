sealed class LoginPageState {}

class Idle extends LoginPageState {}

class Loading extends LoginPageState {}

class Success extends LoginPageState {}

class Error extends LoginPageState {
  final String message;

  Error(this.message);
}
