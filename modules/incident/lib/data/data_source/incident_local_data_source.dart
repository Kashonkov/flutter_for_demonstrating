import 'package:incident/domain/entity/incident_filter_entity.dart';
import 'package:rxdart/rxdart.dart';

abstract interface class IncidentLocalDataSource {
  IncidentFilterEntity? getFilter();

  void saveFilter(IncidentFilterEntity? filter);

  Stream<IncidentFilterEntity?> getFilterStream();
}

base class IncidentLocalDataSourceImpl implements IncidentLocalDataSource {
  IncidentFilterEntity? _filter;
  final BehaviorSubject<IncidentFilterEntity?> _controller = BehaviorSubject.seeded(null);

  @override
  IncidentFilterEntity? getFilter() => _filter;

  @override
  Stream<IncidentFilterEntity?> getFilterStream() => _controller.stream;

  @override
  void saveFilter(IncidentFilterEntity? filter) {
    if (_filter != filter) {
      _filter = filter;
      _controller.add(filter);
    }
  }

  Future<void> dispose() => _controller.close();
}
