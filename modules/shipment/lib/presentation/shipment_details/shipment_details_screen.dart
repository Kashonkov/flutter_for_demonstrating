import 'dart:convert';
import 'dart:ui' as ui;

import 'package:anchor_ui/anchor_ui.dart';
import 'package:auto_route/auto_route.dart';
import 'package:common/bloc/bloc.dart';
import 'package:common/utils/list_utils.dart';
import 'package:common/utils/string_utils.dart';
import 'package:domain_core/domain/entity/position_entity.dart';
import 'package:domain_core/domain/entity/seal_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:shipment/domain/entity/delivery_status.dart';
import 'package:shipment/domain/entity/route_point_entity.dart';
import 'package:shipment/domain/entity/shipment_status.dart';
import 'package:shipment/l10n/localization_extension.dart';
import 'package:shipment/presentation/shipment_details/bloc/shipment_details_bloc.dart';
import 'package:shipment/presentation/shipment_details/bloc/shipment_details_event.dart';
import 'package:shipment/presentation/shipment_details/bloc/shipment_details_state.dart';
import 'package:shipment/presentation/shipment_details/complete_shipment_bottom_sheet.dart';
import 'package:shipment/presentation/shipment_details/model/route_model.dart';
import 'package:shipment/presentation/shipment_details/model/shipment_presentation_model.dart';
import 'package:shipment/presentation/shipment_details/widgets/point_menu.dart';
import 'package:shipment/presentation/shipment_details/widgets/timeline_widget.dart';
import 'package:ui_kit/bottom_sheet/draggable_modal_bottom_sheet.dart';
import 'package:ui_kit/bottom_sheet/ui_bottom_sheet.dart';
import 'package:ui_kit/button/map_button.dart';
import 'package:ui_kit/button/rf_back_button.dart';
import 'package:ui_kit/button/rf_button.dart';
import 'package:ui_kit/gps/gps_indicator.dart';
import 'package:ui_kit/index.dart';
import 'package:ui_kit/l10n/localization_extension.dart';
import 'package:ui_kit/labeled/label_dotted.dart';
import 'package:ui_kit/loading/loading_frame.dart';
import 'package:ui_kit/tab/rf_scrollable_tab_bar.dart';
import 'package:ui_kit/tab/rf_tab.dart';

class ShipmentsDetailsScreenContent extends StatefulWidget {
  const ShipmentsDetailsScreenContent({super.key});

  @override
  State<ShipmentsDetailsScreenContent> createState() => _ShipmentsDetailsScreenContentState();
}

class _ShipmentsDetailsScreenContentState
    extends StateWithBloc<ShipmentDetailsBloc, ShipmentsDetailsScreenContent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ShipmentDetailsBloc, ShipmentDetailsState>(
        bloc: bloc,
        builder: (context, state) {
          return switch (state) {
            IdleState() => _IdleFrame(),
            LoadingState() => _LoadingFrame(),
            DataState() => _DataFrame(
              model: state.model,
              routeModel: state.routeModel,
              isCompleteVisible: state.isCompleteVisible,
              onOpenIncidentTap: (incident) {
                bloc.add(OnOpenIncidentTapEvent(incident));
              },
              onCompleteTap: () =>
                  _showCompleteBottomSheet(context, state.model.containerInfo.reference),
              onTimeProgressChanged: (double value) {
                bloc.add(OnTimeProgressChangeEvent(value: value));
              },
            ),
          };
        },
      ),
    );
  }

  void _showCompleteBottomSheet(BuildContext context, String shipmentTitle) {
    showUiModalBottomSheet(
      context: context,
      builder: (context) => CompleteShipmentBottomSheet(
        shipmentTitle: shipmentTitle,
        onCancelTap: () {
          AutoRouter.of(context).pop();
        },
        onCompleteTap: ({String? location, required ShipmentStatus status, String? comment}) {
          AutoRouter.of(context).pop();
          bloc.add(OnCompleteTapEvent(address: location, status: status));
        },
      ),
    );
  }
}

