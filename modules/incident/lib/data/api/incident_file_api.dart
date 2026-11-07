import 'package:api/api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

abstract interface class IncidentFileApi {
  Future<String> downloadIncidentReport(String id);
}

final class IncidentFileApiImpl implements IncidentFileApi {
  final ApiClient client;

  IncidentFileApiImpl(this.client);

  @override
  Future<String> downloadIncidentReport(String id) async {
    final dio = client.dio;
    final path = "${(await getTemporaryDirectory()).path}/$id.pdf";
    await dio.download(
      "${dio.options.baseUrl}/api/incident/$id/report",
      path,
      options: Options(method: 'POST'),
    );
    return path;
  }
}
