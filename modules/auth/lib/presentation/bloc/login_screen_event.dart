sealed class LoginScreenEvent {}

final class OnEmailChangedEvent extends LoginScreenEvent {
  final String email;

  OnEmailChangedEvent(this.email);
}

final class OnPasswordChangedEvent extends LoginScreenEvent {
  final String password;

  OnPasswordChangedEvent(this.password);
}

final class OnLoginClickedEvent extends LoginScreenEvent {}