import 'package:common/bloc/bloc.dart';
import 'package:common/exception/build_context_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:list_view_handler/list_view_handler.dart';
import 'package:shipment/domain/entity/connection_status.dart';
import 'package:shipment/domain/entity/delivery_status.dart';
import 'package:shipment/l10n/localization_extension.dart';
import 'package:shipment/presentation/presentation/shipment_item.dart';
import 'package:shipment/presentation/shipments_list/bloc/shipments_list_bloc.dart';
import 'package:shipment/presentation/shipments_list/bloc/shipments_list_event.dart';
import 'package:shipment/presentation/shipments_list/bloc/shipments_list_news.dart';
import 'package:shipment/presentation/shipments_list/bloc/shipments_list_state.dart';
import 'package:shipment/presentation/shipment_filter_bottom_sheet/filters_bottom_sheet.dart';
import 'package:shipment/presentation/shipment_filter_bottom_sheet/model/shipment_filter.dart';
import 'package:shipment/presentation/shipments_list/model/shipment_presentation_model.dart';
import 'package:ui_kit/bottom_sheet/ui_bottom_sheet.dart';
import 'package:ui_kit/gps/gps_indicator.dart';
import 'package:ui_kit/index.dart';
import 'package:ui_kit/l10n/localization_extension.dart';
import 'package:ui_kit/loading/list_loading_item.dart';
import 'package:ui_kit/tab/rf_scrollable_tab_bar.dart';
import 'package:ui_kit/tab/rf_tab.dart';

class ShipmentsListScreenContent extends StatefulWidget {
  const ShipmentsListScreenContent({super.key});

  @override
  State<ShipmentsListScreenContent> createState() => _ShipmentsListScreenContentState();
}

class _ShipmentsListScreenContentState
    extends StateWithBloc<ShipmentsListBloc, ShipmentsListScreenContent> {
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
  void onNewsReceived(BlocNews news) {
    if (news is ShowFilterDialogNews) {
      _showFiltersBottomSheet(context, news.filter);
    } else if (news is ShowQueryNews) {
      if (_searchController.text != news.query) {
        _searchController.text = news.query;
      }
    } else {
      super.onNewsReceived(news);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(left: 16, right: 16, top: 59),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.loc.shipments,style: context.rfTextTheme().largeTitle,),
            Expanded(
              child: BlocBuilder<ShipmentsListBloc, ShipmentsListState>(
                builder: (context, state) {
                  return switch (state) {
                    LoadingState() => Center(child: CircularProgressIndicator()),
                    ShipmentsDataState() => Column(
                      children: [
                        Gap(22),
                        RfScrollableTabBar<DeliveryStatus>(
                          tabs: [
                            RfTab(title: context.loc.transit, value: DeliveryStatus.transit),
                            RfTab(title: context.loc.delivered, value: DeliveryStatus.delivered),
                          ],
                          onValueChanged: (status){
                            bloc.add(OnChangeDeliveryStatus(status));
                          },
                        ),
                        Gap(16),
                        Row(
                          children: [
                            Expanded(
                              child: SearchWidget(
                                controller: _searchController,
                                onTuneClicked: () {
                                  bloc.add(OnFiltersTapEvent());
                                },
                              ),
                            ),
                            if (state.isMapVisible) ...[
                              Gap(12),
                              GestureDetector(
                                onTap: () => bloc.add(OnMapTapEvent()),
                                child: Container(
                                  height: 36,
                                  width: 36,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  padding: EdgeInsets.all(8),
                                  child: UiIcon(UiIcons.map, size: UiIconSize.medium),
                                ),
                              ),
                            ],
                          ],
                        ),
                        Gap(16),
                        Expanded(
                          child: ListViewHandlerBuilder<ShipmentItemPresentationModel>(
                            state: state.listState,
                            pullToRefreshEnabled: false,
                            padding: const EdgeInsets.only(bottom: 16),
                            builderDelegate:
                                ListViewHandlerBuilderDelegate<ShipmentItemPresentationModel>(
                                  itemBuilder: (context, item, index) {
                                    return switch (item) {
                                      TodayPresentationModel() => Text(
                                        context.commonLoc.today.toUpperCase(),
                                      ),
                                      YesterdayPresentationModel() => Text(
                                        context.commonLoc.yesterday.toUpperCase(),
                                      ),
                                      DatePresentationModel() => Text(item.date.toUpperCase()),
                                      ShipmentPresentationModel() => Padding(
                                        padding: EdgeInsets.symmetric(vertical: 4),
                                        child: GestureDetector(
                                          onTap: () {
                                            bloc.add(OnItemTapEvent(item));
                                          },
                                          child: ShipmentItem(shipment: item.model),
                                        ),
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
          ],
        ),
      ),
    );
  }

  void _showFiltersBottomSheet(BuildContext context, [ShipmentBottomFilters? filter]) {
    showUiModalBottomSheet(
      context: context,
      builder: (context) => FiltersBottomSheet(
        filter: filter,
        onFilterSelected: (filter) => bloc.add(OnFilterSelectedEvent(filter)),
      ),
    );
  }
}
