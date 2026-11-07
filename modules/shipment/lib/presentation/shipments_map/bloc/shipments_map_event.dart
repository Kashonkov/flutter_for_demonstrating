import 'package:shipment/domain/entity/shipment_filter_entity.dart';
import 'package:shipment/presentation/shipment_filter_bottom_sheet/model/shipment_filter.dart';

sealed class ShipmentsMapEvent {}

final class OnInitEvent extends ShipmentsMapEvent {}

final class OnShipmentSelectEvent extends ShipmentsMapEvent {
  final String? id;

  OnShipmentSelectEvent({required this.id});
}

final class OnShipmentTapEvent extends ShipmentsMapEvent {
  final String id;

  OnShipmentTapEvent({required this.id});
}

final class OnQueryChangeEvent extends ShipmentsMapEvent {
  final String query;

  OnQueryChangeEvent(this.query);
}

final class OnFiltersTapEvent extends ShipmentsMapEvent {}

final class OnFilterSelectedEvent extends ShipmentsMapEvent {
  final ShipmentBottomFilters filter;

  OnFilterSelectedEvent(this.filter);
}

final class OnShipmentFilterReceivedEvent extends ShipmentsMapEvent {
  final ShipmentFilterEntity? filter;

  OnShipmentFilterReceivedEvent(this.filter);
}

final class OnShipmentUpdateEvent extends ShipmentsMapEvent {
  final String id;

  OnShipmentUpdateEvent(this.id);
}