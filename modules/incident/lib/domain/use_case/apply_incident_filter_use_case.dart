import 'package:common/index.dart';
import 'package:incident/domain/entity/incident_filter_entity.dart';
import 'package:incident/domain/repository/incident_repository.dart';

final class ApplyIncidentFilterUseCase
    extends SyncUseCase<EmptyUseCaseResult, IncidentFilterEntity?> {
  final IncidentRepository repository;

  ApplyIncidentFilterUseCase(this.repository);

  @override
  UseCaseResult<EmptyUseCaseResult> call(IncidentFilterEntity? params) => innerCall(() {
    repository.saveIncidentFilter(params);
    return const EmptyUseCaseResult();
  });
}
