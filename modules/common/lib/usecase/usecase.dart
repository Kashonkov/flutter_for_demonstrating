import 'package:common/exception/common_exceptions.dart';
import 'package:common/usecase/exceptions.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

abstract class BaseUseCase<Type, Params> {
  const BaseUseCase();

  @protected
  Object call(Params params);

  /// Формирует [UseCaseResult.error] из исключения, которое пришло в блок catch при вызове [call].
  /// Если тип исключения - [Exception], то оно же и передается в конструктор [UseCaseResult.error].
  /// Если это что-то другое (например, [Object]), то в конструктор передается [UnknownException].
  UseCaseResult<Type> useCaseResultFromException(Object e, {required StackTrace trace}) {
    if (!kReleaseMode) {
      print('Exception: $e\nTrace: $trace');
    }

    if (e is Exception) {
      return UseCaseResult.error(e);
    }

    return UseCaseResult.error(UnknownException(originalException: e));
  }
}

abstract class UseCase<Type, Params> extends BaseUseCase<Type, Params> {
  const UseCase();

  @override
  Future<UseCaseResult<Type>> call(Params params);

  @protected
  Future<UseCaseResult<Type>> innerCall(Future<Type> Function() func) async {
    try {
      final result = await func.call();
      return UseCaseResult.successful(result);
    } catch (e, trace) {
      return useCaseResultFromException(e, trace: trace);
    }
  }
}

abstract class StreamUseCase<Type, Params> extends BaseUseCase<Type, Params> {
  const StreamUseCase();

  @override
  Stream<UseCaseResult<Type>> call(Params params);

  Future<void> cancel();

  @protected
  Future<UseCaseResult<Type>> innerCall(Future<Type> Function() func) async {
    try {
      final result = await func.call();
      return UseCaseResult.successful(result);
    } catch (e, trace) {
      return useCaseResultFromException(e, trace: trace);
    }
  }
}

abstract class SyncUseCase<Type, Params> extends BaseUseCase<Type, Params> {
  const SyncUseCase();

  @override
  UseCaseResult<Type> call(Params params);

  @protected
  UseCaseResult<Type> innerCall(Type Function() func) {
    try {
      final result = func.call();
      return UseCaseResult.successful(result);
    } catch (e, trace) {
      return useCaseResultFromException(e, trace: trace);
    }
  }
}

class EmptyUsecaseParams {}

/// Базовый класс для работы с результатами выполнения юзкейсов.
/// Создавать экземпляры предполагается одним из двух фабричных конструкторов в рамках реализации
/// [UseCase], [StreamUseCase], [SyncUseCase].
/// [UseCaseResult.successful] создает экземпляр подкласса [SuccessfulUseCaseResult], который хранит
/// в себе значение типа [T]. Обратиться к нему можно через геттер [result].
/// [UseCaseResult.error] создает экземпляр подкласса [ErrorUseCaseResult], который хранит
/// в себе исключение произвольного типа. Обратиться к нему можно через геттер [exception].
/// При обращении к этим геттерам важно сначала проверять, какого типа является данный
/// [UseCaseResult] с помощью геттера [isSuccessful], поскольку обращение к полю [result] у [ErrorUseCaseResult],
/// как и обращение к полю [exception] у [SuccessfulUseCaseResult], выдаст исключение ([UseCaseResultTypeException]).
/// [UseCaseResult] наследуется от [Equatable], так что его экземпляры можно сравнивать оператором [==], который
/// вернет [True], если это экземпляры одного типа, и лежащие в них [result] либо [exception] равны.
///
/// ## Пример работы с [UseCaseResult]:
/// ```dart
/// _processTryAgainPressedEvent() async {
///   final resetUseCaseResult = await resetUseCase(ResetRequest(state.contextId!));
///   if (result.isSuccessful) {
///     emit(state.setResetResult(resetUseCaseResult.result));
///   } else {
///     onFailure(result.exception.toString());
///   }
/// }
/// ```
abstract class UseCaseResult<T> extends Equatable {
  const UseCaseResult();

  factory UseCaseResult.successful(T result) => SuccessfulUseCaseResult(result);

  factory UseCaseResult.error(Exception error) => ErrorUseCaseResult(error);

  bool get isSuccessful => this is SuccessfulUseCaseResult;

  T get result {
    if (this is SuccessfulUseCaseResult) {
      return (this as SuccessfulUseCaseResult).result_;
    }
    throw isNotSuccessfulUseCaseResultTypeException;
  }

  Exception get exception {
    if (this is ErrorUseCaseResult) {
      return (this as ErrorUseCaseResult).exception_;
    }
    throw isNotErrorUseCaseResultTypeException;
  }

  @override
  List<Object?> get props => [isSuccessful ? result : exception];
}

class SuccessfulUseCaseResult<T> extends UseCaseResult<T> {
  final T result_;

  const SuccessfulUseCaseResult(this.result_);
}

class ErrorUseCaseResult<T> extends UseCaseResult<T> {
  final Exception exception_;

  const ErrorUseCaseResult(this.exception_);
}

/// Замена для [Void] в UseCaseResult<void>
class EmptyUseCaseResult {
  const EmptyUseCaseResult();
}
