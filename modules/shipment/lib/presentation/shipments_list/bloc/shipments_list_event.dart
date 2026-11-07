import 'package:list_view_handler/list_view_handler.dart';
import 'package:shipment/domain/entity/delivery_status.dart';
import 'package:shipment/domain/entity/shipment_filter_entity.dart';
import 'package:shipment/presentation/shipment_filter_bottom_sheet/model/shipment_filter.dart';
import 'package:shipment/presentation/shipments_list/model/shipment_presentation_model.dart';

sealed class ShipmentsListEvent {}

final class OnInitialEvent extends ShipmentsListEvent {}

final class OnQueryChangeEvent extends ShipmentsListEvent {
  final String query;

  OnQueryChangeEvent(this.query);
}

final class OnLoadMoreDataEvent extends ShipmentsListEvent {}

final class OnListSideEffectEvent extends ShipmentsListEvent {
  final SideEffectEvent sideEffect;

  OnListSideEffectEvent(this.sideEffect);
}

final class OnListRenderEvent extends ShipmentsListEvent {
  final ListViewHandlerState state;

  OnListRenderEvent(this.state);
}

final class OnItemTapEvent extends ShipmentsListEvent {
  final ShipmentPresentationModel item;

  OnItemTapEvent(this.item);
}

final class OnFiltersTapEvent extends ShipmentsListEvent {}

final class OnFilterSelectedEvent extends ShipmentsListEvent {
  final ShipmentBottomFilters filter;

  OnFilterSelectedEvent(this.filter);
}

final class OnShipmentFilterReceivedEvent extends ShipmentsListEvent {
  final ShipmentFilterEntity? filter;

  OnShipmentFilterReceivedEvent(this.filter);
}

final class OnMapTapEvent extends ShipmentsListEvent {}

final class OnShipmentUpdateEvent extends ShipmentsListEvent {}

final class OnChangeDeliveryStatus extends ShipmentsListEvent {
  final DeliveryStatus status;

  OnChangeDeliveryStatus(this.status);
}

final class RepeatEvent extends ShipmentsListEvent {}
