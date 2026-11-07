import 'package:domain_core/data/model/incident_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'incident_details_dto.g.dart';

@JsonSerializable(createToJson: false)
class IncidentDetailsDto {
  final IncidentDto incident;

  const IncidentDetailsDto({required this.incident});

  factory IncidentDetailsDto.fromJson(Map<String, dynamic> json) =>
      _$IncidentDetailsDtoFromJson(json);
}