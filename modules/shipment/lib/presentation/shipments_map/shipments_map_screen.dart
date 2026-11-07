import 'dart:convert';

import 'package:common/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:shipment/domain/entity/shipment_item_entity.dart';
import 'package:shipment/presentation/presentation/shipment_item.dart';
import 'package:shipment/presentation/presentation/shipment_item_model.dart';
import 'package:shipment/presentation/shipment_filter_bottom_sheet/filters_bottom_sheet.dart';
import 'package:shipment/presentation/shipment_filter_bottom_sheet/model/shipment_filter.dart';
import 'package:shipment/presentation/shipments_map/bloc/shipments_map_bloc.dart';
import 'package:shipment/presentation/shipments_map/bloc/shipments_map_event.dart';
import 'package:shipment/presentation/shipments_map/bloc/shipments_map_news.dart';
import 'package:shipment/presentation/shipments_map/bloc/shipments_map_state.dart';
import 'package:ui_kit/bottom_sheet/ui_bottom_sheet.dart';
import 'package:ui_kit/button/map_button.dart';
import 'package:ui_kit/button/rf_back_button.dart';
import 'package:ui_kit/index.dart';
import 'package:ui_kit/loading/loading_frame.dart';

class ShipmentsMapScreenContent extends StatefulWidget {
  const ShipmentsMapScreenContent({super.key});

  @override
  State<ShipmentsMapScreenContent> createState() => _ShipmentsMapScreenContentState();
}

class _ShipmentsMapScreenContentState
    extends StateWithBloc<ShipmentsMapBloc, ShipmentsMapScreenContent> {
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
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: BlocBuilder<ShipmentsMapBloc, ShipmentsMapState>(
        bloc: bloc,
        builder: (context, state) {
          return switch (state) {
            IdleState() => _LoadingFrame(),
            DataState() => _DataFrame(
              shipments: state.shipments,
              onShipmentSelect: (id) => bloc.add(OnShipmentSelectEvent(id: id)),
              selectedShipment: state.selectedShipment,
              searchController: _searchController,
              onSelectedShipmentTap: (id) => bloc.add(OnShipmentTapEvent(id: id)),
              onFilterTap: () => bloc.add(OnFiltersTapEvent()),
            ),
          };
        },
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

typedef _OnShipmentSelect = Function(String? id);
typedef _OnSelectedShipmentTap = Function(String id);

class _DataFrame extends StatelessWidget {
  final List<ShipmentItemEntity> shipments;
  final _OnShipmentSelect onShipmentSelect;
  final _OnSelectedShipmentTap onSelectedShipmentTap;
  final ShipmentItemModel? selectedShipment;
  final TextEditingController searchController;
  final VoidCallback onFilterTap;

  const _DataFrame({
    super.key,
    required this.shipments,
    required this.onShipmentSelect,
    required this.onSelectedShipmentTap,
    required this.searchController,
    required this.onFilterTap,
    this.selectedShipment,
  });

  @override
  Widget build(BuildContext context) {
    final selected = selectedShipment;
    return Stack(
      children: [
        _ShipmentsMap(shipments: shipments, onShipmentTap: onShipmentSelect),
        Positioned(
          top: 60,
          left: 16,
          right: 16,
          child: Row(
            children: [
              RfBackButton(),
              Gap(12),
              Expanded(
                child: SearchWidget(
                  controller: searchController,
                  onTuneClicked: onFilterTap,
                  verticalSize: 44,
                  borderColor: Colors.black.withAlpha(127),
                ),
              ),
            ],
          ),
        ),
        if (selected != null)
          Align(
            alignment: AlignmentGeometry.bottomCenter,
            child: GestureDetector(
              onTap: () => onSelectedShipmentTap(selected.id),
              behavior: HitTestBehavior.opaque,
              child: Container(
                margin: EdgeInsetsGeometry.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withAlpha(50), blurRadius: 16, spreadRadius: 2),
                  ],
                ),
                child: ShipmentItem(shipment: selected),
              ),
            ),
          ),
      ],
    );
  }
}

class _ShipmentsMap extends StatefulWidget {
  final List<ShipmentItemEntity> shipments;
  final _OnShipmentSelect onShipmentTap;

  const _ShipmentsMap({super.key, required this.shipments, required this.onShipmentTap});

  @override
  State<_ShipmentsMap> createState() => _ShipmentsMapState();
}

class _ShipmentsMapState extends State<_ShipmentsMap> {
  MapboxMap? _map;
  String? _selectedId;

  static const _sourceId = "shipments";
  static const _clustersLayerId = "shipments-clusters";
  static const _pointsLayerId = "shipments-unclustered";

  bool _styleReady = false;

  String get _geoJson => shipmentsToGeoJson(widget.shipments, _selectedId);

