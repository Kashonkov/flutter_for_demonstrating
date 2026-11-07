import 'package:domain_core/domain/entity/incident_item_entity.dart';
import 'package:domain_core/domain/entity/position_entity.dart';
import 'package:uuid/uuid.dart';

sealed class RoutePointEntity {
  final String id = Uuid().v4();
  final PositionEntity position;

  RoutePointEntity({required this.position});
}

final class OriginPointEntity extends RoutePointEntity {
  OriginPointEntity({required super.position});
}

final class DestinationPointEntity extends RoutePointEntity {
  DestinationPointEntity({required super.position});
}

final class IncidentPointEntity extends RoutePointEntity {
  final IncidentEntity incident;

  IncidentPointEntity({required super.position, required this.incident});
}

final class WaypointEntity extends RoutePointEntity {
  final int count;
  final double rangeInMeters;
  final double? speed;
  final DateTime enteredAt;
  final DateTime leftAt;

  WaypointEntity({
    required super.position,
    required this.count,
    required this.rangeInMeters,
    required this.enteredAt,
    required this.leftAt,
    this.speed,
  });
}

final class CurrentPointEntity extends RoutePointEntity {
  final double? speed;

  CurrentPointEntity({required super.position, required this.speed});
}
