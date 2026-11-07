import 'package:common/bloc/bloc_instance_provider.dart';
import 'package:common/bloc/news.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:incident/l10n/localization_extension.dart';
import 'package:incident/presentation/incident_item/icident_item_widget.dart';
import 'package:incident/presentation/incident_item/model/incident_presentation_model.dart';
import 'package:incident/presentation/incidents_list/bloc/incidents_list_bloc.dart';
import 'package:incident/presentation/incidents_list/bloc/incidents_list_event.dart';
import 'package:incident/presentation/incidents_list/bloc/incidents_list_news.dart';
import 'package:incident/presentation/incidents_list/bloc/incidents_list_state.dart';
import 'package:list_view_handler/list_view_handler.dart';
import 'package:ui_kit/index.dart';
import 'package:ui_kit/l10n/localization_extension.dart';
import 'package:ui_kit/loading/list_loading_item.dart';

class IncidentsListScreenContent extends StatefulWidget {
  const IncidentsListScreenContent({super.key});

  @override
  State<IncidentsListScreenContent> createState() => _IncidentsListScreenContentState();
}

class _IncidentsListScreenContentState
    extends StateWithBloc<IncidentsListBloc, IncidentsListScreenContent> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      bloc.add(OnQueryChangeEvent(_searchController.text));
    });
  }

  @override
  void onNewsReceived(BlocNews news) {
    if (news is ShowQueryNews) {
      if (_searchController.text != news.query) {
        _searchController.text = news.query;
      }
    } else {
      super.onNewsReceived(news);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(left: 16, right: 16, top: 59),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.loc.incidents, style: context.rfTextTheme().largeTitle),
            Expanded(
              child: BlocBuilder<IncidentsListBloc, IncidentsListState>(
                builder: (context, state) {
                  return switch (state) {
                    LoadingState() => Center(child: CircularProgressIndicator()),
                    IncidentsDataState() => Column(
                      children: [
                        Gap(22),
                        Row(
                          children: [
                            Expanded(
                              child: SearchWidget(
                                controller: _searchController,
                                onTuneClicked: () {},
                                showTunes: false,
                              ),
                            ),
                            Gap(12),
                            GestureDetector(
                              onTap: () => bloc.add(OnMapTapEvent()),
                              behavior: HitTestBehavior.opaque,
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
                        ),
                        Gap(16),
                        Expanded(
                          child: ListViewHandlerBuilder<IncidentListPresentationModel>(
                            state: state.listState,
                            pullToRefreshEnabled: false,
                            padding: const EdgeInsets.only(bottom: 16),
                            builderDelegate:
                                ListViewHandlerBuilderDelegate<IncidentListPresentationModel>(
                                  itemBuilder: (context, item, index) {
                                    return switch (item) {
                                      TodayPresentationModel() => Padding(
                                        padding: const EdgeInsets.only(top: 4.0),
                                        child: Text(
                                          context.commonLoc.today.toUpperCase(),
                                          style: context.rfTextTheme().body4,
                                        ),
                                      ),
                                      YesterdayPresentationModel() => Padding(
                                        padding: const EdgeInsets.only(top: 4.0),
                                        child: Text(
                                          context.commonLoc.yesterday.toUpperCase(),
                                          style: context.rfTextTheme().body4,
                                        ),
                                      ),
                                      DatePresentationModel() => Padding(
                                        padding: const EdgeInsets.only(top: 4.0),
                                        child: Text(
                                          item.date.toUpperCase(),
                                          style: context.rfTextTheme().body4,
                                        ),
                                      ),
                                      IncidentPresentationModel() => Padding(
                                        padding: EdgeInsets.symmetric(vertical: 4),
                                        child: IncidentItem(
                                          incident: item,
                                          onTap: () => bloc.add(OnItemTapEvent(item)),
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
}
