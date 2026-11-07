import 'dart:async';

import 'package:api/jwt/domain/entity/access_token_info.dart';
import 'package:api/jwt/domain/entity/exceptions.dart';
import 'package:api/jwt/domain/entity/refresh_token_info.dart';
import 'package:api/jwt/domain/entity/token_pair_info.dart';
import 'package:api/jwt/domain/entity/token_status.dart';
import 'package:api/jwt/domain/repository/jwt_token_repository.dart';
import 'package:api/jwt/domain/use_case/jwt_error_handler.dart';
import 'package:api/jwt/domain/use_case/refresh_jwt_tokens_use_case.dart';
import 'package:common/index.dart';
import 'package:rxdart/rxdart.dart';

typedef CustomErrorHandler = Function(Exception exception);

abstract interface class TokenInteractor {
  /// Получаем поток статусов актуального состояния токена
  Stream<TokenStatus> getStatusStream();

  /// Вызывается при первоначальной токенов
  /// [errorHandler] - кастомный обработчик ошибки
  Future init({CustomErrorHandler? errorHandler});

  /// Вызывается когда необходимо обновить токен(например при получении 401 ошибки или при старте)
  /// оп умолчанию в случвае ошибки в этом методе вызывается SessionExpiredDelegate,
  /// но с помощью [errorHandler] поведение можно изменить,
  /// [errorHandler] - кастомный обработчик ошибки
  Future refreshToken({CustomErrorHandler? errorHandler});

  /// Вызывается когда необходимо принудительно установить новую пару токенов минуя стандартный механизм обмена
  Future forceSetToken(TokenPairInfo tokenPairInfo);

  /// Вызывается когда необходимо удалить данные jwt токена
  Future invalidateTokens();
}

class TokenInteractorImpl implements TokenInteractor {
  final JwtTokenRepository tokenRepository;
  final JwtErrorHandler jwtErrorHandler;
  final RefreshJwtTokensUseCase refreshTokensUseCase;

  Timer? _timer;

  /// Указывает за сколько секунд до истечения жизни аксесс токена начинать обновления в секундах
  final _threshold = 5;

  Completer? _refreshCompleter;

  final BehaviorSubject<TokenStatus> _controller = BehaviorSubject();
  late TokenStatus _lastStatus;

  TokenInteractorImpl({
    required this.tokenRepository,
    required this.refreshTokensUseCase,
    required this.jwtErrorHandler,
  }) {
    _changeStatus(TokenStatus.notActive);
  }

  @override
  Stream<TokenStatus> getStatusStream() => _controller.stream;

  @override
  Future init({CustomErrorHandler? errorHandler}) => _refreshToken(errorHandler: errorHandler);

  @override
  Future refreshToken({CustomErrorHandler? errorHandler}) =>
      _refreshToken(errorHandler: errorHandler);

  @override
  Future forceSetToken(TokenPairInfo tokenPairInfo) => _forceSetToken(tokenPairInfo);

  @override
  Future invalidateTokens() async {
    _stopRefreshTimer();
    _changeStatus(TokenStatus.notActive);
    await tokenRepository.deleteTokens();
  }

  Future _refreshToken({CustomErrorHandler? errorHandler}) async {
    _refreshCompleter = Completer();
    _stopRefreshTimer();
    _changeStatus(TokenStatus.refreshing);
    try {
      final refreshTokenIfo = await tokenRepository.getRefreshToken();
      if (_isRefreshTokenValid(refreshTokenIfo)) {
        await _exchangeTokens(refreshTokenIfo?.token ?? "");
      } else {
        throw EmptyTokenDataException();
      }
      final accessToken = tokenRepository.getAccessToken();
      if (accessToken != null) {
        _createRefreshTimer(accessToken);
        _changeStatus(TokenStatus.active);
      } else {
        throw AccessTokenDataException();
      }
    } catch (e, trace) {
      if (e is Exception) {
        await _processRefreshError(e, trace, errorHandler: errorHandler);
      } else {
        await _processRefreshError(const UnknownException(), trace, errorHandler: errorHandler);
      }
    } finally {
      _refreshCompleter?.complete();
    }
  }

  Future _forceSetToken(TokenPairInfo tokenPairInfo) async {
    if (_lastStatus == TokenStatus.refreshing) {
      await _refreshCompleter?.future;
    }
    _stopRefreshTimer();
    _changeStatus(TokenStatus.refreshing);
    await tokenRepository.saveTokens(tokenPairInfo);
    final accessToken = tokenRepository.getAccessToken();
    if (accessToken != null) {
      _createRefreshTimer(accessToken);
      _changeStatus(TokenStatus.active);
    } else {
      throw AccessTokenDataException();
    }
  }

  bool _isRefreshTokenValid(RefreshTokenInfo? token) {
    if (token == null) return false;
    final differenceInSeconds = token.expiredInDate.difference(DateTime.now()).inSeconds;
    if (differenceInSeconds < _threshold) {
      return false;
    } else {
      return true;
    }
  }

  Future<void> _processRefreshError(
    Exception exception,
    StackTrace trace, {
    CustomErrorHandler? errorHandler,
  }) async {
    if(errorHandler != null){
      errorHandler(exception);
    } else {
      jwtErrorHandler.onError(exception, trace);
    }
    _changeStatus(TokenStatus.error);
  }

  Future<void> _exchangeTokens(String refreshToken) async {
    final generatedResult = await refreshTokensUseCase.refreshTokens(refreshToken: refreshToken);
    await tokenRepository.saveTokens(generatedResult);
  }

  void _changeStatus(TokenStatus status) {
    _lastStatus = status;
    _controller.add(status);
  }

  void _stopRefreshTimer() {
    _timer?.cancel();
  }

  void _createRefreshTimer(AccessTokenInfo info) {
    final ttl = info.expiredInSeconds - _threshold;
    _timer = Timer(Duration(seconds: ttl), () {
      _changeStatus(TokenStatus.expired);
    });
  }
}
