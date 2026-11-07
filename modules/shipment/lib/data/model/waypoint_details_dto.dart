import 'package:json_annotation/json_annotation.dart';

part 'waypoint_details_dto.g.dart';

@JsonSerializable(createToJson: false)
class WaypointDetailsDto {
  final int count;
  final double rangeInMeters;
  final DateTime enteredAt;
  final DateTime leftAt;

  const WaypointDetailsDto({
    required this.count,
    required this.rangeInMeters,
    required this.enteredAt,
    required this.leftAt,
  });

  factory WaypointDetailsDto.fromJson(Map<String, dynamic> json) =>
      _$WaypointDetailsDtoFromJson(json);

}