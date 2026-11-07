import 'package:common/index.dart';
import 'package:shipment/domain/entity/shipment_entity.dart';
import 'package:shipment/domain/entity/shipment_status.dart';
import 'package:shipment/domain/repository/shipment_repository.dart';

final class CompleteShipmentUseCase
    extends UseCase<ShipmentEntity, CompleteShipmentsUseCaseParams> {
  final ShipmentRepository _repository;

  CompleteShipmentUseCase(this._repository);

  @override
  Future<UseCaseResult<ShipmentEntity>> call(CompleteShipmentsUseCaseParams params) => innerCall(
    () => _repository.completeShipment(
      id: params.id,
      address: params.address,
      comment: params.comment,
      status: params.status,
    ),
  );
}

final class CompleteShipmentsUseCaseParams {
  final String id;
  final String? address;
  final String? comment;
  final ShipmentStatus status;

  CompleteShipmentsUseCaseParams(this.id, this.address, this.comment, this.status);
}
