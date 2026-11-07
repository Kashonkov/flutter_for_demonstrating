import 'package:common/index.dart';
import 'package:domain_core/domain/entity/incident_item_entity.dart';
import 'package:incident/domain/entity/incident_filter_entity.dart';
import 'package:incident/domain/repository/incident_repository.dart';

final class GetIncidentsUseCase extends UseCase<List<IncidentEntity>, GetIncidentUseCaseParams> {
  final IncidentRepository repository;

  GetIncidentsUseCase(this.repository);

  @override
  Future<UseCaseResult<List<IncidentEntity>>> call(GetIncidentUseCaseParams params) =>
      innerCall(() => repository.getIncidents(page: params.page, filter: params.filter));
}

final class GetIncidentUseCaseParams {
  final int page;
  final IncidentFilterEntity? filter;

  GetIncidentUseCaseParams({required this.page, this.filter});
}
