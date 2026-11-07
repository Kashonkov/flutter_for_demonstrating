part of 'list_view_handler.dart';

sealed class ListViewHandlerState {}

/// Первая загрузка
/// Пустой список после первой загрузки
class EmptyState extends ListViewHandlerState {}

/// Первая загрузка в процессе
class EmptyProgress extends ListViewHandlerState {}

/// Ошибка после первой загрузки
class EmptyError extends ListViewHandlerState {
  final ListViewHandlerException exception;

  EmptyError(this.exception);
}

/// Первый список
class DataState<T> extends ListViewHandlerState {
  final List<T> data;
  final int page;

  DataState(this.data, this.page);
}

/// Есть элементы в списке
///
/// [data] - элементы
class Data<T> extends DataState<T> {
  Data(super.data, super.page);
}

/// Состояние перезапуска стейта при Pull-to-refresh либо при перезагрузке после ошибки
class Refresh<T> extends DataState<T> {
  Refresh(super.data, super.page);
}

/// Загрузка новой страницы
class NewPageProgress<T> extends DataState<T> {
  NewPageProgress(super.data, super.page);
}

/// Конец списка
class FullData<T> extends DataState<T> {
  FullData(super.data, super.page);
}

/// Ошибка при загрузке новой страницы
class NewPageError<T> extends DataState<T> {
  final ListViewHandlerException exception;

  NewPageError(super.data, super.page, this.exception);
}
