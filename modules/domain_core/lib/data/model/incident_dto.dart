import 'package:domain_core/data/model/incident_seal_dto.dart';
import 'package:domain_core/data/model/position_dto.dart';
import 'package:domain_core/domain/entity/incident_item_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'incident_dto.g.dart';

@JsonSerializable(createToJson: false)
final class IncidentDto {
  final String id;
  final String shipmentId;
  final String? shipmentReference;
  final String? shipmentContainer;
  final String description;
  final PositionDto position;
  final int? accuracyRangeInMeters;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<IncidentSealDto> seals;


  IncidentDto({
    required this.id,
    required this.shipmentId,
    required this.description,
    required this.position,
    required this.seals,
    this.accuracyRangeInMeters,
    required this.createdAt,
    required this.updatedAt,
    this.shipmentReference,
    this.shipmentContainer,
  });

  factory IncidentDto.fromJson(Map<String, dynamic> json) => _$IncidentDtoFromJson(json);

  IncidentEntity toEntity() =>
      IncidentEntity(
          id: id,
          shipmentId: shipmentId,
          createdDate: createdAt,
          updatedDate: updatedAt,
          description: description,
          position: position.toEntity(),
          shipmentReference: shipmentReference,
          shipmentContainer: shipmentContainer,
          accuracyInMeters: accuracyRangeInMeters,
          seals: seals.map((seal) => seal.toEntity()).toList(),
      );
}