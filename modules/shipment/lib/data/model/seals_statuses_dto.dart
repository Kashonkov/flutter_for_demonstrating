import 'package:json_annotation/json_annotation.dart';

part 'seals_statuses_dto.g.dart';

@JsonSerializable(createToJson: false)
class SealsStatusesDto {
  final int total;
  final int ok;
  final int cableCut;
  final int lowBattery;
  final int deactivated;

  SealsStatusesDto({
    required this.total,
    required this.ok,
    required this.cableCut,
    required this.lowBattery,
    required this.deactivated,
  });

  factory SealsStatusesDto.fromJson(Map<String, dynamic> json) =>
      _$SealsStatusesDtoFromJson(json);
}
