import 'package:rxdart/rxdart.dart';
import 'package:shipment/domain/entity/shipment_filter_entity.dart';

abstract interface class ShipmentLocalDataSource {
  ShipmentFilterEntity? getFilter();

  void saveFilter(ShipmentFilterEntity? filter);

  Stream<ShipmentFilterEntity?> getFilterStream();
}

base class ShipmentLocalDataSourceImpl implements ShipmentLocalDataSource {
  ShipmentFilterEntity? _filter;
  final BehaviorSubject<ShipmentFilterEntity?> _controller = BehaviorSubject.seeded(null);

  @override
  ShipmentFilterEntity? getFilter() => _filter;

  @override
  Stream<ShipmentFilterEntity?> getFilterStream() => _controller.stream;

  @override
  void saveFilter(ShipmentFilterEntity? filter) {
    if (_filter != filter) {
      _filter = filter;
      _controller.add(filter);
    }
  }

  Future<void> dispose() => _controller.close();
}
