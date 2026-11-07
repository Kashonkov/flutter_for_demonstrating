import 'package:api/api_client/api_client_type.dart';
import 'package:auth/data/api/auth_api.dart';
import 'package:auth/data/data_source/auth_remote_data_source.dart';
import 'package:auth/data/repository/auth_repository_impl.dart';
import 'package:auth/domain/repository/auth_repository.dart';
import 'package:auth/domain/use_case/login_use_case.dart';
import 'package:auth/navigation/auth_navigator.dart';
import 'package:common/di/di.dart';
import 'package:get_it/get_it.dart';

final class AuthDiModule extends BaseDIModule {
  @override
  void updateInjections(GetIt instance) {
    //Region api
    instance.registerFactory<AuthApi>(() => AuthApi(instance.get(instanceName: ApiClientType.auth.name)));
    //Region datasources
    instance.registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(getIt()),
    );
    //Region repository
    instance.registerFactory<AuthRepository>(() => AuthRepositoryImpl(getIt()));

    //Region usecases
    instance.registerFactory<LoginUseCase>(() => LoginUseCase(getIt(), getIt()));

    // Region navigation
    instance.registerFactory<AuthNavigator>(() => AuthNavigatorImpl(getIt()));
  }
}
