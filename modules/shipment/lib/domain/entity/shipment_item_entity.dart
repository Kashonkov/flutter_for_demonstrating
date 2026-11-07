import 'package:domain_core/domain/entity/position_entity.dart';
import 'package:shipment/domain/entity/connection_status.dart';
import 'package:shipment/domain/entity/delivery_status.dart';

final class ShipmentItemEntity {
  final String id;
  final String title;
  final ConnectionStatus gpsStatus;
  final ConnectionStatus connectionStatus;
  final PositionEntity position;
  final DeliveryStatus deliveryStatus;
  final int incidentCount;

  ShipmentItemEntity({
    required this.id,
    required this.title,
    required this.gpsStatus,
    required this.connectionStatus,
    required this.position,
    required this.deliveryStatus,
    required this.incidentCount,
  });
}
