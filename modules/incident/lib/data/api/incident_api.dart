import 'package:api/api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:incident/data/model/incident_list_request.dart';
import 'package:incident/data/model/incidents_page_dto.dart';
import 'package:retrofit/http.dart';
import 'package:retrofit/retrofit.dart';

part 'incident_api.g.dart';

@RestApi()
abstract class IncidentApi {
  factory IncidentApi(ApiClient client) => _IncidentApi(client.dio);

  @POST('/api/incident/list')
  Future<IncidentsPageDto> getIncidentList(@Body() IncidentListRequest body);
}
