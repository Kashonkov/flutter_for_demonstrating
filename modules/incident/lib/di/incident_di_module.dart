import 'dart:async';

import 'package:api/api_client/api_client_type.dart';
import 'package:common/di/di.dart';
import 'package:get_it/get_it.dart';
import 'package:incident/data/api/incident_api.dart';
import 'package:incident/data/api/incident_file_api.dart';
import 'package:incident/data/data_source/incident_local_data_source.dart';
import 'package:incident/data/data_source/incident_remote_data_source.dart';
import 'package:incident/data/repository/incident_repository_impl.dart';
import 'package:incident/domain/repository/incident_repository.dart';
import 'package:incident/domain/use_case/apply_incident_filter_use_case.dart';
import 'package:incident/domain/use_case/download_incident_report_use_case.dart';
import 'package:incident/domain/use_case/download_share_report_incident_report_use_case.dart';
import 'package:incident/domain/use_case/get_filter_incident_stream_use_case.dart';
import 'package:incident/domain/use_case/get_incidents_use_case.dart';
import 'package:incident/domain/use_case/get_initial_incidents_use_case.dart';
import 'package:incident/navigation/incident_navigator.dart';

final class IncidentDiModule extends BaseDIModule {
  @override
  void updateInjections(GetIt instance) {
    //Region api
    instance.registerFactory<IncidentApi>(() => IncidentApi(instance.get(instanceName: ApiClientType.base.name)));
    instance.registerFactory<IncidentFileApi>(() => IncidentFileApiImpl(instance.get(instanceName: ApiClientType.base.name)));

    // region Datasources
    instance.registerFactory<IncidentRemoteDataSource>(() => IncidentRemoteDataSourceImpl(getIt(), getIt(),getIt(),getIt()));
    instance.registerLazySingleton<IncidentLocalDataSource>(() => _DisposableIncidentLocalDataSource());

    // region Repositories
    instance.registerFactory<IncidentRepository>(() => IncidentRepositoryImpl(getIt(), getIt()));

    // region Usecases
    instance.registerFactory(() => ApplyIncidentFilterUseCase(getIt()));
    instance.registerFactory(() => GetIncidentsUseCase(getIt()));
    instance.registerFactory(() => GetInitialIncidentsUseCase(getIt()));
    instance.registerFactory(() => GetFilterIncidentStreamUseCase(getIt()));
    instance.registerFactory(() => DownloadIncidentReportUseCase(getIt()));
    instance.registerFactory(() => DownloadShareReportIncidentReportUseCase(getIt()));

    //region navigation
    instance.registerFactory<IncidentNavigator>(() => IncidentNavigatorImpl(getIt(), getIt()));
  }
}

final class _DisposableIncidentLocalDataSource extends IncidentLocalDataSourceImpl implements Disposable{
  @override
  FutureOr<dynamic> onDispose() => super.dispose();

}