  @override
  void didUpdateWidget(covariant _ShipmentsMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_styleReady && _map != null && oldWidget.shipments != widget.shipments) {
      _updateSourceAndRefit();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
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
            padding: EdgeInsetsGeometry.only(bottom: _selectedId == null ? 16 : 96, right: 16),
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
    );
  }

  void _onMapCreated(MapboxMap mapboxMap) {
    _map = mapboxMap;

    // Убираем лишнее (опционально)
    mapboxMap.scaleBar.updateSettings(ScaleBarSettings(enabled: false));
    mapboxMap.compass.updateSettings(CompassSettings(enabled: false));
    // mapboxMap.logo.updateSettings(LogoSettings(enabled: false));
    mapboxMap.attribution.updateSettings(AttributionSettings(enabled: false));
  }

  Future<void> _onStyleLoaded(StyleLoadedEventData data) async {
    await _setupClustering();
    await _fitToShipments();
  }

  Future<void> _setupClustering() async {
    _map?.style.styleSourceExists(_sourceId).then((value) async {
      if (!value) {
        await _map?.style.addSource(
          GeoJsonSource(
            id: _sourceId,
            data: _geoJson,
            cluster: true,
            clusterRadius: 60,
            clusterMaxZoom: 14,
            clusterProperties: {
              "hasProblem": [
                "max",
                [
                  "case",
                  ["get", "hasProblem"],
                  1,
                  0,
                ],
              ],
            },
          ),
        );
        _styleReady = true;
      }
    });

    _map?.style.styleLayerExists(_clustersLayerId).then((value) async {
      if (!value) {
        var layer = await rootBundle.loadString('assets/map/cluster_layer.json');
        _map?.style.addStyleLayer(layer, null);

        var clusterCountLayer = await rootBundle.loadString('assets/map/cluster_count_layer.json');
        _map?.style.addStyleLayer(clusterCountLayer, null);

        var unclusteredLayer = await rootBundle.loadString(
          'assets/map/unclustered_point_layer.json',
        );
        _map?.style.addStyleLayer(unclusteredLayer, null);
      }
    });
  }

  Future<void> _updateSourceAndRefit() async {
    final style = _map!.style;
    final src = await style.getSource(_sourceId);
    if (src is GeoJsonSource) {
      await src.updateGeoJSON(_geoJson);
    }
    await _fitToShipments();
  }

  Future<void> _fitToShipments() async {
    final map = _map!;
    final pts = widget.shipments.map((s) => (s.position.longitude, s.position.latitude)).toList();

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
    final padding = MbxEdgeInsets(top: 90, left: 40, bottom: 140, right: 40);

    final camera = await map.cameraForCoordinateBounds(bounds, padding, 0.0, 0.0, null, null);

    await map.flyTo(camera, MapAnimationOptions(duration: 400));
  }

  Future<void> _setSelected(String? newId) async {
    final map = _map;
    if (map == null) return;
    _selectedId = newId;
    final style = _map!.style;
    final src = await style.getSource(_sourceId);
    if (src is GeoJsonSource) {
      await src.updateGeoJSON(_geoJson);
    }

    await map.triggerRepaint();
    widget.onShipmentTap.call(newId);
  }

  void _onMapTap(MapContentGestureContext context) async {
    final map = _map;
    if (map == null) return;

    final hits = await map.queryRenderedFeatures(
      RenderedQueryGeometry.fromScreenCoordinate(context.touchPosition),
      RenderedQueryOptions(layerIds: [_clustersLayerId, _pointsLayerId], filter: null),
    );

    if (hits.isEmpty) {
      await _setSelected(null);
      return;
    }

    // feature в новых версиях часто Map<String, Object?>
    final raw = hits.first?.queriedFeature.feature;
    final featureJson = Map<String, dynamic>.from(raw as Map);

    final props = Map<String, dynamic>.from(featureJson["properties"] as Map? ?? const {});
    final isCluster = props["cluster"] == true || props.containsKey("point_count");

    if (isCluster) {
      await _setSelected(null);

      double targetZoom;
      try {
        final ext = await map.getGeoJsonClusterExpansionZoom(_sourceId, featureJson);
        final v = ext.value;
        targetZoom = (v is num) ? (v as num).toDouble() : double.parse(v.toString());
      } catch (_) {
        targetZoom = (await map.getCameraState()).zoom + 2.0;
      }

      final geomJson = Map<String, dynamic>.from(featureJson["geometry"] as Map);
      final center = Point.fromJson(
        geomJson,
      ); // {"type":"Point","coordinates":[lng,lat]} :contentReference[oaicite:3]{index=3}

      await map.flyTo(
        CameraOptions(center: center, zoom: targetZoom),
        MapAnimationOptions(duration: 300),
      );
      return;
    } else {
      final id = (featureJson["id"] ?? props["id"])?.toString();
      if (id == null) return;

      await _setSelected(id);
    }
  }

  String shipmentsToGeoJson(List<ShipmentItemEntity> shipments, String? selectedId) {
    final features = shipments
        .map(
          (s) => {
            "type": "Feature",
            "id": s.id, // пригодится для feature-state если захочешь
            "geometry": {
              "type": "Point",
              "coordinates": [s.position.longitude, s.position.latitude],
            },
            "properties": {
              "id": s.id,
              "title": s.title,
              "hasProblem": s.incidentCount > 0,
              "selected": s.id == selectedId,
            },
          },
        )
        .toList();

    return jsonEncode({"type": "FeatureCollection", "features": features});
  }
}
