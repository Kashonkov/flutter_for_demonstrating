import 'package:domain_core/domain/entity/incident_item_entity.dart';
import 'package:incident/presentation/incident_item/model/incident_presentation_model.dart';

sealed class IncidentMapState {}

final class LoadingState extends IncidentMapState {}

final class DataState extends IncidentMapState {
  final List<IncidentEntity> incidents;
  final IncidentPresentationModel? selectedIncident;

  DataState({required this.incidents,  this.selectedIncident});
}