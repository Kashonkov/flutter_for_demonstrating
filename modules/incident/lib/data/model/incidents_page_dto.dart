import 'package:domain_core/data/model/incident_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'incidents_page_dto.g.dart';

@JsonSerializable(createToJson: false)
final class IncidentsPageDto {
  final List<IncidentDto> items;

  IncidentsPageDto(this.items);

  factory IncidentsPageDto.fromJson(Map<String, dynamic> json) => _$IncidentsPageDtoFromJson(json);
}