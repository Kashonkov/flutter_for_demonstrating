import 'package:domain_core/data/model/position_dto.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:shipment/data/model/converter/connection_status_converter.dart';
import 'package:shipment/data/model/converter/delivery_status_converter.dart';
import 'package:shipment/data/model/seals_statuses_dto.dart';
import 'package:shipment/domain/entity/connection_status.dart';
import 'package:shipment/domain/entity/delivery_status.dart';
import 'package:shipment/domain/entity/shipment_item_entity.dart';

part 'shipment_item_dto.g.dart';

@JsonSerializable(createToJson: false)
class ShipmentItemDto {
  final String id;
  final String reference;
  final String? container;
  @DeliveryStatusConverter()
  final DeliveryStatus deliveryStatus;

  final PositionDto? origin;
  final PositionDto? destination;
  final PositionDto currentPosition;

  final String? distance;
  final String? timeTotal;
  final String? timeIdle;
  final String? timeInMotion;
  final String? avgSpeed;
  final String? maxSpeed;
  final int incidentsCount;
  final SealsStatusesDto sealsStatuses;

  @ConnectionStatusConverter()
  final ConnectionStatus? lteStatus;
  @ConnectionStatusConverter()
  final ConnectionStatus? gpsStatus;

  final DateTime? lteUpdatedAt;
  final DateTime? gpsUpdatedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  ShipmentItemDto({
    required this.id,
    required this.reference,
    required this.container,
    required this.deliveryStatus,
    required this.origin,
    required this.destination,
    required this.currentPosition,
    this.distance,
    this.timeTotal,
    this.timeIdle,
    this.timeInMotion,
    this.avgSpeed,
    this.maxSpeed,
    required this.incidentsCount,
    required this.sealsStatuses,
    this.lteStatus,
    this.gpsStatus,
    this.lteUpdatedAt,
    this.gpsUpdatedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ShipmentItemDto.fromJson(Map<String, dynamic> json) => _$ShipmentItemDtoFromJson(json);

  ShipmentItemEntity toItemEntity() => ShipmentItemEntity(
    id: id,
    title: reference,
    gpsStatus: gpsStatus ?? ConnectionStatus.undefined,
    connectionStatus: lteStatus ?? ConnectionStatus.undefined,
    position: currentPosition.toEntity(),
    deliveryStatus: deliveryStatus,
    incidentCount: incidentsCount
  );
}
