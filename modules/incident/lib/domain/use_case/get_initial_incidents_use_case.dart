import 'package:common/index.dart';
import 'package:domain_core/domain/entity/incident_item_entity.dart';
import 'package:incident/domain/entity/incident_filter_entity.dart';
import 'package:incident/domain/repository/incident_repository.dart';

final class GetInitialIncidentsUseCase
    extends UseCase<List<IncidentEntity>, EmptyUsecaseParams> {
  final IncidentRepository repository;

  GetInitialIncidentsUseCase(this.repository);

  @override
  Future<UseCaseResult<List<IncidentEntity>>> call(EmptyUsecaseParams params) =>
      innerCall(() {
        final filter = IncidentFilterEntity();
        repository.saveIncidentFilter(filter);
        return repository.getIncidents(page: 1, filter: filter);
      });
}
