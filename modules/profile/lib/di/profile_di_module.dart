import 'package:api/api_client/api_client_type.dart';
import 'package:common/di/di.dart';
import 'package:get_it/get_it.dart';
import 'package:profile/data/api/profile_api.dart';
import 'package:profile/data/data_source/platform_data_source.dart';
import 'package:profile/data/data_source/profile_local_data_source.dart';
import 'package:profile/data/data_source/profile_remote_data_source.dart';
import 'package:profile/data/repository/profile_repository_impl.dart';
import 'package:profile/domain/repository/profile_repository.dart';
import 'package:profile/domain/use_case/get_app_version_use_case.dart';
import 'package:profile/domain/use_case/get_avatar_use_case.dart';
import 'package:profile/domain/use_case/get_profile_stream_use_case.dart';
import 'package:profile/domain/use_case/get_profile_use_case.dart';
import 'package:profile/domain/use_case/logout_use_case.dart';
import 'package:profile/domain/use_case/update_profile_use_case.dart';
import 'package:profile/navigation/profile_navigator.dart';

final class ProfileDiModule extends BaseDIModule {
  @override
  void updateInjections(GetIt instance) {
    //Region api
    instance.registerFactory<ProfileApi>(
      () => ProfileApi(instance.get(instanceName: ApiClientType.base.name)),
    );

    // region Datasources
    instance.registerFactory<ProfileRemoteDataSource>(() => ProfileRemoteDataSourceImpl(getIt()));
    instance.registerLazySingleton<ProfileLocalDataSource>(() => ProfileLocalDataSourceImpl());
    instance.registerLazySingleton<PlatformDataSource>(() => PlatformDataSourceImpl());

    // region Repositories
    instance.registerFactory<ProfileRepository>(
      () => ProfileRepositoryImpl(getIt(), getIt(), getIt()),
    );

    // region Usecases
    instance.registerFactory(() => GetAppVersionUseCase(getIt()));
    instance.registerFactory(() => GetProfileStreamUseCase(getIt()));
    instance.registerFactory(() => GetProfileUseCase(getIt()));
    instance.registerFactory(() => LogoutUseCase(getIt(), getIt()));
    instance.registerFactory(() => UpdateProfileUseCase(getIt()));
    instance.registerFactory(() => GetAvatarUseCase(getIt()));

    //region navigation
    instance.registerFactory<ProfileNavigator>(() => ProfileNavigatorImpl(getIt()));
  }
}
