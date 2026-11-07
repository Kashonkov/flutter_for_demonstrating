import 'package:domain_core/data/model/incident_dto.dart';
import 'package:domain_core/data/model/position_dto.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:shipment/data/model/converter/connection_status_converter.dart';
import 'package:shipment/data/model/converter/delivery_status_converter.dart';
import 'package:shipment/data/model/seal_dto.dart';
import 'package:shipment/domain/entity/connection_status.dart';
import 'package:shipment/domain/entity/delivery_status.dart';
import 'package:shipment/domain/entity/shipment_entity.dart';

part 'shipment_dto.g.dart';

@JsonSerializable(createToJson: false)
class ShipmentDto {
  final String id;
  final String reference;
  final String? container;

  @DeliveryStatusConverter()
  final DeliveryStatus deliveryStatus;

  final PositionDto origin;
  final PositionDto? destination;
  final PositionDto currentPosition;

  /// Optional metrics (schema says string)
  final String? distance;
  final String? timeTotal;
  final String? timeIdle;
  final String? timeInMotion;
  final String? avgSpeed;
  final String? maxSpeed;

  @ConnectionStatusConverter()
  final ConnectionStatus? lteStatus;
  @ConnectionStatusConverter()
  final ConnectionStatus? gpsStatus;
  final DateTime? lteUpdatedAt;
  final DateTime? gpsUpdatedAt;

  final List<SealDto> seals;
  final List<IncidentDto> incidents;

  final DateTime createdAt;
  final DateTime updatedAt;

  const ShipmentDto({
    required this.id,
    required this.reference,
    required this.container,
    required this.deliveryStatus,
    required this.origin,
    this.destination,
    required this.currentPosition,
    this.distance,
    this.timeTotal,
    this.timeIdle,
    this.timeInMotion,
    this.avgSpeed,
    this.maxSpeed,
    this.lteStatus,
    this.gpsStatus,
    this.lteUpdatedAt,
    this.gpsUpdatedAt,
    required this.seals,
    required this.incidents,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ShipmentDto.fromJson(Map<String, dynamic> json) => _$ShipmentDtoFromJson(json);

  ShipmentEntity toEntity() => ShipmentEntity(
    id: id,
    reference: reference,
    container: container,
    deliveryStatus: deliveryStatus,
    origin: origin.toEntity(),
    destination: destination?.toEntity(),
    currentPosition: currentPosition.toEntity(),
    distance: distance,
    timeTotal: timeTotal,
    timeIdle: timeIdle,
    timeInMotion: timeInMotion,
    avgSpeed: avgSpeed,
    maxSpeed: maxSpeed,
    lteStatus: lteStatus,
    gpsStatus: gpsStatus,
    lteUpdatedAt: lteUpdatedAt,
    gpsUpdatedAt: gpsUpdatedAt,
    seals: seals.map((seal) => seal.toEntity()).toList(),
    incidents: incidents.map((incident) => incident.toEntity()).toList(),
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}
