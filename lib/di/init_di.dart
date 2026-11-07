import 'package:api/config/api_config.dart';
import 'package:common/di/get_it_extensions.dart';
import 'package:get_it/get_it.dart';
import 'package:incident/di/incident_di_module.dart';
import 'package:lxe_app/di/core_di_module.dart';
import 'package:lxe_app/di/routing_di_module.dart';
import 'package:lxe_app/feature/auth/di/external_auth_di_module.dart';
import 'package:lxe_app/feature/incident/di/incident_external_di_module.dart';
import 'package:lxe_app/feature/profile/di/external_profile_di_module.dart';
import 'package:lxe_app/feature/shipment/di/shipment_external_di_module.dart';
import 'package:order/di/order_di_module.dart';
import 'package:shipment/di/shipment_di_module.dart';

import 'net_di_module.dart';

const applicationScope = "ApplicationScope";

Future<void> initDI(ApiConfig config) async {
  // final analyticsInteractor = getIt<AnalyticsInteractor>();

  try {
    final instance = GetIt.instance;
    instance.registerSingleton(config);
    instance.pushNewScope(scopeName: applicationScope);
    instance.installModule(RoutingDiModule());
    instance.installModule(CoreDiModule());
    await instance.installModuleAsync(NetDIModule(config));
    // Region Feature modules
    instance.installModule(ExternalAuthDiModule());
    instance.installModule(ExternalProfileDiModule());
    instance.installModule(IncidentExternalDiModule());
    instance.installModule(OrderDiModule());
    instance.installModule(ShipmentExternalDiModule());
    // End region
  } catch (exc, trace) {
    // analyticsInteractor.reportError(
    //   analyticsError: AnalyticsError(
    //     message: "Error while initializing di: $exc",
    //     type: exc.runtimeType.toString(),
    //     stackTrace: trace,
    //   ),
    // );
  }
}
