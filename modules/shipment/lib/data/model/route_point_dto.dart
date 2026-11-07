import 'package:domain_core/data/model/position_dto.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:shipment/data/model/converter/route_point_type_converter.dart';
import 'package:shipment/data/model/incident_details_dto.dart';
import 'package:shipment/data/model/waypoint_details_dto.dart';
import 'package:shipment/data/model/route_point_type.dart';

part 'route_point_dto.g.dart';

@JsonSerializable(createToJson: false)
class RoutePointDto {
  final PositionDto position;
  @RoutePointTypeConverter()
  final RoutePointType type;
  final double? speed;
  final WaypointDetailsDto? waypointDetails;
  final IncidentDetailsDto? incidentDetails;

  const RoutePointDto({
    required this.position,
    required this.type,
    this.speed,
    this.waypointDetails,
    this.incidentDetails,
  });

  factory RoutePointDto.fromJson(Map<String, dynamic> json) =>
      _$RoutePointDtoFromJson(json);
}
