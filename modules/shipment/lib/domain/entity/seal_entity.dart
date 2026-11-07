import 'package:shipment/domain/entity/connection_status.dart';
import 'package:domain_core/domain/entity/seal_status.dart';

final class SealEntity {
  final String id;
  final String shipmentId;
  final String number;
  final String type;
  final String color;
  final ConnectionStatus lteStatus;
  final ConnectionStatus gpsStatus;
  final DateTime? lteUpdatedAt;
  final DateTime? gpsUpdatedAt;
  final SealStatus status;

  final DateTime createdAt;
  final DateTime updatedAt;

  SealEntity({
    required this.id,
    required this.shipmentId,
    required this.number,
    required this.type,
    required this.color,
    required this.lteStatus,
    required this.gpsStatus,
    this.lteUpdatedAt,
    this.gpsUpdatedAt,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });
}
