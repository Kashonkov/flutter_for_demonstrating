import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:list_view_handler/list_view_handler.dart';
import 'package:list_view_handler/src/custom_clamping_scroll_physics.dart';

const _pullToRefreshScrollAnimationDuration = Duration(milliseconds: 500);

typedef SliverBuilder = Widget? Function(BuildContext context, ListViewHandlerState state);

enum BodySliverType {
  list,
  grid,
  // вручную разбиваем список на виджетов в столбик со строкой из 2 карточек с дивайдером под строкой
  customGridWithDivider,
}

/// Виджет для отображения списка с пагинацией
class ListViewHandlerBuilder<T> extends StatefulWidget {
  /// делегат для отображения состояний списка
  final ListViewHandlerBuilderDelegate<T> builderDelegate;

  /// Часть скролла, при котором будет вызвано событие [LoadMoreEvent]
  /// По умолчанию `0.8`
  ///
  /// Для того чтобы выключить подгрузку при скролле, установите значение `null`
  final double? tolerance;

  /// Флаг, отвечающий за то что скролл главный на экране
  /// см. док-цию для [CustomScrollView]
  final bool primary;

  /// Любой виджет который необходимо отобразить выше списка - например AppBar
  final SliverBuilder? sliverBuilder;

  /// Любой виджет который необходимо отобразить между [sliverBuilder] и [builderDelegate]
  /// Например какой-нибудь рекламный баннер
  final SliverBuilder? bannerSliverBuilder;

  final bool pullToRefreshEnabled;

  final ScrollController? scrollController;

  /// Кастомное поведение скролла
  final ScrollPhysics? physics;

  /// Кастомные паддинги
  final EdgeInsets? padding;

  /// Стейт хендлера, который отвечает за разные состояния списков
  final ListViewHandlerState state;

  /// Делегат, который вызовится в случае например нажатия кнопки дозагрузки страницы
  /// на которой произошла ошибка
  final VoidCallback? retryDelegate;

  /// Делагат который вызовится в случае например Pull-to-refresh
  final VoidCallback? restartDelegate;

  /// Делагат который вызовется в лучае дозагрузки новой страницы в списке - пагинация
  final VoidCallback? loadMoreDelegate;

  /// Определяет будет отображаться контент списком или гридом.
  /// если type = [BodySliverType.grid], необходимо передать [sliverGridDelegate].
  final BodySliverType type;

  final SliverGridDelegate? sliverGridDelegate;

  /// оформление только для секции списка
  final BoxDecoration? listSectionDecoration;

  /// паддинги только для секции списка
  final EdgeInsets? listSectionInnerPadding;

  factory ListViewHandlerBuilder({
    Key? key,
    required ListViewHandlerBuilderDelegate<T> builderDelegate,
    required ListViewHandlerState state,
    VoidCallback? retryDelegate,
    VoidCallback? restartDelegate,
    VoidCallback? loadMoreDelegate,
    double tolerance = 0.8,
    bool primary = true,
    SliverBuilder? sliverBuilder,
    SliverBuilder? bannerSliverBuilder,
    bool pullToRefreshEnabled = true,
    ScrollController? scrollController,
    ScrollPhysics? physics,
    EdgeInsets? padding,
    BoxDecoration? listSectionDecoration,
    EdgeInsets? listSectionInnerPadding,
  }) {
    return ListViewHandlerBuilder._(
      key: key,
      builderDelegate: builderDelegate,
      state: state,
      type: BodySliverType.list,
      retryDelegate: retryDelegate,
      restartDelegate: restartDelegate,
      loadMoreDelegate: loadMoreDelegate,
      tolerance: tolerance,
      primary: primary,
      sliverBuilder: sliverBuilder,
      bannerSliverBuilder: bannerSliverBuilder,
      pullToRefreshEnabled: pullToRefreshEnabled,
      scrollController: scrollController,
      physics: physics,
      padding: padding,
      listSectionInnerPadding: listSectionInnerPadding,
      listSectionDecoration: listSectionDecoration,
    );
  }

  factory ListViewHandlerBuilder.customGridWithDivider({
    Key? key,
    required ListViewHandlerBuilderDelegate<T> builderDelegate,
    required ListViewHandlerState state,
    VoidCallback? retryDelegate,
    VoidCallback? restartDelegate,
    VoidCallback? loadMoreDelegate,
    double tolerance = 0.8,
    bool primary = true,
    SliverBuilder? sliverBuilder,
    SliverBuilder? bannerSliverBuilder,
    bool pullToRefreshEnabled = true,
    ScrollController? scrollController,
    ScrollPhysics? physics,
    EdgeInsets? padding,
    BoxDecoration? listSectionDecoration,
    EdgeInsets? listSectionInnerPadding,
  }) {
    return ListViewHandlerBuilder._(
      key: key,
      builderDelegate: builderDelegate,
      state: state,
      type: BodySliverType.customGridWithDivider,
      retryDelegate: retryDelegate,
      restartDelegate: restartDelegate,
      loadMoreDelegate: loadMoreDelegate,
      tolerance: tolerance,
      primary: primary,
      sliverBuilder: sliverBuilder,
      bannerSliverBuilder: bannerSliverBuilder,
      pullToRefreshEnabled: pullToRefreshEnabled,
      scrollController: scrollController,
      physics: physics,
      padding: padding,
      listSectionInnerPadding: listSectionInnerPadding,
      listSectionDecoration: listSectionDecoration,
    );
  }

