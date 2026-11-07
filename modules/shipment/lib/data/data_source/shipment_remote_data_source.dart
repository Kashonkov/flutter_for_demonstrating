import 'package:api/exception/error_handler.dart';
import 'package:domain_core/domain/entity/seal_status.dart';
import 'package:shipment/data/api/shipment_api.dart';
import 'package:shipment/data/model/active_shipments_request.dart';
import 'package:shipment/data/model/complete_shipment_request.dart';
import 'package:shipment/data/model/converter/route_point_converter.dart';
import 'package:shipment/data/model/shipment_list_request.dart';
import 'package:shipment/domain/entity/date_range.dart';
import 'package:shipment/domain/entity/delivery_status.dart';
import 'package:shipment/domain/entity/route_point_entity.dart';
import 'package:shipment/domain/entity/shipment_entity.dart';
import 'package:shipment/domain/entity/shipment_item_entity.dart';
import 'package:shipment/domain/entity/shipment_status.dart';

abstract interface class ShipmentRemoteDataSource {
  Future<List<ShipmentItemEntity>> getShipments({
    String? query,
    required int page,
    final DateRange? range,
    final List<SealStatus>? sealStatuses,
    final List<DeliveryStatus>? deliveryStatuses,
  });

  Future<List<ShipmentItemEntity>> getActiveShipments({
    String? query,
    final DateRange? range,
    final List<SealStatus>? sealStatuses,
  });

  Future<ShipmentEntity> getShipment({required String id});

  Future<List<RoutePointEntity>> getRoute(String shipmentId);

  Future<ShipmentEntity> completeShipment({
    required String id,
    String? address,
    required ShipmentStatus status,
    String? comment,
  });
}

const _requestAmount = 50;

final class ShipmentRemoteDataSourceImpl implements ShipmentRemoteDataSource {
  final ShipmentApi _shipmentApi;
  final RoutePointConverter _converter;

  ShipmentRemoteDataSourceImpl(this._shipmentApi, this._converter);

  @override
  Future<List<ShipmentItemEntity>> getShipments({
    String? query,
    required int page,
    final DateRange? range,
    final List<SealStatus>? sealStatuses,
    final List<DeliveryStatus>? deliveryStatuses,
  }) async {
    final hasQuery = query != null && query.isNotEmpty;
    final shipments = await checkNetErrors(
      () => _shipmentApi.getShipmentList(
        ShipmentsListRequest(
          query: hasQuery ? query : null,
          dateFrom: range?.startDate,
          dateTo: range?.endDate,
          deliveryStatus: deliveryStatuses,
          sealStatus: sealStatuses,
          page: page,
          pageSize: _requestAmount,
        ),
      ),
    );
    return shipments.items.map((dto) => dto.toItemEntity()).toList();
  }

  @override
  Future<ShipmentEntity> getShipment({required String id}) async {
    final result = await checkNetErrors(() => _shipmentApi.getShipmentById(id));
    return result.toEntity();
  }

  @override
  Future<List<ShipmentItemEntity>> getActiveShipments({
    String? query,
    DateRange? range,
    List<SealStatus>? sealStatuses,
  }) async {
    final hasQuery = query != null && query.isNotEmpty;
    final shipments = await checkNetErrors(
      () => _shipmentApi.getActiveShipments(
        ActiveShipmentsRequest(
          query: hasQuery ? query : null,
          dateFrom: range?.startDate,
          dateTo: range?.endDate,
          sealStatus: sealStatuses,
        ),
      ),
    );
    return shipments.map((shipment) => shipment.toItemEntity()).toList();
  }

  @override
  Future<List<RoutePointEntity>> getRoute(String shipmentId) async {
    final route = await checkNetErrors(() => _shipmentApi.getRoute(shipmentId, 3220));

    final List<RoutePointEntity> points = [];

    for (final routePoint in route) {
      final entity = _converter.convert(routePoint);
      if (entity != null) {
        points.add(entity);
      }
    }

    return points;
  }

  @override
  Future<ShipmentEntity> completeShipment({
    required String id,
    String? address,
    required ShipmentStatus status,
    String? comment,
  }) async {
    final result = await checkNetErrors(
      () => _shipmentApi.completeShipment(
        id,
        CompleteShipmentRequest(status: status, customLocation: address, comment: comment),
      ),
    );
    return result.toEntity();
  }
}
