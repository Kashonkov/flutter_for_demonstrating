import 'package:domain_core/domain/entity/incident_item_entity.dart';
import 'package:incident/domain/entity/incident_filter_entity.dart';

abstract interface class IncidentRepository {
  Future<List<IncidentEntity>> getIncidents({IncidentFilterEntity? filter, required int page});

  Future<void> downloadReport(String id);

  Future<String> downloadShareReport(String id);

  void saveIncidentFilter(IncidentFilterEntity? filter);

  Stream<IncidentFilterEntity?> getIncidentFilterStream();
}
