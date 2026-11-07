import 'package:shipment/domain/entity/route_point_entity.dart';
import 'package:shipment/presentation/shipment_details/model/timeline_point.dart';

final class RouteModel {
  final String mapPoints;
  final String? mapLines;
  final String? mapPolygons;
  final List<RoutePointEntity> points;
  final TimelineModel timeline;

  RouteModel({
    required this.mapPoints,
    this.mapLines,
    this.mapPolygons,
    required this.points,
    required this.timeline,
  });
}

final class TimelineModel {
  final DateTime startDate;
  final DateTime endDate;
  final OriginTimelinePoint? originTimelinePoint;
  final DestinationTimelinePoint? destinationTimelinePoint;
  final CurrentTimelinePoint? currentTimelinePoint;
  final List<IncidentTimelinePoint> incidentTimelinePoint;

  TimelineModel({
    required this.startDate,
    required this.endDate,
    required this.incidentTimelinePoint,
    this.originTimelinePoint,
    this.destinationTimelinePoint,
    this.currentTimelinePoint,
  });
}
