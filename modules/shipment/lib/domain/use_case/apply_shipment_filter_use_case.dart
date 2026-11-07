import 'package:common/index.dart';
import 'package:shipment/domain/entity/shipment_filter_entity.dart';
import 'package:shipment/domain/repository/shipment_repository.dart';

final class ApplyShipmentFilterUseCase
    extends SyncUseCase<EmptyUseCaseResult, ShipmentFilterEntity?> {
  final ShipmentRepository repository;

  ApplyShipmentFilterUseCase(this.repository);

  @override
  UseCaseResult<EmptyUseCaseResult> call(ShipmentFilterEntity? params) => innerCall(() {
    repository.saveShipmentFilter(params);
    return const EmptyUseCaseResult();
  });
}
