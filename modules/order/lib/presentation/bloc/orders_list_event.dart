import 'package:list_view_handler/list_view_handler.dart';

sealed class OrdersListEvent {}

final class OnInitialEvent extends OrdersListEvent {}

final class OnQueryChangeEvent extends OrdersListEvent {
  final String query;

  OnQueryChangeEvent(this.query);
}

final class OnLoadMoreDataEvent extends OrdersListEvent {}

final class OnListSideEffectEvent extends OrdersListEvent {
  final SideEffectEvent sideEffect;

  OnListSideEffectEvent(this.sideEffect);
}

final class OnListRenderEvent extends OrdersListEvent {
  final ListViewHandlerState state;

  OnListRenderEvent(this.state);
}
