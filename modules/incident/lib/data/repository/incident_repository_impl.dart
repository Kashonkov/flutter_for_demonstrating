import 'package:incident/data/data_source/incident_local_data_source.dart';
import 'package:incident/data/data_source/incident_remote_data_source.dart';
import 'package:domain_core/domain/entity/incident_item_entity.dart';
import 'package:incident/domain/entity/incident_filter_entity.dart';
import 'package:incident/domain/repository/incident_repository.dart';

final class IncidentRepositoryImpl implements IncidentRepository {
  final IncidentRemoteDataSource remoteDataSource;
  final IncidentLocalDataSource localDataSource;

  IncidentRepositoryImpl(this.remoteDataSource, this.localDataSource);

  @override
  Future<List<IncidentEntity>> getIncidents({IncidentFilterEntity? filter, required int page}) =>
      remoteDataSource.getIncidents(page: page, query: filter?.query);

  @override
  Future<void> downloadReport(String id) => remoteDataSource.downloadReport(id);

  @override
  Future<String> downloadShareReport(String id) => remoteDataSource.downloadSharingReport(id);

  @override
  Stream<IncidentFilterEntity?> getIncidentFilterStream() => localDataSource.getFilterStream();

  @override
  void saveIncidentFilter(IncidentFilterEntity? filter) {
    localDataSource.saveFilter(filter);
  }
}
