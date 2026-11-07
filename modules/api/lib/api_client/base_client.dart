import 'package:api/api_client/api_client.dart';
import 'package:api/api_client/net_factory.dart';
import 'package:api/config/api_config.dart';
import 'package:api/interceptors/auth_token_interceptor.dart';
import 'package:api/interceptors/refresh_token_interceptor.dart';
import 'package:api/jwt/domain/use_case/force_refresh_jwt_tokens_use_case.dart';
import 'package:api/jwt/domain/use_case/get_access_token_use_case.dart';
import 'package:api/jwt/domain/use_case/get_token_status_stream_use_case.dart';
import 'package:dio/dio.dart';

/// Basic client for accessing platform methods
class BaseClient extends ApiClient {
  BaseClient._(super.dio);

  factory BaseClient.instance({
    required NetFactory netFactory,
    required UrlConfig urlConfig,
    required ForceRefreshJwtTokensUseCase forceRefreshJwtTokensUseCase,
    required GetTokenStatusStreamUseCase getTokenStatusStreamUseCase,
    required GetAccessTokenUseCase getAccessTokenUseCase,
    List<String>? generalTrustedFingerprints,
  }) {
    final client = netFactory.createClient(
      urlConfig: urlConfig,
      generalTrustedFingerprints: generalTrustedFingerprints,
      onClientPrepared: (client) => _registerInterceptors(
        client: client,
        urlConfig: urlConfig,
        forceRefreshJwtTokensUseCase: forceRefreshJwtTokensUseCase,
        getTokenStatusStreamUseCase: getTokenStatusStreamUseCase,
        getAccessTokenUseCase: getAccessTokenUseCase,
      ),
    );

    return BaseClient._(client);
  }

  static void _registerInterceptors({
    required Dio client,
    required UrlConfig urlConfig,
    required ForceRefreshJwtTokensUseCase forceRefreshJwtTokensUseCase,
    required GetTokenStatusStreamUseCase getTokenStatusStreamUseCase,
    required GetAccessTokenUseCase getAccessTokenUseCase,
  }) {
    client.interceptors.addAll([
      RefreshTokenInterceptor(
        dio: client,
        forceRefreshTokenUseCase: forceRefreshJwtTokensUseCase,
        getTokenStatusStreamUseCase: getTokenStatusStreamUseCase,
      ),
      AuthTokenInterceptor(getAccessTokenUseCase: getAccessTokenUseCase),
    ]);
  }
}