  factory ListViewHandlerBuilder.grid({
    Key? key,
    required ListViewHandlerBuilderDelegate<T> builderDelegate,
    required ListViewHandlerState state,
    required SliverGridDelegate sliverGridDelegate,
    VoidCallback? retryDelegate,
    VoidCallback? restartDelegate,
    VoidCallback? loadMoreDelegate,
    double tolerance = 0.8,
    bool primary = true,
    SliverBuilder? sliverBuilder,
    SliverBuilder? bannerSliverBuilder,
    bool pullToRefreshEnabled = true,
    ScrollController? scrollController,
    ScrollPhysics? physics,
    EdgeInsets? padding,
    BoxDecoration? listSectionDecoration,
    EdgeInsets? listSectionInnerPadding,
  }) {
    return ListViewHandlerBuilder._(
      key: key,
      builderDelegate: builderDelegate,
      state: state,
      type: BodySliverType.grid,
      retryDelegate: retryDelegate,
      restartDelegate: restartDelegate,
      loadMoreDelegate: loadMoreDelegate,
      tolerance: tolerance,
      primary: primary,
      sliverBuilder: sliverBuilder,
      bannerSliverBuilder: bannerSliverBuilder,
      pullToRefreshEnabled: pullToRefreshEnabled,
      scrollController: scrollController,
      physics: physics,
      padding: padding,
      sliverGridDelegate: sliverGridDelegate,
      listSectionInnerPadding: listSectionInnerPadding,
      listSectionDecoration: listSectionDecoration,
    );
  }

  const ListViewHandlerBuilder._({
    super.key,
    required this.builderDelegate,
    required this.state,
    required this.type,
    this.retryDelegate,
    this.restartDelegate,
    this.loadMoreDelegate,
    this.tolerance = 0.8,
    this.primary = true,
    this.sliverBuilder,
    this.bannerSliverBuilder,
    this.pullToRefreshEnabled = true,
    this.scrollController,
    this.physics,
    this.padding,
    this.sliverGridDelegate,
    this.listSectionDecoration,
    this.listSectionInnerPadding,
  });

  @override
  State<ListViewHandlerBuilder<T>> createState() => _ListViewHandlerBuilderState<T>();
}

class _ListViewHandlerBuilderState<T> extends State<ListViewHandlerBuilder<T>> {
  final additionalStatuses = [NewPageError, NewPageProgress<T>, Refresh<T>, NewPageError<T>];
  ScrollController? _controller;
  bool _hasRequestedPage = false;

  @override
  void dispose() {
    if (!widget.primary) {
      _controller?.removeListener(_controllerListener);
    }
    if (widget.primary) {
      _controller?.dispose();
    }
    if (widget.scrollController != null) {
      widget.scrollController?.removeListener(_controllerListener);
    }
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final oldController = _controller;
    _controller = widget.primary ? widget.scrollController ?? ScrollController() : PrimaryScrollController.of(context);
    if (!identical(oldController, _controller)) {
      oldController?.removeListener(_controllerListener);
    }
    if (widget.tolerance != null) {
      _controller?.addListener(_controllerListener);
      if (widget.scrollController != null) {
        widget.scrollController?.addListener(_controllerListener);
      }
    }
  }

