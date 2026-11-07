import 'package:common/exception/common_exceptions.dart';
import 'package:common/exception/error_handler.dart';
import 'package:flutter/material.dart';
import 'package:lxe_app/l10n/app_localizations.dart';

class DefaultErrorHandler extends ErrorHandler {
  @override
  ErrorMessage proceed(BuildContext context, Exception error) {
    final localization = AppLocalizations.of(context);
    return switch (error) {
      ConnectionException() => _onConnectionError(localization),
      TimeoutException() => _onTimeoutError(localization),
      ServerConnectionException() => _onServerError(localization),
      ServerErrorException() => _onServerError(localization),
      ServiceCodeException() => _onServerError(localization),
      _ => _onOtherException(localization),
    };
  }

  ErrorMessage _onConnectionError(AppLocalizations localization) {
    final message = localization.connectionError;
    return ErrorMessage(message: message);
  }

  ErrorMessage _onTimeoutError(AppLocalizations localization) {
    final message = localization.connectionTimeoutError;
    return ErrorMessage(message: message);
  }

  ErrorMessage _onServerError(AppLocalizations localization) {
    final message = localization.serverError;
    return ErrorMessage(message: message);
  }

  ErrorMessage _onOtherException(AppLocalizations localization) {
    final message = localization.unknownExceptionErrorText;
    return ErrorMessage(message: message);
  }
}
