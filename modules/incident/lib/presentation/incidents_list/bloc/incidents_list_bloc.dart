import 'dart:async';

import 'package:common/bloc/base_bloc.dart';
import 'package:common/bloc/repeatable_use_case_processor_bloc_mixin.dart';
import 'package:common/index.dart';
import 'package:domain_core/domain/entity/incident_item_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:incident/domain/entity/incident_filter_entity.dart';
import 'package:incident/domain/use_case/apply_incident_filter_use_case.dart';
import 'package:incident/domain/use_case/get_filter_incident_stream_use_case.dart';
import 'package:incident/domain/use_case/get_incidents_use_case.dart';
import 'package:incident/domain/use_case/get_initial_incidents_use_case.dart';
import 'package:incident/navigation/incident_navigator.dart';
import 'package:incident/presentation/incident_item/model/incident_presentation_model.dart';
import 'package:incident/presentation/incidents_list/bloc/incidents_list_event.dart';
import 'package:incident/presentation/incidents_list/bloc/incidents_list_news.dart';
import 'package:incident/presentation/incidents_list/bloc/incidents_list_state.dart';
import 'package:intl/intl.dart';
import 'package:list_view_handler/list_view_handler.dart';

const _dateFormat = 'MM/dd/yyyy';
const _incidentDateFormat = 'h:mma';

final class IncidentsListBloc extends BaseBloc<IncidentsListEvent, IncidentsListState> with RepeatableUseCaseProcessorBlocMixin{
  final GetIncidentsUseCase getIncidentsUseCase;
  final GetInitialIncidentsUseCase getInitialIncidentsUseCase;
  final ApplyIncidentFilterUseCase applyIncidentFilterUseCase;
  final GetFilterIncidentStreamUseCase getFilterIncidentStreamUseCase;
  final ListViewHandler<IncidentListPresentationModel> listViewHandler;
  final IncidentNavigator navigator;

  StreamSubscription? _listSubscription;
  StreamSubscription? _filterSubscription;
  String? _query;
  IncidentEntity? _lastLoadedIncident;
  IncidentFilterEntity? _incidentFilter;

  IncidentsListBloc({
    required this.getIncidentsUseCase,
    required this.listViewHandler,
    required this.navigator,
    required this.getInitialIncidentsUseCase,
    required this.applyIncidentFilterUseCase,
    required this.getFilterIncidentStreamUseCase,
  }) : super(LoadingState()) {
    on<OnInitialEvent>(_onInit);
    on<OnLoadMoreDataEvent>(_onLoadMore);
    on<OnListRenderEvent>(_onListRender);
    on<OnListSideEffectEvent>(_onListSideEffect);
    on<OnItemTapEvent>(_onItemTap);
    on<OnMapTapEvent>(_onMapTap);
    on<OnIncidentFilterReceivedEvent>(_onIncidentFilterReceived);
    on<RepeatEvent>(onRepeatEvent);
    on<OnQueryChangeEvent>(
      _onQueryChanged,
      transformer: debounceTransformer(Duration(milliseconds: 300)),
    );

    add(OnInitialEvent());

    listViewHandler.render = (state) => _onRenderEvent(state);
    _listSubscription = listViewHandler.listen(_onSideListHandlerEffect);
  }

  void loadMore() => listViewHandler.proceed(LoadMoreEvent());

  Future<void> _onInit(OnInitialEvent event, Emitter emit) async {
    await processUseCaseRepeatable(
      () => getInitialIncidentsUseCase(EmptyUsecaseParams()),
      onSuccess: (result) {
        if (result.isNotEmpty) {
          final items = _mapIncidents(result);
          listViewHandler.proceed(NewPageEvent(items));
        } else {
          listViewHandler.proceed(NewPageEvent(<IncidentListPresentationModel>[], false));
        }
      },
    );
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
    final previousFilter = _incidentFilter;
    _incidentFilter = event.filter;
    if (previousFilter != null) {
      addNews(ShowQueryNews(event.filter?.query ?? ""));
      listViewHandler.proceed(StartEvent());
    }
  }

