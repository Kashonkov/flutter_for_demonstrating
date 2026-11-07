import 'dart:async';

import 'package:common/bloc/base_bloc.dart';
import 'package:common/usecase/usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shipment/domain/entity/shipment_filter_entity.dart';
import 'package:shipment/domain/entity/shipment_item_entity.dart';
import 'package:shipment/domain/use_case/apply_shipment_filter_use_case.dart';
import 'package:shipment/domain/use_case/get_a%D1%81tive_shipments_use_case.dart';
import 'package:shipment/domain/use_case/get_filter_shipment_stream_use_case.dart';
import 'package:shipment/navigation/shipment_navigator.dart';
import 'package:shipment/presentation/presentation/shipment_item_model.dart';
import 'package:shipment/presentation/shipment_bus/shipment_bus.dart';
import 'package:shipment/presentation/shipment_filter_bottom_sheet/model/shipment_filter.dart';
import 'package:shipment/presentation/shipments_map/bloc/shipments_map_event.dart';
import 'package:shipment/presentation/shipments_map/bloc/shipments_map_news.dart';
import 'package:shipment/presentation/shipments_map/bloc/shipments_map_state.dart';

const _dateFormat = 'MM/dd/yy hh:mma';

final class ShipmentsMapBloc extends BaseBloc<ShipmentsMapEvent, ShipmentsMapState> {
  final GetActiveShipmentsUseCase getShipmentsUseCase;
  final ApplyShipmentFilterUseCase applyShipmentFilterUseCase;
  final GetFilterShipmentStreamUseCase getFilterShipmentStreamUseCase;
  final ShipmentNavigator navigator;
  final ShipmentBusController controller;

  List<ShipmentItemEntity> _shipments = [];
  StreamSubscription? _filterSubscription;
  StreamSubscription? _busSubscription;
  ShipmentFilterEntity? _shipmentFilter;

  ShipmentsMapBloc({
    required this.getShipmentsUseCase,
    required this.navigator,
    required this.applyShipmentFilterUseCase,
    required this.getFilterShipmentStreamUseCase,
    required this.controller,
  }) : super(IdleState()) {
    on<OnInitEvent>(_onInit);
    on<OnShipmentSelectEvent>(_onShipmentSelect);
    on<OnShipmentTapEvent>(_onShipmentTap);
    on<OnFiltersTapEvent>(_onFiltersTap);
    on<OnFilterSelectedEvent>(_onFiltersSelected);
    on<OnShipmentFilterReceivedEvent>(_onShipmentFilterReceived);
    on<OnShipmentUpdateEvent>(_onShipmentUpdate);
    on<OnQueryChangeEvent>(
      _onQueryChanged,
      transformer: debounceTransformer(Duration(milliseconds: 300)),
    );

    add(OnInitEvent());
  }

  void _onInit(OnInitEvent event, Emitter emit) {
    processSyncUseCase(
      getFilterShipmentStreamUseCase(EmptyUsecaseParams()),
      onSuccess: _processFilterStream,
    );
    _busSubscription = controller.getStream().listen(_onBusEventReceived);
  }

  void _processFilterStream(Stream<ShipmentFilterEntity?> stream) {
    _filterSubscription = stream.listen((filter) {
      add(OnShipmentFilterReceivedEvent(filter));
    });
  }

  void _onBusEventReceived(ShipmentBusEvent event) {
    switch (event) {
      case ShipmentCompletedEvent():
        add(OnShipmentUpdateEvent(event.shipmentId));
    }
  }

  Future<void> _onShipmentUpdate(OnShipmentUpdateEvent event, Emitter emit) async {
    return _getShipments(emit);
  }

  Future<void> _onShipmentFilterReceived(OnShipmentFilterReceivedEvent event, Emitter emit) async {
    _shipmentFilter = event.filter;
    addNews(ShowQueryNews(event.filter?.query ?? ""));
    return _getShipments(emit);
  }

  Future<void> _getShipments(Emitter emit) async {
    await processUseCase(
      () => getShipmentsUseCase(_shipmentFilter),
      onSuccess: (shipments) {
        _shipments = shipments;
        emit(DataState(shipments: shipments));
      },
    );
  }

  void _onShipmentSelect(OnShipmentSelectEvent event, Emitter emit) {
    if (event.id == null) {
      emit(DataState(shipments: _shipments));
    } else {
      final shipment = _shipments.firstWhere((shipment) => shipment.id == event.id);
      emit(DataState(shipments: _shipments, selectedShipment: _map(shipment)));
    }
  }

  void _onShipmentTap(OnShipmentTapEvent event, Emitter emit) {
    navigator.navigateToDetails(event.id);
  }

  void _onQueryChanged(OnQueryChangeEvent event, Emitter emit) {
    final incomeQuery = event.query.trim().isEmpty ? null : event.query;

    applyShipmentFilterUseCase(
      ShipmentFilterEntity(
        query: incomeQuery,
        status: _shipmentFilter?.status,
        range: _shipmentFilter?.range,
      ),
    );
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
      ),
    );
  }

  ShipmentItemModel _map(ShipmentItemEntity shipment) => ShipmentItemModel(
    id: shipment.id,
    title: shipment.title,
    gpsStatus: shipment.gpsStatus,
    connectionStatus: shipment.connectionStatus,
    positionTime: DateFormat(_dateFormat).format(shipment.position.time),
    positionTitle: shipment.position.title,
    deliveryStatus: shipment.deliveryStatus,
    hasIncidents: shipment.incidentCount > 0,
  );

  @override
  Future<void> close() {
    _filterSubscription?.cancel();
    _busSubscription?.cancel();
    return super.close();
  }
}
