import 'package:incident/domain/entity/incident_filter_entity.dart';
import 'package:incident/presentation/incident_item/model/incident_presentation_model.dart';
import 'package:list_view_handler/list_view_handler.dart';

sealed class IncidentsListEvent {}

final class OnInitialEvent extends IncidentsListEvent {}

final class OnQueryChangeEvent extends IncidentsListEvent {
  final String query;

  OnQueryChangeEvent(this.query);
}

final class OnLoadMoreDataEvent extends IncidentsListEvent {}

final class OnListSideEffectEvent extends IncidentsListEvent {
  final SideEffectEvent sideEffect;

  OnListSideEffectEvent(this.sideEffect);
}

final class OnListRenderEvent extends IncidentsListEvent {
  final ListViewHandlerState state;

  OnListRenderEvent(this.state);
}

final class OnItemTapEvent extends IncidentsListEvent {
  final IncidentPresentationModel item;

  OnItemTapEvent(this.item);
}

final class OnMapTapEvent extends IncidentsListEvent {}

final class OnIncidentFilterReceivedEvent extends IncidentsListEvent {
  final IncidentFilterEntity? filter;

  OnIncidentFilterReceivedEvent(this.filter);
}

final class RepeatEvent extends IncidentsListEvent {}
