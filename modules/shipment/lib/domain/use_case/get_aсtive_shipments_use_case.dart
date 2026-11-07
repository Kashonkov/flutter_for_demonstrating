import 'package:common/index.dart';
import 'package:shipment/domain/entity/date_range.dart';
import 'package:shipment/domain/entity/delivery_status.dart';
import 'package:shipment/domain/entity/filter_shipment_status.dart';
import 'package:domain_core/domain/entity/seal_status.dart';
import 'package:shipment/domain/entity/shipment_filter_entity.dart';
import 'package:shipment/domain/entity/shipment_item_entity.dart';
import 'package:shipment/domain/repository/shipment_repository.dart';

final class GetActiveShipmentsUseCase
    extends UseCase<List<ShipmentItemEntity>, ShipmentFilterEntity?> {
  final ShipmentRepository repository;

  GetActiveShipmentsUseCase(this.repository);

  @override
  Future<UseCaseResult<List<ShipmentItemEntity>>> call(ShipmentFilterEntity? params) =>
      innerCall(() => repository.getActiveShipments(filter: params));
}
