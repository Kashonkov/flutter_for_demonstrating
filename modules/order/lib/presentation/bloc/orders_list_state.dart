import 'package:list_view_handler/list_view_handler.dart';

sealed class OrdersListState {}

final class LoadingState extends OrdersListState {}

final class OrdersDataState extends OrdersListState {
  final ListViewHandlerState listState;

  OrdersDataState(this.listState);
}
