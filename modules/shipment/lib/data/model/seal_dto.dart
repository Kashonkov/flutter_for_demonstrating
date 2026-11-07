import 'package:json_annotation/json_annotation.dart';
import 'package:shipment/data/model/converter/connection_status_converter.dart';
import 'package:domain_core/data/model/converter/seal_status_converter.dart';
import 'package:shipment/domain/entity/connection_status.dart';
import 'package:shipment/domain/entity/seal_entity.dart';
import 'package:domain_core/domain/entity/seal_status.dart';

part 'seal_dto.g.dart';

@JsonSerializable(createToJson: false)
class SealDto {
  final String id;
  final String shipmentId;
  final String number;
  final String type;
  final String color;
  @ConnectionStatusConverter()
  final ConnectionStatus lteStatus;
  @ConnectionStatusConverter()
  final ConnectionStatus gpsStatus;

  final DateTime? lteUpdatedAt;
  final DateTime? gpsUpdatedAt;
  @SealStatusConverter()
  final SealStatus status;

  final DateTime createdAt;
  final DateTime updatedAt;

  const SealDto({
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

  factory SealDto.fromJson(Map<String, dynamic> json) => _$SealDtoFromJson(json);

  SealEntity toEntity() => SealEntity(
    id: id,
    shipmentId: shipmentId,
    number: number,
    type: type,
    color: color,
    lteStatus: lteStatus,
    lteUpdatedAt: lteUpdatedAt,
    gpsStatus: gpsStatus,
    gpsUpdatedAt: gpsUpdatedAt,
    status: status,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}