class _LoadingFrame extends StatelessWidget {
  const _LoadingFrame({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        LoadingFrame(),
        Positioned(top: 60, left: 16, child: RfBackButton()),
      ],
    );
  }
}

class _IdleFrame extends StatelessWidget {
  const _IdleFrame({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox.expand(),
        Positioned(top: 60, left: 16, child: RfBackButton()),
      ],
    );
  }
}

class _DataFrame extends StatefulWidget {
  final ShipmentPresentationModel model;
  final RouteModel? routeModel;
  final bool isCompleteVisible;
  final OnTimeProgressChanged onTimeProgressChanged;
  final VoidCallback onCompleteTap;
  final OnOpenIncidentTap onOpenIncidentTap;

  const _DataFrame({
    super.key,
    required this.model,
    this.routeModel,
    required this.onTimeProgressChanged,
    required this.onCompleteTap,
    required this.isCompleteVisible,
    required this.onOpenIncidentTap,
  });

  @override
  State<_DataFrame> createState() => _DataFrameState();
}

class _DataFrameState extends State<_DataFrame> {
  final DraggableScrollableController _sheetController = DraggableScrollableController();
  int _selectedTab = 0;
  double _currentExtent = 0.5;

  @override
  void dispose() {
    _sheetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model = widget.model;
    final route = widget.routeModel;
    final height = MediaQuery.of(context).size.height;
    final double timelineOpacity = (1 - 5 * (_currentExtent - 0.25)).clamp(0, 1);
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: MediaQuery.of(context).size.height * (1 - _currentExtent) + 16,
          child: Stack(
            children: [
              route != null
                  ? _ShipmentMap(
                      mapPoints: route.mapPoints,
                      routeLines: route.mapLines,
                      routePolygons: route.mapPolygons,
                      points: route.points,
                      onOpenIncidentTap: widget.onOpenIncidentTap,
                    )
                  : LoadingFrame(),
              if (route != null && timelineOpacity > 0)
                Positioned(
                  top:10,
                  bottom: 10,
                  right: 16,
                  child: Center(
                    child: Opacity(
                      opacity: timelineOpacity,
                      child: TimeSlider(
                        onTimeProgressChanged: widget.onTimeProgressChanged,
                        onOpenIncidentTap: widget.onOpenIncidentTap,
                        timeline: route.timeline,
                        isFinished: model.deliveryStatus == DeliveryStatus.delivered,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        Positioned(top: 60, left: 16, child: RfBackButton()),
        NotificationListener<DraggableScrollableNotification>(
          onNotification: (notification) {
            setState(() {
              _currentExtent = notification.extent;
            });
            return true;
          },
          child: DraggableScrollableSheet(
            controller: _sheetController,
            maxChildSize: 0.65,
            builder: (context, controller) {
              return DraggableModalContainer(
                controller: controller,
                onDrag: (dy) {
                  final deltaSize = dy / height;
                  final next = (_sheetController.size - deltaSize).clamp(0.2, 0.65).toDouble();
                  _sheetController.jumpTo(next);
                },
                stickyChild: _ShipmentInfoTitleWidget(
                  shift: widget.model,
                  onTabChanged: (index) {
                    setState(() {
                      _selectedTab = index;
                    });
                  },
                ),
                child: _selectedTab == 0
                    ? _ShipmentInfoWidget(
                        shipment: model,
                        onCompleteTap: widget.onCompleteTap,
                        isCompleteVisible: widget.isCompleteVisible,
                      )
                    : _ShipmentSealsWidget(seals: model.seals),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ShipmentInfoWidget extends StatelessWidget {
  final ShipmentPresentationModel shipment;
  final VoidCallback onCompleteTap;
  final bool isCompleteVisible;

  const _ShipmentInfoWidget({
    super.key,
    required this.shipment,
    required this.onCompleteTap,
    required this.isCompleteVisible,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Gap(12),
        _ShipmentRouteWidget(origin: shipment.originPosition, current: shipment.currentPosition),
        Gap(16),
        _ContainerInfo(containerInfo: shipment.containerInfo),
        if (!shipment.stats.isEmpty) ...[Gap(16), _ShipmentStatisticWidget(stats: shipment.stats)],
        Gap(24),
        if (isCompleteVisible)
          RfButton(onPressed: onCompleteTap, customRadius: 24, title: context.loc.complete.toUpperCase()),
        // Gap(24),
        // Row(
        //   children: [
        //     Expanded(
        //       child: RfButton(
        //         title: context.loc.editName,
        //         type: ButtonType.textButton,
        //         icon: UiIcon(UiIcons.pen, size: UiIconSize.small),
        //         size: ButtonSize.large,
        //       ),
        //     ),
        //     Expanded(
        //       child: RfButton(
        //         title: context.loc.addToWatchList,
        //         icon: UiIcon(UiIcons.star, size: UiIconSize.small),
        //         type: ButtonType.textButton,
        //         size: ButtonSize.large,
        //       ),
        //     ),
        //   ],
        // ),
      ],
    );
  }
}

typedef OnTabChanged = Function(int tabIndex);

class _ShipmentInfoTitleWidget extends StatelessWidget {
  final OnTabChanged onTabChanged;
  final ShipmentPresentationModel shift;

  const _ShipmentInfoTitleWidget({super.key, required this.onTabChanged, required this.shift});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(shift.title, style: context.rfTextTheme().header1,),
                      Gap(8),
                      shift.isGpsConnected ? GpsIndicator() : InactiveGpsIndicator(),
                    ],
                  ),
                  Text("${shift.updatedDate} | ${shift.address}", style: context.rfTextTheme().body2,),
                ],
              ),
            ),
            _TransitStatusWidget(status: shift.deliveryStatus),
          ],
        ),
        Gap(16),
        RfScrollableTabBar(
          tabs: [
            RfTab(title: context.loc.mainInfo.toUpperCase(), value: 0),
            RfTab(title: context.loc.seals(shift.seals.length).toUpperCase(), value: 1),
          ],
          onValueChanged: onTabChanged,
        ),
        Gap(4),
      ],
    );
  }
}

class _ShipmentRouteWidget extends StatelessWidget {
  final PositionEntity origin;
  final PositionEntity current;

