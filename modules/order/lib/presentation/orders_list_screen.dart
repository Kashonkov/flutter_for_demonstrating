import 'package:common/bloc/bloc.dart';
import 'package:common/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:list_view_handler/list_view_handler.dart';
import 'package:order/domain/entity/order_status.dart';
import 'package:order/l10n/localization_extension.dart';
import 'package:order/presentation/bloc/orders_list_bloc.dart';
import 'package:order/presentation/bloc/orders_list_event.dart';
import 'package:order/presentation/bloc/orders_list_state.dart';
import 'package:order/presentation/model/order_presentation_model.dart';
import 'package:ui_kit/index.dart';
import 'package:ui_kit/l10n/localization_extension.dart';
import 'package:ui_kit/loading/list_loading_item.dart';

class OrdersListScreenContent extends StatefulWidget {
  const OrdersListScreenContent({super.key});

  @override
  State<OrdersListScreenContent> createState() => _OrdersListScreenContentState();
}

class _OrdersListScreenContentState extends StateWithBloc<OrdersListBloc, OrdersListScreenContent> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      bloc.add(OnQueryChangeEvent(_searchController.text));
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.loc.orders, style: context.rfTextTheme().largeTitle)),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: BlocBuilder<OrdersListBloc, OrdersListState>(
            builder: (context, state) {
              return switch (state) {
                LoadingState() => Center(child: CircularProgressIndicator()),
                OrdersDataState() => Column(
                  children: [
                    Gap(12),
                    SearchWidget(controller: _searchController, showTunes: false),
                    Gap(12),
                    Expanded(
                      child: ListViewHandlerBuilder<OrderListPresentationModel>(
                        state: state.listState,
                        pullToRefreshEnabled: false,
                        padding: const EdgeInsets.only(bottom: 16),
                        builderDelegate: ListViewHandlerBuilderDelegate<OrderListPresentationModel>(
                          itemBuilder: (context, item, index) {
                            return switch (item) {
                              TodayPresentationModel() => Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  context.commonLoc.today.toUpperCase(),
                                  style: context.rfTextTheme().body4,
                                ),
                              ),
                              YesterdayPresentationModel() => Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  context.commonLoc.yesterday.toUpperCase(),
                                  style: context.rfTextTheme().body4,
                                ),
                              ),
                              DatePresentationModel() => Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  item.date.toUpperCase(),
                                  style: context.rfTextTheme().body4,
                                ),
                              ),
                              OrderPresentationModel() => Padding(
                                padding: EdgeInsets.symmetric(vertical: 4),
                                child: _OrderItem(order: item),
                              ),
                            };
                          },
                          emptyProgressIndicatorBuilder: (context) =>
                              SliverToBoxAdapter(child: ListLoadingItem()),
                          newPageProgressIndicatorBuilder: (context) => ListLoadingItem(),
                        ),
                        // retryDelegate: bloc.retry,
                        // restartDelegate: bloc.restart,
                        loadMoreDelegate: () => bloc.add(OnLoadMoreDataEvent()),
                      ),
                    ),
                  ],
                ),
              };
            },
          ),
        ),
      ),
    );
  }
}

class _OrderItem extends StatelessWidget {
  final OrderPresentationModel order;

  const _OrderItem({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    String? paramsString = _getParamsString(context);
    return RfCard(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${context.loc.order} #${order.orderNumber}", style: context.rfTextTheme().body1,),
                  if (paramsString != null) Text(paramsString, style: context.rfTextTheme().body2,),
                ],
              ),
            ),
            Text(_mapOrderStatus(context, order.orderStatus), style: context.rfTextTheme().body3,),
          ],
        ),
      ),
    );
  }

  String _mapOrderStatus(BuildContext context, OrderStatus status) => switch (status) {
    OrderStatus.created => context.loc.created,
    OrderStatus.paid => context.loc.paid,
    OrderStatus.undefined => "",
  };

  String? _getParamsString(BuildContext context) {
    final hasParams =
        order.sealType.isNullOrEmpty() ||
        order.sealColor.isNotNullOrEmpty() ||
        order.logo.isNotNullOrEmpty();
    if (hasParams) {
      final sb = StringBuffer();
      if (order.sealType.isNotNullOrEmpty()) {
        sb.writeWithDivider(order.sealType ?? "");
      }
      if (order.sealColor.isNotNullOrEmpty()) {
        sb.writeWithDivider(order.sealColor ?? "");
      }
      if (order.logo.isNotNullOrEmpty()) {
        sb.writeWithDivider(order.logo ?? "");
      }
      sb.writeWithDivider(context.loc.itemQuantity(order.amount));

      return sb.toString();
    }
    return null;
  }
}
