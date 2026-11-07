import 'package:shipment/domain/entity/route_point_entity.dart';
import 'package:shipment/domain/entity/shipment_entity.dart';
import 'package:shipment/domain/entity/shipment_filter_entity.dart';
import 'package:shipment/domain/entity/shipment_item_entity.dart';
import 'package:shipment/domain/entity/shipment_status.dart';

abstract interface class ShipmentRepository {
  Future<List<ShipmentItemEntity>> getShipments({required int page, ShipmentFilterEntity? filter});

  Future<List<ShipmentItemEntity>> getActiveShipments({ShipmentFilterEntity? filter});

  Future<ShipmentEntity> completeShipment({required String id, String? address, required ShipmentStatus status, String? comment});

  Future<ShipmentEntity> getShipment({required String id});

  void saveShipmentFilter(ShipmentFilterEntity? filter);

  Stream<ShipmentFilterEntity?> getShipmentFilterStream();

  Future<List<RoutePointEntity>> getRoute(String shipmentId);
}