  const _ShipmentRouteWidget({super.key, required this.origin, required this.current});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          spacing: 6,
          children: [
            _LocationItemWidget(
              title: context.loc.origin,
              location: origin.title,
              date: origin.time.format(),
              iconPath: UiIcons.flag,
            ),
            Gap(16),
            // Padding(
            //   padding: EdgeInsetsGeometry.only(left: 36),
            //   child: Row(children: [Text("7d on the way"), Gap(28), Text("999km")]),
            // ),
            _LocationItemWidget(
              title: context.loc.lastLocation,
              location: current.title,
              date: current.time.format(),
              iconPath: UiIcons.location,
              // onMapTap: () {},
            ),
          ],
        ),
        Positioned(top: 26, left: 16, child: Container(width: 2, height: 84, color: Colors.grey)),
      ],
    );
  }
}

class _ShipmentStatisticWidget extends StatelessWidget {
  final StatsPresentationModel stats;

  const _ShipmentStatisticWidget({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.loc.allTime, style: context.rfTextTheme().body2Variant,),
        Gap(8),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.start,
          spacing: 4,
          runSpacing: 4,
          children: [
            if (stats.distance != null)
              _StatisticItemWidget(title: context.loc.distance, value: stats.distance ?? ""),
            if (stats.timeTotal != null)
              _StatisticItemWidget(title: context.loc.time, value: stats.timeTotal ?? ""),
            if (stats.timeIdle != null)
              _StatisticItemWidget(title: context.loc.idle, value: stats.timeIdle ?? ""),
            if (stats.timeInMotion != null)
              _StatisticItemWidget(title: context.loc.inMotion, value: stats.timeInMotion ?? ""),
          ],
        ),
      ],
    );
  }
}

class _TransitStatusWidget extends StatelessWidget {
  final DeliveryStatus status;

  const _TransitStatusWidget({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(color: _mapColor(), borderRadius: BorderRadius.circular(16)),
      child: Text(_mapStatus(context), style: context.rfTextTheme().body3.copyWith(color: _mapTextColor())),
    );
  }