  @override
  void didUpdateWidget(covariant ListViewHandlerBuilder<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.state is Data<T>) {
      _hasRequestedPage = false;
    }
    if (widget.state is EmptyProgress && widget.primary) {
      _controller?.animateTo(0, duration: _pullToRefreshScrollAnimationDuration, curve: Curves.easeInOut);
    }
  }

  void _controllerListener() {
    ScrollController? controller = _controller;
    if (widget.scrollController != null) {
      controller = widget.scrollController;
    }
    final tolerance = widget.tolerance ?? 1;

    if (controller == null) {
      return;
    }

    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    final activity = _controller?.position.activity;
    final ttl = activity == null
        ? double.infinity
        : (controller.position.maxScrollExtent - controller.offset) / activity.velocity.abs();
    final scrollDirection = controller.position.userScrollDirection == ScrollDirection.reverse;

    if ((ttl < 0.3 && controller.position.extentAfter > 0) ||
        (controller.offset > controller.position.maxScrollExtent * tolerance) &&
            !_hasRequestedPage &&
            scrollDirection) {
      _hasRequestedPage = true;
      widget.loadMoreDelegate?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    // final colors = Theme.of(context).extension<UiColors>().checkColorsTheme();
    final state = widget.state;

    return CustomScrollView(
      shrinkWrap: true,
      physics: widget.physics ??
          (state is EmptyProgress
              ? const NeverScrollableScrollPhysics()
              : widget.pullToRefreshEnabled
                  ? const CustomClampingScrollPhysics(canOverScroll: true, canUnderScroll: true)
                  : null),
      controller: widget.primary ? _controller : null,
      slivers: [
        if (widget.sliverBuilder != null) widget.sliverBuilder?.call(context, state) ?? const SliverToBoxAdapter(),
        if (widget.pullToRefreshEnabled)
          CupertinoSliverRefreshControl(
            refreshTriggerPullDistance: 150,
            onRefresh: () async => widget.restartDelegate?.call(),
            builder: (context, refreshState, pulledExtent, refreshTriggerPullDistance, refreshIndicatorExtent) {
              return Container(
                alignment: Alignment.center,
                height: pulledExtent,
                color: Colors.grey,
                child: const CircularProgressIndicator(),
              );
            },
          ),
        if (widget.bannerSliverBuilder != null)
          widget.bannerSliverBuilder?.call(context, state) ?? const SliverToBoxAdapter(),
        SliverPadding(
          padding: widget.padding ?? EdgeInsets.zero,
          sliver: DecoratedSliver(
            decoration: widget.listSectionDecoration ?? const BoxDecoration(),
            sliver: SliverPadding(
              padding: state is EmptyError ? EdgeInsets.zero : widget.listSectionInnerPadding ?? EdgeInsets.zero,
              sliver: switch (state) {
                EmptyError() => widget.builderDelegate.emptyErrorIndicatorBuilder(context, state.exception, _retry),
                EmptyState() => widget.builderDelegate.emptyStateIndicatorBuilder(context),
                EmptyProgress() => widget.builderDelegate.emptyProgressIndicatorBuilder(context),
                DataState<T>() => _buildData(state),
                _ => const SliverPadding(padding: EdgeInsets.zero)
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildData(DataState<T> state) {
    return switch (widget.type) {
      BodySliverType.list => SliverList(delegate: _buildSliverChild(state)),
      BodySliverType.customGridWithDivider => _customGridWithDividerBuild(state),
      BodySliverType.grid => SliverGrid(delegate: _buildSliverChild(state), gridDelegate: widget.sliverGridDelegate!),
    };
  }

  // Общий лист виджетов
  List<Widget> list = [];

  // строка из двух карточек
  List<Widget> listRow = [];

  // Добавление сформированной строки в общий лист виджетов
  void addRow(bool hasDivider) {
    list.add(Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: listRow,
    ));
    if (hasDivider) list.add(Divider(height: 16 * 2, color: Colors.grey));
    listRow = [];
  }

  // вручную разбиваем список на виджетов в столбик со строкой из 2 карточек с дивайдером под строкой
  Widget _customGridWithDividerBuild(DataState<T> state) {
    list = [];
    listRow = [];
    final itemCount = state.data.length;
    for (int index = 0; index < itemCount; index++) {
      if (index.isEven && index > 1) addRow(true);

      listRow.add(widget.builderDelegate.itemBuilder(context, state.data[index], index));

      if (index == itemCount - 1) addRow(false);
    }

    return SliverToBoxAdapter(
      child: Column(children: [
        ...list,
        if (state is NewPageProgress<T> || state is Refresh<T>)
          widget.builderDelegate.newPageProgressIndicatorBuilder(context),
        if (state is NewPageError<T>)
          widget.builderDelegate.newPageErrorIndicatorBuilder(context, state.exception, _retry),
      ]),
    );
  }

  SliverChildBuilderDelegate _buildSliverChild(DataState<T> state) {
    return SliverChildBuilderDelegate((context, index) {
      if (index == state.data.length) {
        return switch (state) {
          NewPageProgress<T>() || Refresh<T>() => widget.builderDelegate.newPageProgressIndicatorBuilder(context),
          NewPageError<T>() => widget.builderDelegate.newPageErrorIndicatorBuilder(context, state.exception, _retry),
          FullData<T>() => widget.builderDelegate.fullDataIndicatorBuilder(context),
          _ => const SizedBox.shrink()
        };
      }
      return widget.builderDelegate.itemBuilder(context, state.data[index], index);
    }, childCount: getItemCount(state));
  }

  int getItemCount(DataState state) {
    return state.data.length + (additionalStatuses.contains(state.runtimeType) ? 1 : 0);
  }

  void _retry() => widget.retryDelegate?.call();
}
