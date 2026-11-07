import 'package:auto_route/auto_route.dart';
import 'package:domain_core/domain/entity/incident_item_entity.dart';
import 'package:shipment/navigation/shipment_router.gr.dart';

abstract interface class ShipmentNavigator {
  void navigateToDetails(String shipmentId);

  void navigateToMap();

  void navigateToIncident(IncidentEntity incident);
}

abstract base class ShipmentExternalNavigator {
  void navigateToIncident(IncidentEntity incident);
}

final class ShipmentNavigatorImpl implements ShipmentNavigator {
  final StackRouter router;
  final ShipmentExternalNavigator externalNavigator;

  ShipmentNavigatorImpl(this.router, this.externalNavigator);

  @override
  void navigateToDetails(String shipmentId) {
    router.push(ShipmentDetailsRoute(id: shipmentId));
  }

  @override
  void navigateToMap() {
    router.push(ShipmentsMapRoute());
  }

  @override
  void navigateToIncident(IncidentEntity incident) {
    externalNavigator.navigateToIncident(incident);
  }
}
