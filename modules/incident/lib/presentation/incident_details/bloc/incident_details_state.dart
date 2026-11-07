import 'package:incident/presentation/incident_details/model/incident_presentation_model.dart';

sealed class IncidentDetailsState {}

final class LoadingState extends IncidentDetailsState {}

final class DataState extends IncidentDetailsState {
  final IncidentPresentationModel model;
  final bool isShareLoading;
  final bool isDownloadLoading;

  DataState({required this.model, this.isShareLoading = false, this.isDownloadLoading = false});
}
