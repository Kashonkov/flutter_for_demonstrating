import 'package:common/di/di.dart';
import 'package:get_it/get_it.dart';
import 'package:incident/di/incident_di_module.dart';
import 'package:incident/navigation/incident_external_navigator.dart';
import 'package:lxe_app/feature/incident/navigation/incident_external_navigator_impl.dart';

final class IncidentExternalDiModule extends BaseDIModule {
  @override
  void updateInjections(GetIt instance) {
   instance.registerFactory<IncidentExternalNavigator>(() => IncidentExternalNavigatorImpl(getIt()));
   instance.installModule(IncidentDiModule());
  }
}