  String _mapStatus(BuildContext context) {
    return switch (status) {
      DeliveryStatus.transit => context.loc.transit,
      DeliveryStatus.delivered => context.loc.delivered,
      DeliveryStatus.undefined => "",
    };
  }

  Color _mapColor() {
    return switch (status) {
      DeliveryStatus.transit => Color(0x372196F3),
      DeliveryStatus.delivered => Colors.green,
      DeliveryStatus.undefined => Colors.grey,
    };
  }

  Color _mapTextColor() {
    return switch (status) {
      DeliveryStatus.transit => Color(0xFF2196F3),
      DeliveryStatus.delivered => Colors.white,
      DeliveryStatus.undefined => Colors.grey,
    };
  }
}

class _LocationItemWidget extends StatelessWidget {
  final String title;
  final String location;
  final String date;
  final String iconPath;
  final VoidCallback? onMapTap;

  const  _LocationItemWidget({
    super.key,
    required this.title,
    required this.location,
    required this.date,
    required this.iconPath,
    this.onMapTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 12),
      height: 74,
      decoration: BoxDecoration(color: Color(0x08000000), borderRadius: BorderRadius.circular(4)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UiIcon(iconPath, size: UiIconSize.small),
          Gap(8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Text(title, style: context.rfTextTheme().body2Variant.copyWith(color: Color(0x80000000)))),
                    Text(date, style: context.rfTextTheme().body2Variant.copyWith(color: Color(0x80000000)),),
                  ],
                ),
                Gap(4),
                Text(location, style: context.rfTextTheme().body2Variant,),
                Gap(4),
                if (onMapTap != null)
                  Align(
                    alignment: Alignment.centerRight,
                    child: RfButton(
                      onPressed: onMapTap,
                      type: ButtonType.textButton,
                      title: "On map",
                      isFullWidth: false,
                      icon: UiIcon(UiIcons.pin, size: UiIconSize.xsmall),
                      textStyle: TextStyle().copyWith(color: Colors.red, fontSize: 12),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ContainerInfo extends StatelessWidget {
  final ContainerInfoPresentationModel containerInfo;

  const _ContainerInfo({super.key, required this.containerInfo});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        LabeledValue(label: context.commonLoc.reference, value: containerInfo.reference),
        if (containerInfo.number != null)
          LabeledValue(label: context.commonLoc.container, value: containerInfo.number ?? ""),
      ],
    );
  }
}

class _StatisticItemWidget extends StatelessWidget {
  final String title;
  final String value;

  const _StatisticItemWidget({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: Color(0x08000000), borderRadius: BorderRadius.circular(4)),
      child: Row(mainAxisSize: MainAxisSize.min, spacing: 8, children: [Text(title, style: context.rfTextTheme().body2Variant.copyWith(color: Color(0x80000000)),), Text(value, style: context.rfTextTheme().body2Variant)]),
    );
  }
}

class _ShipmentSealsWidget extends StatelessWidget {
  final List<SealPresentationModel> seals;

  const _ShipmentSealsWidget({super.key, required this.seals});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.only(top: 20),
      child: Column(
        children: seals
            .map(
              (seal) => _SealItem(
                title: seal.title,
                status: seal.status,
                type: seal.type,
                color: seal.color,
                isGpsConnected: seal.isGpsConnected,
                isConnected: seal.isConnected,
              ),
            )
            .cast()
            .intersperse(Divider(color: Colors.grey.shade300))
            .toList()
            .cast(),
      ),
    );
  }
}

class _SealItem extends StatelessWidget {
  final String title;
  final SealStatus status;
  final String type;
  final String color;
  final bool isGpsConnected;
  final bool isConnected;