  void _onSideListHandlerEffect(SideEffectEvent event) {
    add(OnListSideEffectEvent(event));
  }

  void _onRenderEvent(ListViewHandlerState state) {
    add(OnListRenderEvent(state));
  }

  void _onListRender(OnListRenderEvent event, Emitter<IncidentsListState> emit) {
    emit(IncidentsDataState(event.state));
  }

  Future<void> _onListSideEffect(
    OnListSideEffectEvent event,
    Emitter<IncidentsListState> emit,
  ) async {
    final effect = event.sideEffect;
    switch (effect) {
      case LoadPage():
        await _loadMore(emit, effect.page);
      case ErrorEvent():
        return;
    }
  }

  Future<void> _loadMore(Emitter<IncidentsListState> emit, int page) async {
    await processUseCaseRepeatable(
      () => getIncidentsUseCase(GetIncidentUseCaseParams(page: page, filter: _incidentFilter)),
      onSuccess: (result) {
        final items = _mapIncidents(result);
        listViewHandler.proceed(NewPageEvent(items, items.isNotEmpty));
      },
      onError: (error) async {
        handleUseCaseError(error);
        listViewHandler.proceed(NewPageEvent<IncidentListPresentationModel>([], false));
      },
    );
  }

  Future<void> _onLoadMore(OnLoadMoreDataEvent event, Emitter emit) async {
    listViewHandler.proceed(LoadMoreEvent());
  }

  void _onMapTap(OnMapTapEvent event, Emitter emit) {
    navigator.navigateToMap();
  }

  Future<void> _onQueryChanged(OnQueryChangeEvent event, Emitter emit) async {
    final incomeQuery = event.query.trim().isEmpty ? null : event.query;

    applyIncidentFilterUseCase(IncidentFilterEntity(query: incomeQuery));
  }

  List<IncidentListPresentationModel> _mapIncidents(List<IncidentEntity> incidents) {
    final List<IncidentListPresentationModel> models = [];
    for (final incident in incidents) {
      final dateModel = _mapDate(incident);
      if (dateModel != null) {
        models.add(dateModel);
      }
      _lastLoadedIncident = incident;
      final model = _mapModel(incident);
      models.add(model);
    }

    return models;
  }

  IncidentListPresentationModel? _mapDate(IncidentEntity incident) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    final d = incident.updatedDate;
    final day = DateTime(d.year, d.month, d.day);
    final DateTime? lastIncidentDate;

    final lastIncident = _lastLoadedIncident;
    if (lastIncident != null) {
      lastIncidentDate = DateTime(
        lastIncident.updatedDate.year,
        lastIncident.updatedDate.month,
        lastIncident.updatedDate.day,
      );
    } else {
      lastIncidentDate = null;
    }

    final isNewDay = lastIncidentDate == null || !_isSameDay(day, lastIncidentDate);

    if (isNewDay) {
      if (_isSameDay(day, today)) {
        return TodayPresentationModel();
      } else if (_isSameDay(day, yesterday)) {
        return YesterdayPresentationModel();
      } else {
        return DatePresentationModel(date: DateFormat(_dateFormat).format(day));
      }
    } else {
      return null;
    }
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  IncidentPresentationModel _mapModel(IncidentEntity incident) => IncidentPresentationModel(
    id: incident.id,
    shipment: incident.shipmentReference ?? incident.shipmentId,
    description: incident.description,
    positionDate: DateFormat(_incidentDateFormat).format(incident.position.time).toLowerCase(),
    positionTitle: incident.position.title,
    row: incident,
  );

  void _onItemTap(OnItemTapEvent event, Emitter emit) {
    navigator.navigateToDetails(event.item.row);
  }

  @override
  Future<void> close() {
    _listSubscription?.cancel();
    _filterSubscription?.cancel();
    return super.close();
  }

  @override
  void onRepeat() {
    add(RepeatEvent());
  }
}
