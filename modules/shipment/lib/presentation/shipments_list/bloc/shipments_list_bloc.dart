import 'dart:async';

import 'package:common/bloc/base_bloc.dart';
import 'package:common/bloc/repeatable_use_case_processor_bloc_mixin.dart';
import 'package:common/index.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:list_view_handler/list_view_handler.dart';
import 'package:shipment/domain/entity/delivery_status.dart';
import 'package:shipment/domain/entity/shipment_filter_entity.dart';
import 'package:shipment/domain/entity/shipment_item_entity.dart';
import 'package:shipment/domain/use_case/apply_shipment_filter_use_case.dart';
import 'package:shipment/domain/use_case/get_filter_shipment_stream_use_case.dart';
import 'package:shipment/domain/use_case/get_initial_shipments_use_case.dart';
import 'package:shipment/domain/use_case/get_shipments_use_case.dart';
import 'package:shipment/navigation/shipment_navigator.dart';
import 'package:shipment/presentation/presentation/shipment_item_model.dart';
import 'package:shipment/presentation/shipment_bus/shipment_bus.dart';
import 'package:shipment/presentation/shipment_filter_bottom_sheet/model/shipment_filter.dart';
import 'package:shipment/presentation/shipments_list/bloc/shipments_list_event.dart';
import 'package:shipment/presentation/shipments_list/bloc/shipments_list_news.dart';
import 'package:shipment/presentation/shipments_list/bloc/shipments_list_state.dart';
import 'package:shipment/presentation/shipments_list/model/shipment_presentation_model.dart';

const _dateFormat = 'MM/dd/yy hh:mma';

final class ShipmentsListBloc extends BaseBloc<ShipmentsListEvent, ShipmentsListState> with RepeatableUseCaseProcessorBlocMixin{
  final GetInitialShipmentsUseCase getInitialShipmentsUseCase;
  final GetShipmentsUseCase getShipmentsUseCase;
  final ApplyShipmentFilterUseCase applyShipmentFilterUseCase;
  final GetFilterShipmentStreamUseCase getFilterShipmentStreamUseCase;
  final ShipmentBusController busController;

  final ShipmentNavigator navigator;
  final ListViewHandler<ShipmentItemPresentationModel> listViewHandler;

  StreamSubscription? _listSubscription;
  StreamSubscription? _filterSubscription;
  StreamSubscription? _busSubscription;
  ShipmentFilterEntity? _shipmentFilter;
  DeliveryStatus _deliveryStatus = DeliveryStatus.transit;

  ShipmentItemEntity? _lastLoadedShipment;

  ShipmentsListBloc({
    required this.getInitialShipmentsUseCase,
    required this.getShipmentsUseCase,
    required this.applyShipmentFilterUseCase,
    required this.getFilterShipmentStreamUseCase,
    required this.listViewHandler,
    required this.busController,
    required this.navigator,
  }) : super(LoadingState()) {
    on<OnInitialEvent>(_onInit);
    on<OnLoadMoreDataEvent>(_onLoadMore);
    on<OnListRenderEvent>(_onListRender);
    on<OnListSideEffectEvent>(_onListSideEffect);
    on<OnItemTapEvent>(_onItemTap);
    on<OnFiltersTapEvent>(_onFiltersTap);
    on<OnFilterSelectedEvent>(_onFiltersSelected);
    on<OnShipmentFilterReceivedEvent>(_onShipmentFilterReceived);
    on<OnMapTapEvent>(_onMapTap);
    on<OnShipmentUpdateEvent>(_onShipmentUpdated);
    on<RepeatEvent>(onRepeatEvent);
    on<OnChangeDeliveryStatus>(_onChangeDeliveryStatusChanged);
    on<OnQueryChangeEvent>(
      _onQueryChanged,
      transformer: debounceTransformer(Duration(milliseconds: 300)),
    );

    add(OnInitialEvent());

    listViewHandler.render = (state) => _onRenderEvent(state);
    _listSubscription = listViewHandler.listen(_onSideListHandlerEffect);
    _busSubscription = busController.getStream().listen(_onBusEventReceived);
  }

  void loadMore() => listViewHandler.proceed(LoadMoreEvent());

  Future<void> _onInit(OnInitialEvent event, Emitter emit) async {
    await processUseCase(
      () => getInitialShipmentsUseCase(EmptyUsecaseParams()),
      onSuccess: (result) {
        if (result.isNotEmpty) {
          final items = _mapShipments(result);
          listViewHandler.proceed(NewPageEvent<ShipmentItemPresentationModel>(items));
        } else {
          listViewHandler.proceed(NewPageEvent<ShipmentItemPresentationModel>([], false));
        }
      },
    );
    processSyncUseCase(
      getFilterShipmentStreamUseCase(EmptyUsecaseParams()),
      onSuccess: _processFilterStream,
    );
  }

  void _processFilterStream(Stream<ShipmentFilterEntity?> stream) {
    _filterSubscription = stream.listen((filter) {
      add(OnShipmentFilterReceivedEvent(filter));
    });
  }

  Future<void> _onShipmentFilterReceived(OnShipmentFilterReceivedEvent event, Emitter emit) async {
    final previousFilter = _shipmentFilter;
    _shipmentFilter = event.filter;
    if(previousFilter != null) {
      addNews(ShowQueryNews(event.filter?.query ?? ""));
      listViewHandler.proceed(StartEvent());
    }
  }

  void _onFiltersTap(OnFiltersTapEvent event, Emitter emit) {
    addNews(
      ShowFilterDialogNews(
        ShipmentBottomFilters(status: _shipmentFilter?.status, range: _shipmentFilter?.range),
      ),
    );
  }

