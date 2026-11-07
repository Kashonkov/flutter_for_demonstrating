import 'package:api/api_client/api_client_type.dart';
import 'package:common/di/di.dart';
import 'package:get_it/get_it.dart';
import 'package:order/data/api/order_api.dart';
import 'package:order/data/data_source/order_remote_data_source.dart';
import 'package:order/data/repository/order_repository_impl.dart';
import 'package:order/domain/repository/order_repository.dart';
import 'package:order/domain/use_case/get_orders_use_case.dart';

final class OrderDiModule extends BaseDIModule {
  @override
  void updateInjections(GetIt instance) {
    //Region api
    instance.registerFactory<OrderApi>(() => OrderApi(instance.get(instanceName: ApiClientType.base.name)));

    // region Datasources
    instance.registerFactory<OrderRemoteDataSource>(() => OrderRemoteDataSourceImpl(getIt()));

    // region Repositories
    instance.registerFactory<OrderRepository>(() => OrderRepositoryImpl(getIt()));

    // region Usecases
    instance.registerFactory(() => GetOrdersUseCase(getIt()));

    //region navigation
  }
}
