import 'dart:async';

import 'package:common/bloc/bloc_news_mixin.dart';
import 'package:common/bloc/news.dart';
import 'package:common/usecase/usecase.dart';

mixin UseCaseProcessorMixin on BlocNewsMixin {
  final List<StreamSubscription<UseCaseResult>> subscriptions = [];

  void initProcessor() {
    newsStream = newsController.stream;
  }

  void _processUseCaseResult<T>(
    UseCaseResult<T> useCaseResult, {
    required void Function(T result) onSuccess,
    void Function(Exception error)? onError,
  }) {
    if (useCaseResult.isSuccessful) {
      onSuccess(useCaseResult.result);
    } else {
      final handler = onError ?? handleUseCaseError;
      handler.call(useCaseResult.exception);
    }
  }

  Future<void> processUseCase<T>(
    Future<UseCaseResult<T>> Function() useCase, {
    required void Function(T result) onSuccess,
    void Function(Exception error)? onError,
  }) async {
    final useCaseResult = await useCase();

    _processUseCaseResult(useCaseResult, onSuccess: onSuccess, onError: onError);
  }

  void processSyncUseCase<T>(
    UseCaseResult<T> useCaseResult, {
    required void Function(T result) onSuccess,
    void Function(Exception error)? onError,
  }) {
    _processUseCaseResult(useCaseResult, onSuccess: onSuccess, onError: onError);
  }

  StreamSubscription<UseCaseResult<T>> processStreamUseCase<T>(
    Stream<UseCaseResult<T>> Function() useCase, {
    required void Function(T result) onSuccess,
    void Function(Object error)? onError,
  }) {
    final subscription = useCase().listen(
      (useCaseResult) =>
          _processUseCaseResult(useCaseResult, onSuccess: onSuccess, onError: onError),
    );
    subscriptions.add(subscription);
    return subscription;
  }

  void handleUseCaseError(Exception error) {
    addNews(ErrorBlocNews(error));
  }

  Future<void> closeProcessor() async {
    await newsController.close();
    await Future.wait(subscriptions.map((e) => e.cancel()));
  }
}
