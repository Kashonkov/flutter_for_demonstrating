import 'package:domain_core/data/model/converter/seal_status_converter.dart';
import 'package:domain_core/domain/entity/incident_seal_entity.dart';
import 'package:domain_core/domain/entity/seal_status.dart';
import 'package:json_annotation/json_annotation.dart';

part 'incident_seal_dto.g.dart';

@JsonSerializable(createToJson: false)
class IncidentSealDto {
  final String id;
  final String number;
  @SealStatusConverter()
  final SealStatus status;

  const IncidentSealDto({required this.id, required this.number, required this.status});

  factory IncidentSealDto.fromJson(Map<String, dynamic> json) => _$IncidentSealDtoFromJson(json);

  IncidentSealEntity toEntity() => IncidentSealEntity(id: id, number: number, status: status);
}
