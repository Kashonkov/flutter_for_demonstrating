import 'package:common/di/di.dart';
import 'package:get_it/get_it.dart';
import 'package:lxe_app/feature/shipment/navigation/shipment_external_navigator.dart';
import 'package:shipment/di/shipment_di_module.dart';
import 'package:shipment/navigation/shipment_navigator.dart';

final class ShipmentExternalDiModule extends BaseDIModule{
  @override
  void updateInjections(GetIt instance) {
    instance.registerFactory<ShipmentExternalNavigator>(() => ShipmentExternalNavigatorImpl(getIt()));
    instance.installModule(ShipmentDiModule());
  }
}