import 'package:auto_route/auto_route.dart';
import 'package:domain_core/domain/entity/incident_item_entity.dart';
import 'package:incident/navigation/incident_external_navigator.dart';
import 'package:incident/navigation/incident_router.gr.dart';

abstract interface class IncidentNavigator {
  void navigateToDetails(IncidentEntity incident);

  void navigateToShipment(String shipmentId);

  void navigateToMap();
}

final class IncidentNavigatorImpl implements IncidentNavigator {
  final StackRouter router;
  final IncidentExternalNavigator externalNavigator;

  IncidentNavigatorImpl(this.router, this.externalNavigator);

  @override
  void navigateToDetails(IncidentEntity incident) {
    router.push(IncidentDetailsRoute(incident: incident));
  }

  @override
  void navigateToShipment(String shipmentId) {
    externalNavigator.navigateToShipment(shipmentId);
  }

  @override
  void navigateToMap() {
    router.push(IncidentsMapRoute());
  }
}
