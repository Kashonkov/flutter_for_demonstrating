import 'package:common/index.dart';
import 'package:incident/domain/entity/incident_filter_entity.dart';
import 'package:incident/domain/repository/incident_repository.dart';

final class GetFilterIncidentStreamUseCase
    extends SyncUseCase<Stream<IncidentFilterEntity?>, EmptyUsecaseParams> {
  final IncidentRepository repository;

  GetFilterIncidentStreamUseCase(this.repository);

  @override
  UseCaseResult<Stream<IncidentFilterEntity?>> call(EmptyUsecaseParams params) =>
      innerCall(() => repository.getIncidentFilterStream());
}
