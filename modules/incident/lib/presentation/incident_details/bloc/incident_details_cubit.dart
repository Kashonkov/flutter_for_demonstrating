import 'dart:convert';

import 'package:common/bloc/base_cubit.dart';
import 'package:common/utils/geo_utils.dart';
import 'package:common/utils/string_utils.dart';
import 'package:domain_core/domain/entity/incident_item_entity.dart';
import 'package:incident/domain/use_case/download_incident_report_use_case.dart';
import 'package:incident/domain/use_case/download_share_report_incident_report_use_case.dart';
import 'package:incident/navigation/incident_navigator.dart';
import 'package:incident/presentation/incident_details/bloc/incident_details_state.dart';
import 'package:incident/presentation/incident_details/model/incident_presentation_model.dart';
import 'package:share_plus/share_plus.dart';

final class IncidentDetailsCubit extends BaseCubit<IncidentDetailsState> {
  final IncidentEntity incident;
  final IncidentNavigator navigator;
  final DownloadIncidentReportUseCase downloadIncidentReportUseCase;
  final DownloadShareReportIncidentReportUseCase downloadShareReportIncidentReportUseCase;

  IncidentDetailsCubit({
    required this.incident,
    required this.navigator,
    required this.downloadIncidentReportUseCase,
    required this.downloadShareReportIncidentReportUseCase,
  }) : super(LoadingState()) {
    _onInit();
  }

  void _onInit() {
    emit(DataState(model: _map(incident)));
  }

  IncidentPresentationModel _map(IncidentEntity incident) {
    final position = incident.position;
    final accuracy = incident.accuracyInMeters;
    final incidentInfo = IncidentInfoPresentationModel(
      shipment: incident.shipmentReference ?? incident.shipmentId,
      status: incident.description,
      address: incident.position.title,
      createdDate: incident.createdDate.format(),
      updatedDate: position.time.format(),
      lat: incident.position.latitude,
      long: incident.position.longitude,
      range: accuracy,
      incidentMapRange: _incidentRangesToGeoJson(incident),
      accuracy: accuracy != null ? accuracy / 1000 : null,
    );

    final containerInfo = ContainerInfoPresentationModel(
      reference: incident.shipmentReference ?? "",
      number: incident.shipmentContainer ?? "",
    );

    return IncidentPresentationModel(containerInfo: containerInfo, incidentInfo: incidentInfo);
  }

  void onOpenShipmentTap() {
    navigator.navigateToShipment(incident.shipmentId);
  }

  void onDownloadTap() {
    emit(DataState(model: _map(incident), isDownloadLoading: true));
    processUseCase(() => downloadIncidentReportUseCase(incident.id), onSuccess: (_) {
      emit(DataState(model: _map(incident)));
    });
  }

  void onShareTap() async {
    emit(DataState(model: _map(incident), isShareLoading: true));
    await processUseCase(
      () => downloadShareReportIncidentReportUseCase(incident.id),
      onSuccess: (result) {
        _share(result);
      },
    );
    emit(DataState(model: _map(incident), isShareLoading: false));
  }

  void _share(String path) async {
    final params = ShareParams(files: [XFile(path)]);

    final result = await SharePlus.instance.share(params);

    if (result.status == ShareResultStatus.success) {
    }
  }

  String? _incidentRangesToGeoJson(IncidentEntity incident) {
    final features = <Map<String, dynamic>>[];

    double radiusMeters = incident.accuracyInMeters?.toDouble() ?? 0;
    if (radiusMeters <= 0) return null;

    final lon = incident.position.longitude;
    final lat = incident.position.latitude;

    final ring = buildGeodesicCircleRing(
      lon: lon,
      lat: lat,
      radiusMeters: radiusMeters.toDouble(),
      segments: 64,
    );

    features.add({
      "type": "Feature",
      "geometry": {
        "type": "Polygon",
        "coordinates": [ring],
      },
      "properties": {
        "rangeType": "incident", // "incident" / "waypoint"
        "radiusMeters": radiusMeters,
      },
    });

    return jsonEncode({"type": "FeatureCollection", "features": features});
  }
}
