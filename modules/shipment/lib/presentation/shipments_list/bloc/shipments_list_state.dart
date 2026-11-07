import 'package:list_view_handler/list_view_handler.dart';
import 'package:shipment/domain/entity/delivery_status.dart';

sealed class ShipmentsListState {}

final class LoadingState extends ShipmentsListState {}

final class ShipmentsDataState extends ShipmentsListState {
  final ListViewHandlerState listState;
  final DeliveryStatus selectedStatus;
  final bool isMapVisible;

  ShipmentsDataState(this.listState, this.selectedStatus, this.isMapVisible);
}
