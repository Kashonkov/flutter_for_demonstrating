import 'dart:async';

import 'package:api/api_client/api_client_type.dart';
import 'package:common/di/di.dart';
import 'package:get_it/get_it.dart';
import 'package:shipment/data/api/shipment_api.dart';
import 'package:shipment/data/data_source/shipment_local_data_source.dart';
import 'package:shipment/data/data_source/shipment_remote_data_source.dart';
import 'package:shipment/data/model/converter/route_point_converter.dart';
import 'package:shipment/data/repository/shipment_repository_impl.dart';
import 'package:shipment/domain/repository/shipment_repository.dart';
import 'package:shipment/domain/use_case/apply_shipment_filter_use_case.dart';
import 'package:shipment/domain/use_case/complete_shipment_use_case.dart';
import 'package:shipment/domain/use_case/get_a%D1%81tive_shipments_use_case.dart';
import 'package:shipment/domain/use_case/get_filter_shipment_stream_use_case.dart';
import 'package:shipment/domain/use_case/get_initial_shipments_use_case.dart';
import 'package:shipment/domain/use_case/get_shipment_route_use_case.dart';
import 'package:shipment/domain/use_case/get_shipment_use_case.dart';
import 'package:shipment/domain/use_case/get_shipments_use_case.dart';
import 'package:shipment/presentation/shipment_bus/shipment_bus.dart';

final class ShipmentDiModule extends BaseDIModule {
  @override
  void updateInjections(GetIt instance) {
    //Region api
    instance.registerFactory<ShipmentApi>(
      () => ShipmentApi(instance.get(instanceName: ApiClientType.base.name)),
    );
    // region Datasources
    instance.registerFactory<ShipmentRemoteDataSource>(
      () => ShipmentRemoteDataSourceImpl(getIt(), RoutePointConverterImpl()),
    );
    instance.registerLazySingleton<ShipmentLocalDataSource>(() => _DisposableLocalDataSource());

    // region Repositories
    instance.registerFactory<ShipmentRepository>(() => ShipmentRepositoryImpl(getIt(), getIt()));

    // region Usecases
    instance.registerFactory(() => GetInitialShipmentsUseCase(getIt()));
    instance.registerFactory(() => GetShipmentsUseCase(getIt()));
    instance.registerFactory(() => GetShipmentUseCase(getIt()));
    instance.registerFactory(() => GetActiveShipmentsUseCase(getIt()));
    instance.registerFactory(() => GetFilterShipmentStreamUseCase(getIt()));
    instance.registerFactory(() => ApplyShipmentFilterUseCase(getIt()));
    instance.registerFactory(() => GetShipmentRouteUseCase(getIt()));
    instance.registerFactory(() => CompleteShipmentUseCase(getIt()));
    //region navigation

    instance.registerLazySingleton<ShipmentBusController>(() => _DisposableShipmentsBus());
  }
}

final class _DisposableLocalDataSource extends ShipmentLocalDataSourceImpl implements Disposable {
  @override
  FutureOr<dynamic> onDispose() => super.dispose();
}

final class _DisposableShipmentsBus extends ShipmentBus implements Disposable {
  @override
  FutureOr<dynamic> onDispose() => super.dispose();

}