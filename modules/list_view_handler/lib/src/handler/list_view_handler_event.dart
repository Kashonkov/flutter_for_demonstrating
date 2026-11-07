part of 'list_view_handler.dart';

sealed class ListViewHandlerEvent {}

/// Начать загрузку новой страницы
class LoadMoreEvent extends ListViewHandlerEvent {}

/// Перезагрузка последней страницы (Произошла ошибка)
class RetryEvent extends ListViewHandlerEvent {}

/// Первая загрузка данных
class StartEvent extends ListViewHandlerEvent {}

///  Полная перезагрузка данных (Pull-To-Refresh)
class RestartEvent extends ListViewHandlerEvent {}

/// Ошибка во время загрузки
class PageErrorEvent extends ListViewHandlerEvent {
  final ListViewHandlerException exception;

  PageErrorEvent(this.exception);
}

/// Загрузка данных новой страницы завершена
/// [items] - список
///
/// [allowMore] - флаг указывающий что можно дозагружать еще
class NewPageEvent<T> extends ListViewHandlerEvent {
  final List<T> items;
  final bool allowMore;

  NewPageEvent(this.items, [this.allowMore = true]);
}

///  Класс который эммитит эвенты которые будут слушаться в потребителе (consumer)
sealed class SideEffectEvent {}

/// Эвент загрузки первой/новой страницы
/// TODO - сделать логику отправки оффсета и последнего индекса
class LoadPage extends SideEffectEvent {
  final int page;

  LoadPage(this.page);
}

/// Эвент сообщающий что есть ошибка загрузки
class ErrorEvent extends SideEffectEvent {
  final ListViewHandlerException exception;

  ErrorEvent(this.exception);
}
