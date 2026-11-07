import 'dart:async';
import 'dart:collection';

import 'package:api/jwt/domain/entity/exceptions.dart';
import 'package:api/jwt/domain/entity/token_status.dart';
import 'package:api/jwt/domain/use_case/force_refresh_jwt_tokens_use_case.dart';
import 'package:api/jwt/domain/use_case/get_token_status_stream_use_case.dart';
import 'package:common/usecase/usecase.dart';
import 'package:dio/dio.dart';

const _authorizeErrorCode = 401;

class RefreshTokenInterceptor extends Interceptor {
  final ForceRefreshJwtTokensUseCase forceRefreshTokenUseCase;
  final GetTokenStatusStreamUseCase getTokenStatusStreamUseCase;
  final Dio dio;

  final Queue<_RequestParams> _requestList = Queue();
  final Queue<_RetryParams> _retriesList = Queue();
  late StreamSubscription _subscription;
  TokenStatus lastStatus = TokenStatus.notActive;

  RefreshTokenInterceptor({
    required this.dio,
    required this.forceRefreshTokenUseCase,
    required this.getTokenStatusStreamUseCase,
  }) {
    final stream = getTokenStatusStreamUseCase(EmptyUsecaseParams()).result;
    _subscription = stream.listen((status) {
      if (lastStatus == TokenStatus.refreshing && status == TokenStatus.active) {
        _unlock();
      } else if (status == TokenStatus.error) {
        _unlockWithError();
      }
      lastStatus = status;
    });
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    switch (lastStatus) {
      case TokenStatus.notActive:
        handler.reject(DioException(requestOptions: options, error: TokenNotActiveException()));
        break;
      case TokenStatus.active:
        handler.next(options);
        break;
      case TokenStatus.refreshing:
        _requestList.add(_RequestParams(options, handler));
        break;
      case TokenStatus.error:
        handler.reject(DioException(requestOptions: options, error: RefreshTokenException()));
        break;
      case TokenStatus.expired:
        forceRefreshTokenUseCase(EmptyUsecaseParams());
        _requestList.add(_RequestParams(options, handler));
    }
  }

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    final response = err.response;
    if (response?.statusCode == _authorizeErrorCode) {
      forceRefreshTokenUseCase(EmptyUsecaseParams());
      _scheduleRetry(err.requestOptions, handler);
    } else {
      handler.next(err);
    }
  }

  void _unlock() async {
    while (_retriesList.isNotEmpty) {
      final retry = _retriesList.removeFirst();
      try {
        final result = await dio.fetch(retry.options);
        retry.handler.resolve(result);
      } on DioException catch (e) {
        retry.handler.next(e);
      }
    }
    while (_requestList.isNotEmpty) {
      final request = _requestList.removeFirst();
      request.handler.next(request.options);
    }
  }

  void _unlockWithError() {
    while (_retriesList.isNotEmpty) {
      final retry = _retriesList.removeFirst();
      retry.handler.reject(DioException(requestOptions: retry.options, error: RefreshTokenException()));
    }
    while (_requestList.isNotEmpty) {
      final request = _requestList.removeFirst();
      request.handler.reject(DioException(requestOptions: request.options, error: RefreshTokenException()));
    }
  }

  _scheduleRetry(RequestOptions options, ErrorInterceptorHandler handler) {
    _retriesList.add(_RetryParams(options, handler));
  }

  Future<void> close() => _subscription.cancel();
}

class _RequestParams {
  final RequestOptions options;
  final RequestInterceptorHandler handler;

  _RequestParams(this.options, this.handler);
}

class _RetryParams {
  final RequestOptions options;
  final ErrorInterceptorHandler handler;

  _RetryParams(this.options, this.handler);
}
