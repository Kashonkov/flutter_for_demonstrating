sealed class LoginScreenState {}

final class InputState extends LoginScreenState {
  final String? emailError;
  final String? passwordError;

  InputState({this.emailError, this.passwordError});
}

final class LoadingState extends LoginScreenState {}
