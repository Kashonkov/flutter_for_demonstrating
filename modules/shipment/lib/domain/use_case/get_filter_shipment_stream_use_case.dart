import 'package:common/index.dart';
import 'package:shipment/domain/entity/shipment_filter_entity.dart';
import 'package:shipment/domain/repository/shipment_repository.dart';

final class GetFilterShipmentStreamUseCase
    extends SyncUseCase<Stream<ShipmentFilterEntity?>, EmptyUsecaseParams> {
  final ShipmentRepository repository;

  GetFilterShipmentStreamUseCase(this.repository);

  @override
  UseCaseResult<Stream<ShipmentFilterEntity?>> call(EmptyUsecaseParams params) =>
      innerCall(() => repository.getShipmentFilterStream());
}
