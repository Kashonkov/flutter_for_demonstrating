import 'package:json_annotation/json_annotation.dart';

part 'incident_list_request.g.dart';

@JsonSerializable(createFactory: false, includeIfNull: false)
final class IncidentListRequest {
  final String? query;
  final int page;
  final int pageSize;

  IncidentListRequest({this.query, required this.page, required this.pageSize});

  Map<String, dynamic> toJson() => _$IncidentListRequestToJson(this);
}
