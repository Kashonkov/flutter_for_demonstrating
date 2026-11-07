import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:list_view_handler/list_view_handler.dart';

part 'list_view_handler_event.dart';
part 'list_view_handler_state.dart';

/// Основной класс для работы со списками
/// Реализует конечную машину состояний для обработки списков
///
/// Пример использования можно посмотреть в папке * [modules/list_view_handler/lib/src/example]:
/// * [GetListExampleCubit] - пример оформления кубита
/// * [GetListExampleState] - пример оформления стейта
/// * [ListViewHandlerPresenterExample] - пример оформления экрана
///
/// Для отрисовки состояний использовать метод [render]
///
/// Для отправки событий использовать метод [proceed]
///
/// События:
/// * [LoadMoreEvent] - Начать загрузку новой страницы
/// * [RetryEvent] - Перезагрузка последней страницы (Произошла ошибка)
/// * [StartEvent] - Первая загрузка данных
/// * [RestartEvent] - Полная перезагрузка данных (Pull-To-Refresh)
/// * [PageErrorEvent] - Ошибка во время загрузки
/// * [NewPageEvent] - Загрузка данных новой страницы завершена
///
/// Состояния:
/// * [EmptyState] - Пустой список после первой загрузки
/// * [EmptyProgress] - Первая загрузка в процессе
/// * [EmptyError] - Ошибка после первой загрузки
/// * [Data] - Есть элементы в списке
/// * [NewPageProgress] - Загрузка новой страницы
/// * [FullData] - Конец списка
/// * [NewPageError] - Ошибка при загрузке новой страницы
/// * [Refresh] - Перезагрузка последней страницы
///
class ListViewHandler<T> implements Disposable {
  ListViewHandlerState _state;

  ListViewHandlerState get state => _state;

  set state(ListViewHandlerState newState) {
    if (newState.runtimeType == state.runtimeType) {
      return;
    }
    _state = newState;
    render?.call(newState);
  }

  final StreamController<SideEffectEvent> _controller = StreamController.broadcast();

  /// Стрим который необходимо подключить в соответствующем стейт менеджере
  StreamSubscription<SideEffectEvent> listen(void Function(SideEffectEvent event) onData) =>
      _controller.stream.listen(onData);

  /// Метод, служащий тригером для перерендера/обновления списка в потребителе (consumer)
  /// Далее потребитель сам решает что делать с данным списком
  ValueSetter<ListViewHandlerState>? render;

  ListViewHandler() : _state = EmptyState();

  /// Метод преобразования стейта в зависимости от переданного эвента
  ListViewHandlerState reducer(ListViewHandlerEvent event) {
    return switch (event) {
      LoadMoreEvent() => _loadMoreReducer(),
      RetryEvent() => _retryReducer(),
      StartEvent() || RestartEvent() => _startReducer(),
      PageErrorEvent() => _pageErrorReducer(event),
      NewPageEvent() => _newPageReducer(event),
    };
  }

  void proceed(ListViewHandlerEvent event) {
    final newState = reducer(event);
    state = newState;
  }

  ListViewHandlerState _loadMoreReducer() {
    if (state is Data<T>) {
      final s = state as Data<T>;
      _controller.add(LoadPage(s.page + 1));
      return NewPageProgress<T>(s.data, s.page);
    }
    return state;
  }

  ListViewHandlerState _retryReducer() {
    if ([EmptyError, EmptyState].contains(state.runtimeType)) {
      _controller.add(LoadPage(1));
      return EmptyProgress();
    } else if ([NewPageProgress<T>, Data<T>, FullData<T>, NewPageError<T>]
        .contains(state.runtimeType)) {
      final s = state as DataState<T>;
      _controller.add(LoadPage(s.page + 1));
      return Refresh<T>(s.data, s.page + 1);
    }
    return state;
  }

  ListViewHandlerState _startReducer() {
    _controller.add(LoadPage(1));
    return EmptyProgress();
  }

  ListViewHandlerState _pageErrorReducer(PageErrorEvent event) {
    if (state is EmptyProgress) {
      return EmptyError(event.exception);
    } else if ([NewPageProgress<T>, Refresh<T>].contains(state.runtimeType)) {
      final s = state as DataState<T>;
      return NewPageError<T>(s.data, s.page, event.exception);
    }
    return state;
  }

  ListViewHandlerState _newPageReducer(ListViewHandlerEvent givenEvent) {
    final event = givenEvent as NewPageEvent<T>;
    final items = event.items;
    if (state is NewPageProgress<T>) {
      final s = state as NewPageProgress<T>;
      if (items.isEmpty) {
        return FullData<T>(s.data, s.page);
      } else {
        if (event.allowMore) {
          return Data<T>([...s.data, ...items], s.page + 1);
        } else {
          return FullData<T>(s.data, s.page);
        }
      }
    } else if ([EmptyProgress].contains(state.runtimeType)) {
      if (items.isEmpty) {
        return EmptyState();
      } else {
        if (event.allowMore) {
          return Data<T>(items, 1);
        } else {
          return FullData<T>(items, 1);
        }
      }
    } else if(state is EmptyState){
      if (items.isEmpty) {
        return FullData(items, 0);
      } else {
        return Data<T>(items, 0);
      }
    }else if (state is Refresh<T>) {
      final s = state as Refresh<T>;
      if (items.isEmpty) {
        return FullData(s.data, s.page);
      } else {
        return Data<T>([...s.data, ...items], s.page + 1);
      }
    }
    return state;
  }

  @override
  FutureOr onDispose() {
    _controller.close();
  }
}
