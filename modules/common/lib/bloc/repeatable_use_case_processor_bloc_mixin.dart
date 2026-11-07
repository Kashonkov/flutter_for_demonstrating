import 'dart:async';

import 'package:common/bloc/base_bloc.dart';
import 'package:common/bloc/news.dart';
import 'package:common/usecase/usecase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

mixin RepeatableUseCaseProcessorBlocMixin<EventT, StateT>
    on BaseBloc<EventT, StateT> {
  Function? _repeatableAction;

  Future<void> processUseCaseRepeatable<T>(
    Future<UseCaseResult<T>> Function() useCase, {
    required void Function(T result) onSuccess,
    void Function(Exception error)? onError,
  }) async {
    task() => _processUseCaseRepeatable(useCase, onSuccess: onSuccess, onError: onError);
    _repeatableAction = task;
    return task();
  }

  @protected
  Future<void> onRepeatEvent<T>(EventT event, Emitter emit) async {
    final task = _repeatableAction;
    if (task != null) {
      await task();
    }
  }

  Future<void> _processUseCaseRepeatable<T>(
    Future<UseCaseResult<T>> Function() useCase, {
    required void Function(T result) onSuccess,
    void Function(Exception error)? onError,
  }) async {
    final useCaseResult = await useCase();

    return _processRepeatableUseCaseResult(useCaseResult, onSuccess: onSuccess, onError: onError);
  }

  void _processRepeatableUseCaseResult<T>(
    UseCaseResult<T> useCaseResult, {
    required void Function(T result) onSuccess,
    void Function(Exception error)? onError,
  }) {
    if (useCaseResult.isSuccessful) {
      _repeatableAction = null;
      onSuccess(useCaseResult.result);
    } else {
      final handler = onError ?? handleRepeatableUseCaseError;
      handler.call(useCaseResult.exception);
    }
  }

  void handleRepeatableUseCaseError(Exception error) {
    final task = _repeatableAction;
    if (task == null) {
      addNews(ErrorBlocNews(error));
    } else {
      addNews(
        RetryErrorBlocNews(() {
          onRepeat();
        }, error),
      );
    }
  }

  @protected
  void onRepeat();
}
