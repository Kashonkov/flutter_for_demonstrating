import 'package:flutter/foundation.dart';

abstract class BlocNews {}

class ErrorBlocNews extends BlocNews {
  final Exception exception;

  ErrorBlocNews(this.exception);
}

class ErrorWithPopBlocNews extends BlocNews {
  final Exception exception;

  ErrorWithPopBlocNews(this.exception);
}

/// [retry] - колбэк, который будет вызван при нажатии на кнопку "Повторить"
/// [hasCloseButton] - регулирует наличие крестика
class RetryErrorBlocNews extends BlocNews {
  final VoidCallback retry;
  final Exception exception;
  final bool hasCloseButton;

  RetryErrorBlocNews(this.retry, this.exception, {this.hasCloseButton = true});
}
