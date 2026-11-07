import 'package:api/api_client/api_client.dart';
import 'package:api/api_client/api_client_factory.dart';
import 'package:api/api_client/api_client_type.dart';
import 'package:api/api_client/net_factory.dart';
import 'package:api/config/api_config.dart';
import 'package:api/jwt/data/data_source/jwt_local_data_source.dart';
import 'package:api/jwt/data/repository/jwt_token_repository_impl.dart';
import 'package:api/jwt/domain/repository/jwt_token_repository.dart';
import 'package:api/jwt/domain/use_case/force_refresh_jwt_tokens_use_case.dart';
import 'package:api/jwt/domain/use_case/force_set_jwt_tokens_use_case.dart';
import 'package:api/jwt/domain/use_case/get_access_token_use_case.dart';
import 'package:api/jwt/domain/use_case/get_refresh_token_use_case.dart';
import 'package:api/jwt/domain/use_case/get_token_status_stream_use_case.dart';
import 'package:api/jwt/domain/use_case/init_jwt_token_authorization_use_case.dart';
import 'package:api/jwt/domain/use_case/invalidate_jwt_tokens_use_case.dart';
import 'package:api/jwt/domain/use_case/jwt_error_handler.dart';
import 'package:api/jwt/domain/use_case/refresh_jwt_tokens_use_case.dart';
import 'package:api/jwt/domain/use_case/token_interactor.dart';
import 'package:common/di/di.dart';
import 'package:get_it/get_it.dart';
import 'package:lxe_app/feature/api/jwt/jwt_error_handler_impl.dart';
import 'package:lxe_app/feature/api/jwt/refresh_jwt_tokens_use_case_impl.dart';

class NetDIModule extends AsyncDIModule {
  final ApiConfig config;

  NetDIModule(this.config);

  @override
  Future updateInjections(GetIt instance) async {
    //jwt
    instance.registerLazySingleton<JwtLocalDataSource>(() => JwtLocalDataSourceImpl());
    instance.registerFactory<JwtTokenRepository>(() => JwtTokenRepositoryImpl(getIt()));
    instance.registerLazySingleton<TokenInteractor>(
      () => TokenInteractorImpl(
        tokenRepository: getIt(),
        refreshTokensUseCase: getIt(),
        jwtErrorHandler: getIt(),
      ),
    );
    instance.registerFactory<ForceSetJwtTokensUseCase>(() => ForceSetJwtTokensUseCase(getIt()));
    instance.registerFactory<GetAccessTokenUseCase>(() => GetAccessTokenUseCase(getIt()));
    instance.registerFactory<GetRefreshTokenUseCase>(() => GetRefreshTokenUseCase(getIt()));
    instance.registerFactory<GetTokenStatusStreamUseCase>(
      () => GetTokenStatusStreamUseCase(getIt()),
    );
    instance.registerFactory<InitJwtTokenAuthorizationUseCase>(
      () => InitJwtTokenAuthorizationUseCase(getIt()),
    );
    instance.registerFactory<InvalidateJwtTokenUseCase>(() => InvalidateJwtTokenUseCase(getIt()));
    instance.registerFactory<JwtErrorHandler>(() => JwtErrorHandlerImpl(getIt()));
    final refreshTokenUseCase = RefreshJwtTokensUseCaseImpl();
    instance.registerSingleton<RefreshJwtTokensUseCase>(refreshTokenUseCase);
    instance.registerSingleton<RefreshTokenHandlerRegistrar>(refreshTokenUseCase);
    instance.registerFactory<ForceRefreshJwtTokensUseCase>(
      () => ForceRefreshJwtTokensUseCase(getIt()),
    );

    instance.registerLazySingleton<ApiClientFactory>(
      () => ApiClientFactoryImpl(
        apiConfig: config,
        netFactory: BaseNetFactory(),
        forceRefreshJwtTokensUseCase: getIt(),
        getTokenStatusStreamUseCase: getIt(),
        getAccessTokenUseCase: getIt(),
      ),
    );

    // clients
    final clients = await _createClients();
    clients.forEach((type, client) {
      instance.registerSingleton<ApiClient>(client, instanceName: type.name);
    });
  }

  Future<Map<ApiClientType, ApiClient>> _createClients() async {
    final factory = getIt<ApiClientFactory>();
    final clientMap = <ApiClientType, ApiClient>{};

    final authClient = factory.createClient(ApiClientType.auth);
    final baseClient = factory.createClient(ApiClientType.base);

    clientMap.putIfAbsent(ApiClientType.auth, () => authClient);
    clientMap.putIfAbsent(ApiClientType.base, () => baseClient);

    return clientMap;
  }
}
