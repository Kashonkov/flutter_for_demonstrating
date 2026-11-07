import 'package:common/index.dart';
import 'package:incident/domain/repository/incident_repository.dart';

final class DownloadIncidentReportUseCase extends UseCase<EmptyUseCaseResult, String>{
  final IncidentRepository repository;

  DownloadIncidentReportUseCase(this.repository);

  @override
  Future<UseCaseResult<EmptyUseCaseResult>> call(String params) => innerCall(() async{
    await repository.downloadReport(params);
    return const EmptyUseCaseResult();
  });
}