  const _SealItem({
    super.key,
    required this.title,
    required this.status,
    required this.type,
    required this.color,
    required this.isGpsConnected,
    required this.isConnected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(title, style: context.rfTextTheme().body1Variant,),
            Gap(8),
            _ConnectionStatusWidget(isConnected: isConnected),
            Spacer(),
            _StatusWidget(status: _mapSealStatus(context, status)),
          ],
        ),
        Row(
          children: [
            Text("$type • $color", style: context.rfTextTheme().body2,),
            Spacer(),
            isGpsConnected ? GpsIndicator() : InactiveGpsIndicator(),
          ],
        ),
      ],
    );
  }

  String _mapSealStatus(BuildContext context, SealStatus status) {
    return switch (status) {
      SealStatus.ok => context.loc.ok,
      SealStatus.cableCut => context.loc.cableCut,
      SealStatus.lowBattery => context.loc.lowBattery,
      SealStatus.deactivated => context.loc.deactivated,
      SealStatus.undefined => "",
    };
  }
}

class _ConnectionStatusWidget extends StatelessWidget {
  final bool isConnected;

  const _ConnectionStatusWidget({super.key, required this.isConnected});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 8,
      width: 8,
      decoration: BoxDecoration(
        color: isConnected ? Colors.green : Colors.grey,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _StatusWidget extends StatelessWidget {
  final String status;

  const _StatusWidget({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 1, horizontal: 6),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Color(0x10000000)),
      child: Text(status, style: context.rfTextTheme().body3,),
    );
  }
}


class _ShipmentMap extends StatefulWidget {
  final String mapPoints;
  final String? routeLines;
  final String? routePolygons;
  final List<RoutePointEntity> points;
  final OnOpenIncidentTap onOpenIncidentTap;

  const _ShipmentMap({
    super.key,
    required this.mapPoints,
    required this.points,
    required this.onOpenIncidentTap,
    this.routeLines,
    this.routePolygons,
  });

  @override
  State<_ShipmentMap> createState() => _ShipmentMapState();
}

class _ShipmentMapState extends State<_ShipmentMap> {
  final _menuController = AnchorContextMenuController();
  MapboxMap? _map;

  static const _sourceId = "route-source";
  static const _sourceLineId = "route-line-source";
  static const _sourcePolygonId = "route-polygon-source";

  static const _routeLayerId = "route-layer";
  static const _pointsLayerId = "route-points";
  static const _pointsSymbolLayerId = "route-points-symbol";
  static const _polygonFillLayerId = "route-polygon-fill";
  static const _polygonOutlineLayerId = "route-polygon-outline";

  bool _styleReady = false;

  RoutePointEntity? _selectedPoint;
  String? _selectedFeatureId;

