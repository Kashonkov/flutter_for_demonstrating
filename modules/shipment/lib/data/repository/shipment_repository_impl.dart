import 'package:shipment/data/data_source/shipment_local_data_source.dart';
import 'package:shipment/data/data_source/shipment_remote_data_source.dart';
import 'package:shipment/domain/entity/filter_shipment_status.dart';
import 'package:shipment/domain/entity/route_point_entity.dart';
import 'package:shipment/domain/entity/shipment_entity.dart';
import 'package:shipment/domain/entity/shipment_filter_entity.dart';
import 'package:shipment/domain/entity/shipment_item_entity.dart';
import 'package:shipment/domain/entity/shipment_status.dart';
import 'package:shipment/domain/repository/shipment_repository.dart';

final class ShipmentRepositoryImpl implements ShipmentRepository {
  final ShipmentRemoteDataSource remoteDataSource;
  final ShipmentLocalDataSource localDataSource;

  ShipmentRepositoryImpl(this.remoteDataSource, this.localDataSource);

  @override
  Future<List<ShipmentItemEntity>> getShipments({
    required int page,
    ShipmentFilterEntity? filter,
  }) => remoteDataSource.getShipments(
    page: page,
    query: filter?.query,
    range: filter?.range,
    sealStatuses: filter?.status?.mapSealStatuses(),
    deliveryStatuses: filter?.deliveryStatuses,
  );

  @override
  Future<ShipmentEntity> getShipment({required String id}) => remoteDataSource.getShipment(id: id);

  @override
  Future<List<ShipmentItemEntity>> getActiveShipments({ShipmentFilterEntity? filter}) =>
      remoteDataSource.getActiveShipments(
        query: filter?.query,
        range: filter?.range,
        sealStatuses: filter?.status?.mapSealStatuses(),
      );

  @override
  Stream<ShipmentFilterEntity?> getShipmentFilterStream() => localDataSource.getFilterStream();

  @override
  void saveShipmentFilter(ShipmentFilterEntity? filter) {
    localDataSource.saveFilter(filter);
  }

  @override
  Future<List<RoutePointEntity>> getRoute(String shipmentId) =>
      remoteDataSource.getRoute(shipmentId);

  @override
  Future<ShipmentEntity> completeShipment({required String id, String? address, required ShipmentStatus status, String? comment}) => remoteDataSource.completeShipment(id: id, status: status, address: address, comment: comment);
}
