import 'package:shipment/data/model/route_point_dto.dart';
import 'package:shipment/data/model/route_point_type.dart';
import 'package:shipment/domain/entity/route_point_entity.dart';

abstract interface class RoutePointConverter {
  RoutePointEntity? convert(RoutePointDto dto);
}

final class RoutePointConverterImpl implements RoutePointConverter {
  @override
  RoutePointEntity? convert(RoutePointDto dto) {
    final type = dto.type;

    return switch (type) {
      RoutePointType.origin => _mapOrigin(dto),
      RoutePointType.destination => _mapDestination(dto),
      RoutePointType.incident => _mapIncident(dto),
      RoutePointType.waypoint => _mapWaypoint(dto),
      RoutePointType.currentPosition => _mapCurrent(dto),
      RoutePointType.undefined => null,
    };
  }

  OriginPointEntity _mapOrigin(RoutePointDto dto) =>
      OriginPointEntity(position: dto.position.toEntity());

  DestinationPointEntity _mapDestination(RoutePointDto dto) =>
      DestinationPointEntity(position: dto.position.toEntity());

  IncidentPointEntity? _mapIncident(RoutePointDto dto) {
    final incident = dto.incidentDetails?.incident;
    if (incident == null) return null;
    return IncidentPointEntity(position: dto.position.toEntity(), incident: incident.toEntity());
  }

  WaypointEntity? _mapWaypoint(RoutePointDto dto) {
    final details = dto.waypointDetails;
    if (details == null) return null;
    return WaypointEntity(
      position: dto.position.toEntity(),
      count: details.count,
      rangeInMeters: details.rangeInMeters,
      enteredAt: details.enteredAt,
      leftAt: details.leftAt,
    );
  }

  CurrentPointEntity _mapCurrent(RoutePointDto dto) =>
      CurrentPointEntity(position: dto.position.toEntity(), speed: dto.speed);
}
