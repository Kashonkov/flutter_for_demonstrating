import 'package:domain_core/domain/entity/incident_item_entity.dart';
import 'package:incident/navigation/incident_router.gr.dart';
import 'package:lxe_app/router/app_router.dart';
import 'package:shipment/navigation/shipment_navigator.dart';

final class ShipmentExternalNavigatorImpl extends ShipmentExternalNavigator {
  final AppRouter router;

  ShipmentExternalNavigatorImpl(this.router);

  @override
  void navigateToIncident(IncidentEntity incident) {
    router.navigate(IncidentDetailsRoute(incident: incident));
  }
}
