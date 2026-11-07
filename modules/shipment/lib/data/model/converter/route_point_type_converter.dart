import 'package:json_annotation/json_annotation.dart';
import 'package:shipment/data/model/route_point_type.dart';

const _origin = "origin";
const _destination = "destination";
const _incident = "incident";
const _waypoint = "waypoint";
const _currentPosition = "currentPosition";

final class RoutePointTypeConverter extends JsonConverter<RoutePointType, String> {
  const RoutePointTypeConverter();

  @override
  RoutePointType fromJson(String json) {
    return switch (json) {
      _origin => RoutePointType.origin,
      _destination => RoutePointType.destination,
      _incident => RoutePointType.incident,
      _waypoint => RoutePointType.waypoint,
      _currentPosition => RoutePointType.currentPosition,
      _ => RoutePointType.undefined,
    };
  }

  @override
  String toJson(RoutePointType object) {
    return switch (object) {
      RoutePointType.origin => _origin,
      RoutePointType.destination => _destination,
      RoutePointType.incident => _incident,
      RoutePointType.waypoint => _waypoint,
      RoutePointType.currentPosition => _currentPosition,
      RoutePointType.undefined => "",
    };
  }
}
