import 'package:api/api_client/api_client.dart';
import 'package:api/api_client/api_client_type.dart';
import 'package:api/api_client/auth_client.dart';
import 'package:api/api_client/base_client.dart';
import 'package:api/api_client/net_factory.dart';
import 'package:api/config/api_config.dart';
import 'package:api/exception/auth_exception_handler.dart';
import 'package:api/jwt/domain/use_case/force_refresh_jwt_tokens_use_case.dart';
import 'package:api/jwt/domain/use_case/get_access_token_use_case.dart';
import 'package:api/jwt/domain/use_case/get_token_status_stream_use_case.dart';

/// Factory for creating ApiClient
/// Responsible for providing a client based on the passed type [ApiClientType]
abstract class ApiClientFactory {
  ApiClient createClient(ApiClientType type);
}

class ApiClientFactoryImpl implements ApiClientFactory {
  final ApiConfig apiConfig;
  final NetFactory netFactory;
  final ForceRefreshJwtTokensUseCase forceRefreshJwtTokensUseCase;
  final GetTokenStatusStreamUseCase getTokenStatusStreamUseCase;
  final GetAccessTokenUseCase getAccessTokenUseCase;

  ApiClientFactoryImpl({
    required this.netFactory,
    required this.apiConfig,
    required this.forceRefreshJwtTokensUseCase,
    required this.getTokenStatusStreamUseCase,
    required this.getAccessTokenUseCase,
  });

  @override
  ApiClient createClient(ApiClientType type) {
    switch (type) {
      case ApiClientType.auth:
        return _createAuthClient();
      case ApiClientType.base:
        return _createBaseClient();
    }
  }

  ApiClient _createBaseClient() {
    final client = BaseClient.instance(
      netFactory: netFactory,
      urlConfig: apiConfig.baseConfig,
      forceRefreshJwtTokensUseCase: forceRefreshJwtTokensUseCase,
      getTokenStatusStreamUseCase: getTokenStatusStreamUseCase,
      getAccessTokenUseCase: getAccessTokenUseCase,
      generalTrustedFingerprints: apiConfig.trustedCertFingerprints,
    );
    return client;
  }

  ApiClient _createAuthClient() {
    final client = AuthClient.instance(
      netFactory: netFactory,
      urlConfig: apiConfig.baseConfig,
      generalTrustedFingerprints: apiConfig.trustedCertFingerprints,
    );
    return client;
  }
}
