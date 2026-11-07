import 'package:common/index.dart';
import 'package:shipment/domain/entity/shipment_entity.dart';
import 'package:shipment/domain/repository/shipment_repository.dart';

final class GetShipmentUseCase extends UseCase<ShipmentEntity, String> {
  final ShipmentRepository repository;

  GetShipmentUseCase(this.repository);

  @override
  Future<UseCaseResult<ShipmentEntity>> call(String params) =>
      innerCall(() => repository.getShipment(id: params));
}
