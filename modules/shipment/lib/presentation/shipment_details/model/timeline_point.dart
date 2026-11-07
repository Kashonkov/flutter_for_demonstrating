import 'package:shipment/domain/entity/route_point_entity.dart';

final class TimelinePoint {
  final double timeProgress;

  TimelinePoint({required this.timeProgress});
}

final class IncidentTimelinePoint extends TimelinePoint {
  final IncidentPointEntity point;

  IncidentTimelinePoint({required super.timeProgress, required this.point});
}

final class OriginTimelinePoint extends TimelinePoint {
  final OriginPointEntity point;

  OriginTimelinePoint({required super.timeProgress, required this.point});
}

final class DestinationTimelinePoint extends TimelinePoint {
  final DestinationPointEntity point;

  DestinationTimelinePoint({required super.timeProgress, required this.point});
}

final class CurrentTimelinePoint extends TimelinePoint {
  final CurrentPointEntity point;

  CurrentTimelinePoint({required super.timeProgress, required this.point});
}