  void _onFiltersSelected(OnFilterSelectedEvent event, Emitter emit) {
    applyShipmentFilterUseCase(
      ShipmentFilterEntity(
        query: _shipmentFilter?.query,
        status: event.filter.status,
        range: event.filter.range,
        deliveryStatuses: _shipmentFilter?.deliveryStatuses,
      ),
    );
  }

  void _onSideListHandlerEffect(SideEffectEvent event) {
    add(OnListSideEffectEvent(event));
  }


  void _onBusEventReceived(ShipmentBusEvent event) {
    switch(event){
      case ShipmentCompletedEvent():
        add(OnShipmentUpdateEvent());
    }
  }

  void _onRenderEvent(ListViewHandlerState state) {
    add(OnListRenderEvent(state));
  }

  void _onListRender(OnListRenderEvent event, Emitter<ShipmentsListState> emit) {
    emit(ShipmentsDataState(event.state, _deliveryStatus, _deliveryStatus == DeliveryStatus.transit));
  }

  Future<void> _onListSideEffect(
    OnListSideEffectEvent event,
    Emitter<ShipmentsListState> emit,
  ) async {
    final effect = event.sideEffect;
    switch (effect) {
      case LoadPage():
        await _loadMore(emit, effect.page);
      case ErrorEvent():
        return;
    }
  }

  Future<void> _loadMore(Emitter<ShipmentsListState> emit, int page) async {
    final filter = _shipmentFilter;
    await processUseCase(
      () => getShipmentsUseCase(GetShipmentsUseCaseParams(page: page, filter: filter)),
      onSuccess: (result) {
        if(filter != _shipmentFilter) return;
        final items = _mapShipments(result);
        listViewHandler.proceed(
          NewPageEvent<ShipmentItemPresentationModel>(items, items.isNotEmpty),
        );
      },
      onError: (error) {
        handleUseCaseError(error);
        listViewHandler.proceed(NewPageEvent<ShipmentItemPresentationModel>([], false));
      },
    );
  }

  Future<void> _onLoadMore(OnLoadMoreDataEvent event, Emitter emit) async {
    listViewHandler.proceed(LoadMoreEvent());
  }

  Future<void> _onQueryChanged(OnQueryChangeEvent event, Emitter emit) async {
    final incomeQuery = event.query.trim().isEmpty ? null : event.query;

    applyShipmentFilterUseCase(
      ShipmentFilterEntity(
        query: incomeQuery,
        status: _shipmentFilter?.status,
        range: _shipmentFilter?.range,
        deliveryStatuses: _shipmentFilter?.deliveryStatuses,
      ),
    );
  }

  Future<void> _onChangeDeliveryStatusChanged(OnChangeDeliveryStatus event, Emitter emit) async {
    _deliveryStatus = event.status;
    emit(ShipmentsDataState(listViewHandler.state, _deliveryStatus, _deliveryStatus == DeliveryStatus.transit));

    applyShipmentFilterUseCase(
      ShipmentFilterEntity(
        query: _shipmentFilter?.query,
        status: _shipmentFilter?.status,
        range: _shipmentFilter?.range,
        deliveryStatuses: [_deliveryStatus],
      ),
    );
  }

  Future<void> _onShipmentUpdated(OnShipmentUpdateEvent event, Emitter emit) async {
    listViewHandler.proceed(RestartEvent());
  }

  List<ShipmentItemPresentationModel> _mapShipments(List<ShipmentItemEntity> shipments) {
    final List<ShipmentItemPresentationModel> models = [];
    for (final shipment in shipments) {
      // final dateModel = _mapDate(shipment);
      // if (dateModel != null) {
      //   models.add(dateModel);
      // }
      _lastLoadedShipment = shipment;
      final model = _mapModel(shipment);
      models.add(model);
    }

    return models;
  }

  ShipmentPresentationModel _mapModel(ShipmentItemEntity shipment) {
    return ShipmentPresentationModel(
      model: ShipmentItemModel(
        id: shipment.id,
        title: shipment.title,
        gpsStatus: shipment.gpsStatus,
        connectionStatus: shipment.connectionStatus,
        positionTime: DateFormat(_dateFormat).format(shipment.position.time),
        positionTitle: shipment.position.title,
        deliveryStatus: shipment.deliveryStatus,
        hasIncidents: shipment.incidentCount > 0
      ),
    );
  }

  void _onItemTap(OnItemTapEvent event, Emitter emit) {
    navigator.navigateToDetails(event.item.model.id);
  }

  void _onMapTap(OnMapTapEvent event, Emitter emit) {
    navigator.navigateToMap();
  }

  ShipmentItemPresentationModel? _mapDate(ShipmentItemEntity shipment) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    final d = shipment.position.time;
    final day = DateTime(d.year, d.month, d.day);
    final DateTime? lastShipmentDate;

    final lastShipment = _lastLoadedShipment;
    if (lastShipment != null) {
      lastShipmentDate = DateTime(
        lastShipment.position.time.year,
        lastShipment.position.time.month,
        lastShipment.position.time.day,
      );
    } else {
      lastShipmentDate = null;
    }

    final isNewDay = lastShipmentDate == null || !_isSameDay(day, lastShipmentDate);

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

  @override
  Future<void> close() {
    _listSubscription?.cancel();
    _filterSubscription?.cancel();
    _busSubscription?.cancel();
    return super.close();
  }

  @override
  void onRepeat() {
    add(RepeatEvent());
  }
}
