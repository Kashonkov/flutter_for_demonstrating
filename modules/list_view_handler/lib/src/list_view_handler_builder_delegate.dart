import 'package:flutter/material.dart';
import 'package:list_view_handler/list_view_handler.dart';
import 'package:ui_kit/index.dart';

typedef ItemWidgetBuilder<ItemType> = Widget Function(BuildContext context, ItemType item, int index);

/// {@template pagination.errorDelegate}
/// Отрисовка состояний ошибки
///
/// [ErrorType] - [ListViewHandlerException]
/// {@endtemplate}
typedef ErrorWidgetBuilder<ErrorType> = Widget Function(BuildContext context, ErrorType error, void Function() retry);

/// Делегат отображения состояний списков
class ListViewHandlerBuilderDelegate<T> {
  ListViewHandlerBuilderDelegate({
    required this.itemBuilder,
    this.emptyErrorIndicatorBuilder = _fallbackSliverErrorBuilder,
    this.newPageErrorIndicatorBuilder = _fallbackErrorBuilder,
    this.emptyProgressIndicatorBuilder = _fallbackSliverBuilder,
    this.newPageProgressIndicatorBuilder = _fallbackBuilder,
    this.emptyStateIndicatorBuilder = _fallbackSliverBuilder,
    this.fullDataIndicatorBuilder = _fallbackBuilder,
  });

  /// Билдер элементов списка
  final ItemWidgetBuilder<T> itemBuilder;

  /// Индикатор ошибки при первой загрузке
  ///
  /// {@macro pagination.errorDelegate}
  final ErrorWidgetBuilder<ListViewHandlerException> emptyErrorIndicatorBuilder;

  /// Индикатор ошибки при загрузке новой страницы
  ///
  /// {@macro pagination.errorDelegate}
  final ErrorWidgetBuilder<ListViewHandlerException> newPageErrorIndicatorBuilder;

  /// Индикатор первой загрузки
  final WidgetBuilder emptyProgressIndicatorBuilder;

  /// Индикатор загрузки новой страницы
  final WidgetBuilder newPageProgressIndicatorBuilder;

  /// Индикатор пустого списка после первой загрузки
  final WidgetBuilder emptyStateIndicatorBuilder;

  /// Индикатор конца списка
  final WidgetBuilder fullDataIndicatorBuilder;

  static Widget _fallbackBuilder(context) => const SizedBox.shrink();

  static Widget _fallbackErrorBuilder(context, _, __) => const SizedBox();

  static Widget _fallbackSliverBuilder(context) => const SliverGap(0);

  static Widget _fallbackSliverErrorBuilder(context, _, __) => const SliverGap(0);
}