  @override
  void dispose() {
    _menuController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant _ShipmentMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_styleReady && _map != null && oldWidget.mapPoints != widget.mapPoints) {
      _updateSourceAndRefit();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnchorContextMenu(
      controller: _menuController,
      placement: Placement.top,
      onDismiss: (){
        _clearSelection();
      },
      viewPadding: const EdgeInsets.all(16),
      dismissOnTapOutside: true,
      menuBuilder: (context) {
        final point = _selectedPoint;
        if (point != null) {
          return PointMenu(
            point: point,
            onOpenIncidentTap: (incident) {
              _menuController.hide();
              widget.onOpenIncidentTap(incident);
            },
          );
        } else {
          return SizedBox.shrink();
        }
      },
      childBuilder: (context) => Stack(
        children: [
          MapWidget(
            key: const ValueKey("shipments_map"),
            cameraOptions: CameraOptions(
              center: Point(coordinates: Position(-95.0, 39.0)),
              zoom: 3.2,
            ),
            styleUri: MapboxStyles.LIGHT,
            androidHostingMode: AndroidPlatformViewHostingMode.HC,
            onMapCreated: _onMapCreated,
            onStyleLoadedListener: _onStyleLoaded,
            onTapListener: _onMapTap,
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: EdgeInsetsGeometry.only(bottom: 32, right: 16),
              child: MapZoomButtons(
                onZoomInTap: () {
                  _map?.getCameraState().then((state) {
                    final options = CameraOptions(
                      center: state.center,
                      padding: state.padding,
                      zoom: state.zoom + 1,
                      bearing: state.bearing,
                      pitch: state.pitch,
                    );
                    _map?.flyTo(options, MapAnimationOptions(duration: 200));
                  });
                },
                onZoomOutTap: () {
                  _map?.getCameraState().then((state) {
                    final options = CameraOptions(
                      center: state.center,
                      padding: state.padding,
                      zoom: state.zoom - 1,
                      bearing: state.bearing,
                      pitch: state.pitch,
                    );
                    _map?.flyTo(options, MapAnimationOptions(duration: 200));
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onMapCreated(MapboxMap mapboxMap) async {
    _map = mapboxMap;

    // Убираем лишнее (опционально)
    mapboxMap.scaleBar.updateSettings(ScaleBarSettings(enabled: false));
    mapboxMap.compass.updateSettings(CompassSettings(enabled: false));
    mapboxMap.logo.updateSettings(LogoSettings(marginBottom: 32));
    mapboxMap.attribution.updateSettings(AttributionSettings(enabled: false));
  }

  Future<void> _onStyleLoaded(StyleLoadedEventData data) async {
    await _setupRoute();
    await _fitToShipments();
  }

  Future<void> _setupRoute() async {
    await _map?.style.styleSourceExists(_sourceId).then((value) async {
      if (!value) {
        await _map?.style.addSource(GeoJsonSource(id: _sourceId, data: widget.mapPoints));
        _styleReady = true;
      }
    });

    await _map?.style.styleSourceExists(_sourceLineId).then((value) async {
      if (!value) {
        await _map?.style.addSource(
          GeoJsonSource(id: _sourceLineId, data: widget.routeLines ?? ""),
        );
        _styleReady = true;
      }
    });

    await _map?.style.styleSourceExists(_sourcePolygonId).then((value) async {
      if (!value) {
        await _map?.style.addSource(
          GeoJsonSource(id: _sourcePolygonId, data: widget.routePolygons ?? ""),
        );
        _styleReady = true;
      }
    });

    final map = _map;
    if (map != null) {
      if (!await map.style.styleLayerExists(_polygonFillLayerId)) {
        final fillJson = await rootBundle.loadString('assets/map/polygon_fill_layer.json');
        await map.style.addStyleLayer(fillJson, null);
      }

      if (!await map.style.styleLayerExists(_polygonOutlineLayerId)) {
        final lineJson = await rootBundle.loadString('assets/map/polygon_outline_layer.json');
        await map.style.addStyleLayer(lineJson, null);
      }

      final lineLayerExists = await map.style.styleLayerExists(_routeLayerId);
      if (!lineLayerExists) {
        final lineJson = await rootBundle.loadString('assets/map/route_line_layer.json');
        await map.style.addStyleLayer(lineJson, null);
      }

      final pointLayerExists = await map.style.styleLayerExists(_pointsLayerId);
      if (!pointLayerExists) {
        final pointLayer = await rootBundle.loadString('assets/map/route_point_layer.json');
        await map.style.addStyleLayer(pointLayer, null);
      }

      final symbolLayerExists = await map.style.styleLayerExists(_pointsSymbolLayerId);
      if (!symbolLayerExists) {
        await addCustomIcon(map, "origin", "assets/image/origin.png");
        await addCustomIcon(map, "destination", "assets/image/destination.png");
        await addCustomIcon(map, "incident", "assets/image/shield.png");

        final String symbolsJson = await rootBundle.loadString(
          'assets/map/route_point_symbol_layer.json',
        );
        await map.style.addStyleLayer(symbolsJson, null);
      }
    }
  }

  Future<void> _updateSourceAndRefit() async {
    final style = _map!.style;
    final src = await style.getSource(_sourceId);
    if (src is GeoJsonSource) {
      await src.updateGeoJSON(widget.mapPoints);
    }
    final lineSrc = await style.getSource(_sourceLineId);
    if (lineSrc is GeoJsonSource) {
      await lineSrc.updateGeoJSON(widget.routeLines ?? "");
    }
    final polygonSrc = await style.getSource(_sourcePolygonId);
    if (polygonSrc is GeoJsonSource) {
      await polygonSrc.updateGeoJSON(widget.routePolygons ?? "");
    }
    await _fitToShipments();
  }

  Future<void> _fitToShipments() async {
    final map = _map!;
    final pts = widget.points.map((s) => (s.position.longitude, s.position.latitude)).toList();

    if (pts.isEmpty) return;

    double minLon = pts.first.$1, maxLon = pts.first.$1;
    double minLat = pts.first.$2, maxLat = pts.first.$2;

    for (final p in pts) {
      if (p.$1 < minLon) minLon = p.$1;
      if (p.$1 > maxLon) maxLon = p.$1;
      if (p.$2 < minLat) minLat = p.$2;
      if (p.$2 > maxLat) maxLat = p.$2;
    }

    final bounds = CoordinateBounds(
      southwest: Point(coordinates: Position(minLon, minLat)),
      northeast: Point(coordinates: Position(maxLon, maxLat)),
      infiniteBounds: false,
    );

    // Отступы “как на UI” (сверху под AppBar/кнопки, снизу под панели)
    final padding = MbxEdgeInsets(top: 140, left: 40, bottom: 140, right: 64);

    final camera = await map.cameraForCoordinateBounds(bounds, padding, 0.0, 0.0, null, null);

    await map.flyTo(camera, MapAnimationOptions(duration: 400));
  }

  Future<void> addCustomIcon(MapboxMap mapboxMap, String imageId, String assetPath) async {
    final ByteData bytes = await rootBundle.load(assetPath);
    final Uint8List list = bytes.buffer.asUint8List();
    final codec = await ui.instantiateImageCodec(list);
    final frame = await codec.getNextFrame(); // 3. Вызываем ваш метод
    await mapboxMap.style.addStyleImage(
      imageId,
      1.0,
      MbxImage(width: frame.image.width, height: frame.image.height, data: list),
      false,
      [],
      [],
      null,
    );
  }

  Future<void> _selectFeature(String id) async {
    final map = _map;
    if (map == null) return;

    if (_selectedFeatureId != null && _selectedFeatureId != id) {
      await map.removeFeatureState(
        _sourceId, // "route-source"
        null, // geojson source => sourceLayerId = null
        _selectedFeatureId!,
        'selected',
      );
    }

    await map.setFeatureState(_sourceId, null, id, jsonEncode({'selected': true}));

    _selectedFeatureId = id;
  }

  Future<void> _clearSelection() async {
    final map = _map;
    if (map == null) return;

    if (_selectedFeatureId != null) {
      await map.removeFeatureState(_sourceId, null, _selectedFeatureId!, 'selected');
      _selectedFeatureId = null;
    }

    if (!mounted) return;
    setState(() {
      _selectedPoint = null;
    });

    _menuController.hide();
  }

  void _onMapTap(MapContentGestureContext context) async {
    final map = _map;
    if (map == null) return;

    const double hitSlop = 5;

    final p = context.touchPosition;
    final box = ScreenBox(
      min: ScreenCoordinate(x: p.x - hitSlop, y: p.y - hitSlop),
      max: ScreenCoordinate(x: p.x + hitSlop, y: p.y + hitSlop),
    );

    final hits = await map.queryRenderedFeatures(
      RenderedQueryGeometry.fromScreenBox(box),
      RenderedQueryOptions(layerIds: [_pointsSymbolLayerId, _pointsLayerId], filter: null),
    );

    if (hits.isEmpty) {
      _clearSelection();
      return;
    }

    final raw = hits.first?.queriedFeature.feature;
    if (raw == null) {
      _clearSelection();
      return;
    }

    final featureJson = Map<String, dynamic>.from(raw as Map);
    final props = Map<String, dynamic>.from(featureJson["properties"] as Map? ?? const {});

    final id = (featureJson["id"] ?? props["id"])?.toString();
    if (id == null) {
      _clearSelection();
      return;
    }

    await _selectFeature(id);

    setState(() {
      _selectedPoint = widget.points.firstWhere((point) => point.id == id);
    });

    // ВАЖНО: AnchorContextMenu ждёт Offset виртуальной позиции.
    // Для Mapbox это как раз touchPosition (координаты тапа по карте).
    _menuController.show(
      Offset(context.touchPosition.x.toDouble(), (context.touchPosition.y - 8).toDouble()),
    );
  }
}
