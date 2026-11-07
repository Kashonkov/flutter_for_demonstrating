import 'dart:io';

import 'package:api/exception/auth_exception.dart';
import 'package:common/exception/common_exceptions.dart';
import 'package:dio/dio.dart';

/// Callback который будет срабатывать на конкретный статус код при response != null
typedef StatusCodeHandler = Exception? Function([Object? response]);

/// Функция для проверки результата запроса к бэку. Если в результате запроса возникает какая-либо ошибка,
/// она преобразуется в одну из ошибок из модуля "common_flutter" для дальнейшего использования
/// в приложении нового ДБО. Эта функция - обновленная версия checkNetErrors, которая работает с
/// новым форматом ошибок. Подробнее описано здесь:
Future<R> checkNetErrors<R>(Future<R> Function() code, {Map<int, StatusCodeHandler>? statusCodeHandlers}) async {
  try {
    final result = await code();
    // Проверка наличия миксина CommandEntity в result. Если присутствует, проверяем,
    // не нужно ли показать ошибку
    // if (result is CommandEntity) {
    //   if (result.command == ApiCommand.showError) {
    //     throw ResponseException(message: result.message);
    //   } else if (result.command == ApiCommand.tooManyRequests) {
    //     throw TooManyRequestsException(message: result.message);
    //   }
    // }
    return result;
  } on DioException catch (e) {
    final response = e.response;

    /// Должен совпадать с [idFromResponse]
    final idFromRequest = e.requestOptions.headers['x-call-id'];

    if (response == null) {
      if (e.error is SocketException) {
        // Ошибка соединения (нет интернета)
        throw ConnectionException(id: idFromRequest);
      }

      if ([
        DioExceptionType.connectionError,
        DioExceptionType.sendTimeout,
        DioExceptionType.receiveTimeout,
      ].contains(e.type)) {
        // Таймаут
        throw TimeoutException(id: idFromRequest);
      }

      if(e.response?.statusCode == 401){
        throw AuthException();
      }

      // Ошибка соединения (серверная)
      throw ServerConnectionException(id: idFromRequest);
    }

    /// Должен совпадать с [idFromRequest]
    final requestId = response.headers.value('x-call-id') ?? idFromRequest;

    final statusCode = response.statusCode;
    if (statusCode == null) {
      // Неизвестная ошибка
      throw UnknownException(originalException: e);
    }

    /// Проверка кастомного обработчика и его вызов
    if (statusCodeHandlers != null && statusCodeHandlers.isNotEmpty && statusCodeHandlers.containsKey(statusCode)) {
      try {
        statusCodeHandlers[statusCode]?.call(response.data);
      } catch (_) {
        rethrow;
      }
    }

    // Далее рассматриваем ошибки с определенными статус-кодами
    if (statusCode == 401 || e is AuthTokenInvalidException) {
      throw SessionExpiredException(id: requestId);
    }

    // Получаем customCode и message из объекта error, если таковой имеется в ответе
    String? customCode;
    String? message;
    final mapErrorData = response.data is Map<String, dynamic> ? response.data as Map<String, dynamic> : null;
    final error = mapErrorData?['error'];
    if (error != null) {
      customCode = error['code'];
      message = error?['message'];
    }

    // // Проверяем, есть ли массив fieldErrors с объектами ошибок полей. Если есть, формируем
    // // ошибку валидации ValidationException
    // final fieldErrors = response.data['fieldErrors'];
    // if (fieldErrors != null && fieldErrors is List<Map>) {
    //   final fieldErrorObjects = <FieldError>[];
    //   for (var fieldError in fieldErrors) {
    //     fieldErrorObjects.add(FieldError(
    //       field: fieldError['field'],
    //       message: fieldError['message'],
    //     ));
    //   }
    //   throw ValidationException(
    //     callId: callId,
    //     eventId: eventId,
    //     customCode: customCode,
    //     message: message,
    //     fieldErrors: fieldErrorObjects,
    //   );
    // }

    if (statusCode ~/ 100 == 5) {
      // 500-e ошибки
      throw ServerErrorException(
        id: requestId, // idFromRequest и idFromResponse должны совпадать
        code: statusCode,
        statusMessage: response.statusMessage,
        customCode: customCode,
        message: message,
      );
    }

    if (e.type == DioExceptionType.cancel) {
      // Ошибка прерывания запроса
      // idFromRequest и idFromResponse должны совпадать
      throw CancelationException(id: requestId);
    }

    // 400-e ошибки
    throw ServiceCodeException(
      id: requestId, // idFromRequest и idFromResponse должны совпадать
      code: statusCode,
      statusMessage: response.statusMessage,
      customCode: customCode,
      message: message,
    );
  } catch (e) {
    rethrow;
  }
}
