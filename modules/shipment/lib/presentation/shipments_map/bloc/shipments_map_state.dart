import 'package:shipment/domain/entity/shipment_item_entity.dart';
import 'package:shipment/presentation/presentation/shipment_item_model.dart';

sealed class ShipmentsMapState {}

final class IdleState extends ShipmentsMapState {}

final class DataState extends ShipmentsMapState {
  final List<ShipmentItemEntity> shipments;
  final ShipmentItemModel? selectedShipment;

  DataState({required this.shipments, this.selectedShipment});
}
