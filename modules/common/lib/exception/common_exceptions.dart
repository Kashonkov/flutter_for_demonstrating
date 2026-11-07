class UnknownException implements Exception {
  final Object? originalException;

  const UnknownException({this.originalException});
}

class AuthException implements Exception {

  const AuthException();
}


abstract class ExceptionWithId {
  /// id из заголовка ответа с бэкенда
  final String? id;

  const ExceptionWithId({required this.id});
}

abstract class HttpException extends ExceptionWithId {
  /// Класс, содержащий поля, приходящие с бэка в общем случае при возникновении ошибки
  const HttpException({super.id, this.code, this.statusMessage, this.customCode, this.message});

  /// HTTP-код ошибки
  final int? code;

  /// Сообщение, сопровождающее HTTP-код ошибки. Может быть технического характера
  final String? statusMessage;

  /// code из объекта error в теле ответа
  final String? customCode;

  /// Текстовое сообщение из объекта error в теле ответа
  final String? message;
}

/// Ошибка соединения (например, остуствие интернета)
class ConnectionException extends HttpException implements Exception {
  const ConnectionException({super.id});
}

/// Ошибка соединения (проблема с сервером)
class ServerConnectionException extends HttpException implements Exception {
  const ServerConnectionException({super.id});
}

/// Ошибка прерывания запроса
class CancelationException extends HttpException implements Exception {
  const CancelationException({super.id});
}

/// Ошибка со статус-кодом и сообщением от бэка (4XX)
class ServiceCodeException extends HttpException implements Exception {
  const ServiceCodeException({
    super.id,
    super.code,
    super.statusMessage,
    super.customCode,
    super.message,
  });
}

/// Ошибка при завершении срока действия токена сессии
class SessionExpiredException extends HttpException implements Exception {
  const SessionExpiredException({super.id});
}

/// Ошибка при истечении времени ожидания
class TimeoutException extends HttpException implements Exception {
  const TimeoutException({super.id});
}

/// Серверная ошибка, когда код = 5ХХ
class ServerErrorException extends HttpException implements Exception {
  const ServerErrorException({
    super.id,
    super.code,
    super.statusMessage,
    super.customCode,
    super.message,
  });
}
