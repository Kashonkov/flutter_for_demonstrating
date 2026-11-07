import 'package:common/index.dart';
import 'package:incident/domain/repository/incident_repository.dart';

final class DownloadShareReportIncidentReportUseCase extends UseCase<String, String>{
  final IncidentRepository repository;

  DownloadShareReportIncidentReportUseCase(this.repository);

  @override
  Future<UseCaseResult<String>> call(String params) => innerCall(() => repository.downloadShareReport(params));
}