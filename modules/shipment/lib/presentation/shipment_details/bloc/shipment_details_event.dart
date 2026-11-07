import 'package:domain_core/domain/entity/incident_item_entity.dart';
import 'package:shipment/domain/entity/shipment_status.dart';

sealed class ShipmentDetailsEvent {}

final class OnInitialEvent extends ShipmentDetailsEvent {}

final class OnTimeProgressChangeEvent extends ShipmentDetailsEvent {
  final double value;

  OnTimeProgressChangeEvent({required this.value});
}

final class OnCompleteTapEvent extends ShipmentDetailsEvent {
  final String? address;
  final String? comment;
  final ShipmentStatus status;

  OnCompleteTapEvent({this.address, required this.status, this.comment});
}

final class OnOpenIncidentTapEvent extends ShipmentDetailsEvent {
  final IncidentEntity incident;

  OnOpenIncidentTapEvent(this.incident);
}