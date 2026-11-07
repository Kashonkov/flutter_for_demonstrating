import 'dart:async';

import 'package:collection/collection.dart';
import 'package:common/bloc/bloc.dart';
import 'package:common/usecase/usecase.dart';
import 'package:domain_core/domain/entity/incident_item_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:incident/domain/entity/incident_filter_entity.dart';
import 'package:incident/domain/use_case/apply_incident_filter_use_case.dart';
import 'package:incident/domain/use_case/get_filter_incident_stream_use_case.dart';
import 'package:incident/domain/use_case/get_incidents_use_case.dart';
import 'package:incident/navigation/incident_navigator.dart';
import 'package:incident/presentation/incident_item/model/incident_presentation_model.dart';
import 'package:incident/presentation/incidents_list/bloc/incidents_list_news.dart';
import 'package:incident/presentation/incidents_map/bloc/incident_map_event.dart';
import 'package:incident/presentation/incidents_map/bloc/incident_map_state.dart';
import 'package:intl/intl.dart';

const _incidentDateFormat = 'h:mma';

final class IncidentsMapBloc extends BaseBloc<IncidentMapEvent, IncidentMapState> {
  final GetIncidentsUseCase getIncidentsUseCase;
  final GetFilterIncidentStreamUseCase getFilterIncidentStreamUseCase;
  final ApplyIncidentFilterUseCase applyIncidentFilterUseCase;
  final IncidentNavigator navigator;

  StreamSubscription? _filterSubscription;
  IncidentFilterEntity? _filter;
  List<IncidentEntity> _incidents = [];

  IncidentsMapBloc({
    required this.getIncidentsUseCase,
    required this.getFilterIncidentStreamUseCase,
    required this.applyIncidentFilterUseCase,
    required this.navigator,
  }) : super(LoadingState()) {
    on<OnInitEvent>(_onInit);
    on<OnIncidentSelectEvent>(_onIncidentSelect);
    on<OnIncidentTapEvent>(_onIncidentTap);
    on<OnIncidentFilterReceivedEvent>(_onIncidentFilterReceived);
    on<OnQueryChangeEvent>(
      _onQueryChanged,
      transformer: debounceTransformer(Duration(milliseconds: 300)),
    );

    add(OnInitEvent());
  }

  void _onInit(OnInitEvent event, Emitter emit) {
    processSyncUseCase(
      getFilterIncidentStreamUseCase(EmptyUsecaseParams()),
      onSuccess: _processFilterStream,
    );
  }

  void _processFilterStream(Stream<IncidentFilterEntity?> stream) {
    _filterSubscription = stream.listen((filter) {
      add(OnIncidentFilterReceivedEvent(filter));
    });
  }

  Future<void> _onIncidentFilterReceived(OnIncidentFilterReceivedEvent event, Emitter emit) async {
    if(_filter == null){
      _filter = event.filter;
      addNews(ShowQueryNews(_filter?.query ?? ""));
    }

    await processUseCase(
      () => getIncidentsUseCase(GetIncidentUseCaseParams(page: 1, filter: event.filter)),
      onSuccess: (result) {
        _incidents = result;
        emit(DataState(incidents: result));
      },
    );
  }

  Future<void> _onQueryChanged(OnQueryChangeEvent event, Emitter emit) async {
    final incomeQuery = event.query.trim().isEmpty ? null : event.query;

    applyIncidentFilterUseCase(IncidentFilterEntity(query: incomeQuery));
  }

  void _onIncidentTap(OnIncidentTapEvent event, Emitter emit) {
    final incident = _findIncident(event.id);
    if (incident != null) {
      navigator.navigateToDetails(incident);
    }
  }

  void _onIncidentSelect(OnIncidentSelectEvent event, Emitter emit) {
    final incident = _findIncident(event.id);
    emit(
      DataState(
        incidents: _incidents,
        selectedIncident: incident != null ? _mapModel(incident) : null,
      ),
    );
  }

  IncidentEntity? _findIncident(String? id) {
    return _incidents.firstWhereOrNull((e) => e.id == id);
  }

  IncidentPresentationModel _mapModel(IncidentEntity incident) => IncidentPresentationModel(
    id: incident.id,
    shipment: incident.shipmentReference ?? incident.shipmentId,
    description: incident.description,
    positionDate: DateFormat(_incidentDateFormat).format(incident.position.time).toLowerCase(),
    positionTitle: incident.position.title,
    row: incident,
  );

  @override
  Future<void> close() {
    _filterSubscription?.cancel();
    return super.close();
  }
}
