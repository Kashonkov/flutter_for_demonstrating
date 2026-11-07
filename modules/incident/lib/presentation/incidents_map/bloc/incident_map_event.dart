import 'package:incident/domain/entity/incident_filter_entity.dart';

sealed class IncidentMapEvent {}

final class OnInitEvent extends IncidentMapEvent{}


final class OnIncidentSelectEvent extends IncidentMapEvent {
  final String? id;

  OnIncidentSelectEvent({required this.id});
}

final class OnIncidentTapEvent extends IncidentMapEvent {
  final String id;

  OnIncidentTapEvent({required this.id});
}

final class OnQueryChangeEvent extends IncidentMapEvent {
  final String query;

  OnQueryChangeEvent(this.query);
}


final class OnIncidentFilterReceivedEvent extends IncidentMapEvent{
  final IncidentFilterEntity? filter;

  OnIncidentFilterReceivedEvent(this.filter);
}
