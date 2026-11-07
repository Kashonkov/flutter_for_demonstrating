import 'package:common/index.dart';
import 'package:shipment/domain/entity/date_range.dart';
import 'package:shipment/domain/entity/delivery_status.dart';
import 'package:shipment/domain/entity/filter_shipment_status.dart';
import 'package:domain_core/domain/entity/seal_status.dart';
import 'package:shipment/domain/entity/shipment_filter_entity.dart';
import 'package:shipment/domain/entity/shipment_item_entity.dart';
import 'package:shipment/domain/repository/shipment_repository.dart';

final class GetInitialShipmentsUseCase
    extends UseCase<List<ShipmentItemEntity>, EmptyUsecaseParams> {
  final ShipmentRepository repository;

  GetInitialShipmentsUseCase(this.repository);

  @override
  Future<UseCaseResult<List<ShipmentItemEntity>>> call(EmptyUsecaseParams params) =>
      innerCall(() {
        final filter = ShipmentFilterEntity(range: DateRange(
            startDate: DateTime.now().subtract(Duration(days: 7)), endDate: DateTime.now()),
            deliveryStatuses: [DeliveryStatus.transit]);
        repository.saveShipmentFilter(filter);
        return repository.getShipments(page: 1, filter: filter);
      });
}
