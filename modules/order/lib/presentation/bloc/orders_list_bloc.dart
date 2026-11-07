import 'dart:async';

import 'package:common/bloc/base_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:list_view_handler/list_view_handler.dart';
import 'package:order/domain/entity/order_entity.dart';
import 'package:order/domain/use_case/get_orders_use_case.dart';
import 'package:order/presentation/bloc/orders_list_event.dart';
import 'package:order/presentation/bloc/orders_list_state.dart';
import 'package:order/presentation/model/order_presentation_model.dart';

const _dateFormat = 'MM/dd/yyyy';

final class OrdersListBloc extends BaseBloc<OrdersListEvent, OrdersListState> {
  final GetOrdersUseCase getOrdersUseCase;
  final ListViewHandler<OrderListPresentationModel> listViewHandler;

  StreamSubscription? _listSubscription;
  String? _query;
  int _page = 1;
  OrderEntity? _lastLoadedOrder;

  OrdersListBloc({required this.getOrdersUseCase, required this.listViewHandler})
    : super(LoadingState()) {
    on<OnInitialEvent>(_onInit);
    on<OnLoadMoreDataEvent>(_onLoadMore);
    on<OnListRenderEvent>(_onListRender);
    on<OnListSideEffectEvent>(_onListSideEffect);
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
    await processUseCase(
      () => getOrdersUseCase(GetOrdersUseCaseParams(page: _page, query: _query)),
      onSuccess: (result) {
        if (result.isNotEmpty) {
          final items = _mapOrders(result);
          listViewHandler.proceed(NewPageEvent(items));
        } else {
          listViewHandler.proceed(NewPageEvent<OrderListPresentationModel>([], false));
        }
      },
      onError: (error) {
        handleUseCaseError(error);
        listViewHandler.proceed(NewPageEvent<OrderListPresentationModel>([], false));
      },
    );
  }

  void _onSideListHandlerEffect(SideEffectEvent event) {
    add(OnListSideEffectEvent(event));
  }

  void _onRenderEvent(ListViewHandlerState state) {
    add(OnListRenderEvent(state));
  }

  void _onListRender(OnListRenderEvent event, Emitter<OrdersListState> emit) {
    emit(OrdersDataState(event.state));
  }

  Future<void> _onListSideEffect(OnListSideEffectEvent event, Emitter<OrdersListState> emit) async {
    final effect = event.sideEffect;
    switch (effect) {
      case LoadPage():
        await _loadMore(emit, effect.page);
      case ErrorEvent():
        return;
    }
  }

  Future<void> _loadMore(Emitter<OrdersListState> emit, int page) async {
    await processUseCase(
      () => getOrdersUseCase(GetOrdersUseCaseParams(page: page, query: _query)),
      onSuccess: (result) {
        final items = _mapOrders(result);
        listViewHandler.proceed(NewPageEvent(items, items.isNotEmpty));
      },
      onError: (error) {
        handleUseCaseError(error);
        listViewHandler.proceed(NewPageEvent<OrderListPresentationModel>([], false));
      },
    );
  }

  Future<void> _onLoadMore(OnLoadMoreDataEvent event, Emitter emit) async {
    listViewHandler.proceed(LoadMoreEvent());
  }

  Future<void> _onQueryChanged(OnQueryChangeEvent event, Emitter emit) async {
    final incomeQuery = event.query.isEmpty ? null : event.query;
    if (incomeQuery == _query) return;
    _query = incomeQuery;
    _page = 1;
    listViewHandler.proceed(StartEvent());
  }

  List<OrderListPresentationModel> _mapOrders(List<OrderEntity> orders) {
    final List<OrderListPresentationModel> models = [];
    for (final order in orders) {
      final dateModel = _mapDate(order);
      if (dateModel != null) {
        models.add(dateModel);
      }
      _lastLoadedOrder = order;
      final model = _mapModel(order);
      models.add(model);
    }

    return models;
  }

  OrderListPresentationModel? _mapDate(OrderEntity order) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    final d = order.orderDate;
    final day = DateTime(d.year, d.month, d.day);
    final DateTime? lastOrderDate;

    final lastOrder = _lastLoadedOrder;
    if (lastOrder != null) {
      lastOrderDate = DateTime(
        lastOrder.orderDate.year,
        lastOrder.orderDate.month,
        lastOrder.orderDate.day,
      );
    } else {
      lastOrderDate = null;
    }

    final isNewDay = lastOrderDate == null || !_isSameDay(day, lastOrderDate);

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

  OrderPresentationModel _mapModel(OrderEntity order) {
    return OrderPresentationModel(
      orderNumber: order.id,
      orderStatus: order.orderStatus,
      sealType: order.sealType,
      sealColor: order.sealColor,
      logo: order.logo,
      amount: order.amount,
    );
  }

  @override
  Future<void> close() {
    _listSubscription?.cancel();
    return super.close();
  }
}
