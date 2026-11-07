import 'package:list_view_handler/list_view_handler.dart';

sealed class IncidentsListState {}

final class LoadingState extends IncidentsListState {}

final class IncidentsDataState extends IncidentsListState {
  final ListViewHandlerState listState;

  IncidentsDataState(this.listState);
}
