import 'package:domain_core/domain/entity/incident_item_entity.dart';

sealed class IncidentListPresentationModel {}

final class TodayPresentationModel extends IncidentListPresentationModel {}

final class YesterdayPresentationModel extends IncidentListPresentationModel {}

final class DatePresentationModel extends IncidentListPresentationModel {
  final String date;

  DatePresentationModel({required this.date});
}

final class IncidentPresentationModel extends IncidentListPresentationModel {
  final String id;
  final String shipment;
  final String description;
  final String positionDate;
  final String positionTitle;
  final IncidentEntity row;

  IncidentPresentationModel({
    required this.id,
    required this.shipment,
    required this.description,
    required this.positionDate,
    required this.positionTitle,
    required this.row,
  });
}
