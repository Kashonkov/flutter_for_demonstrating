import 'package:domain_core/domain/entity/incident_item_entity.dart';
import 'package:domain_core/domain/entity/position_entity.dart';
import 'package:shipment/domain/entity/seal_entity.dart';
import 'package:shipment/domain/entity/connection_status.dart';
import 'package:shipment/domain/entity/delivery_status.dart';

class ShipmentEntity {
  final String id;
  final String reference;
  final String? container;

  final DeliveryStatus deliveryStatus;

  final PositionEntity origin;
  final PositionEntity? destination;
  final PositionEntity currentPosition;

  /// Optional metrics (schema says string)
  final String? distance;
  final String? timeTotal;
  final String? timeIdle;
  final String? timeInMotion;
  final String? avgSpeed;
  final String? maxSpeed;

  final ConnectionStatus? lteStatus;
  final ConnectionStatus? gpsStatus;
  final DateTime? lteUpdatedAt;
  final DateTime? gpsUpdatedAt;

  final List<SealEntity> seals;
  final List<IncidentEntity> incidents;

  final DateTime createdAt;
  final DateTime updatedAt;

  ShipmentEntity({
    required this.id,
    required this.reference,
    required this.container,
    required this.deliveryStatus,
    required this.origin,
    required this.destination,
    required this.currentPosition,
    required this.distance,
    required this.timeTotal,
    required this.timeIdle,
    required this.timeInMotion,
    required this.avgSpeed,
    required this.maxSpeed,
    required this.lteStatus,
    required this.gpsStatus,
    required this.lteUpdatedAt,
    required this.gpsUpdatedAt,
    required this.seals,
    required this.incidents,
    required this.createdAt,
    required this.updatedAt,
  });
}
