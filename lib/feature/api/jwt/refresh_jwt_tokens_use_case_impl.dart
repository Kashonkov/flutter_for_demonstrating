import 'package:api/jwt/domain/entity/access_token_info.dart';
import 'package:api/jwt/domain/entity/refresh_token_info.dart';
import 'package:api/jwt/domain/entity/token_pair_info.dart';
import 'package:api/jwt/domain/use_case/refresh_jwt_tokens_use_case.dart';
import 'package:auth/domain/repository/auth_repository.dart';

final class RefreshJwtTokensUseCaseImpl implements RefreshJwtTokensUseCase, RefreshTokenHandlerRegistrar {
  RefreshTokenHandler? _handler;

  @override
  Future<TokenPairInfo> refreshTokens({required String refreshToken}) {
    final interactor = _handler;
    if (interactor != null) {
      return interactor.refresh(refreshToken: refreshToken);
    } else {
      throw Exception('Interactor not registered');
    }
  }

  @override
  registerHandler(RefreshTokenHandler interactor) {
    _handler = interactor;
  }
}

abstract interface class RefreshTokenHandlerRegistrar {
  registerHandler(RefreshTokenHandler interactor);
}

abstract interface class RefreshTokenHandler {
  Future<TokenPairInfo> refresh({required String refreshToken});
}

class RefreshTokenHandlerImpl implements RefreshTokenHandler {
  final AuthRepository _repository;

  RefreshTokenHandlerImpl(this._repository);

  @override
  Future<TokenPairInfo> refresh({required String refreshToken}) async {
    final authInfo = await _repository.refresh(refreshToken: refreshToken);
    return TokenPairInfo(
      accessToken: AccessTokenInfo(token: authInfo.token, expiredInSeconds: authInfo.expiresIn),
      refreshToken: RefreshTokenInfo(
        token: authInfo.refreshToken,
        expiredInDate: DateTime.now().add(Duration(days: 28)),
      ),
    );
  }
}
