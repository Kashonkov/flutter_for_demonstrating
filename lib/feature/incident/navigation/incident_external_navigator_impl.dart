import 'package:auto_route/auto_route.dart';
import 'package:incident/navigation/incident_external_navigator.dart';
import 'package:shipment/navigation/shipment_router.gr.dart';

final class IncidentExternalNavigatorImpl extends IncidentExternalNavigator {
  final StackRouter router;

  IncidentExternalNavigatorImpl(this.router);

  @override
  void navigateToShipment(String shipmentId) {
    router.push(ShipmentDetailsRoute(id: shipmentId));
  }
}
