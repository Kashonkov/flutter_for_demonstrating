import 'package:common/index.dart';
import 'package:shipment/domain/entity/route_point_entity.dart';
import 'package:shipment/domain/repository/shipment_repository.dart';

final class GetShipmentRouteUseCase
    extends UseCase<List<RoutePointEntity>, GetShipmentRouteUseCaseParams> {
  final ShipmentRepository repository;

  GetShipmentRouteUseCase(this.repository);

  @override
  Future<UseCaseResult<List<RoutePointEntity>>> call(GetShipmentRouteUseCaseParams params) =>
      innerCall(() => repository.getRoute(params.shipmentId));
}

final class GetShipmentRouteUseCaseParams {
  final String shipmentId;

  GetShipmentRouteUseCaseParams({required this.shipmentId});
}
