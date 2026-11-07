import 'package:shipment/domain/entity/connection_status.dart';
import 'package:shipment/domain/entity/delivery_status.dart';

final class ShipmentItemModel {
  final String id;
  final String title;
  final ConnectionStatus? gpsStatus;
  final ConnectionStatus connectionStatus;
  final String positionTime;
  final String positionTitle;
  final DeliveryStatus deliveryStatus;
  final bool hasIncidents;

  ShipmentItemModel({
    required this.id,
    required this.title,
    required this.gpsStatus,
    required this.connectionStatus,
    required this.positionTime,
    required this.positionTitle,
    required this.deliveryStatus,
    required this.hasIncidents,
  });
}
