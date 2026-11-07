import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:ui_kit/button/map_button.dart';

class IncidentMap extends StatefulWidget {
  const IncidentMap({
    super.key,
    required this.lat,
    required this.long,
    this.incidentRange,
    this.radiusMeters,
  });

  final double lat;
  final double long;
  final String? incidentRange;
  final double? radiusMeters;

  @override
  State<IncidentMap> createState() => _MapState();
}

class _MapState extends State<IncidentMap> {
  static const _sourcePolygonId = "route-polygon-source";

  static const _polygonFillLayerId = "route-polygon-fill";
  static const _polygonOutlineLayerId = "route-polygon-outline";
  static const double _defaultZoom = 12.0;

  MapboxMap? _map;
  Size _mapSize = Size(width: 0, height: 0);

  @override
  void didUpdateWidget(covariant IncidentMap oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.lat != widget.lat ||
        oldWidget.long != widget.long ||
        oldWidget.radiusMeters != widget.radiusMeters) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _moveCameraToRadius();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final newSize = Size(width: constraints.maxWidth, height: constraints.maxHeight);

        if (_mapSize != newSize) {
          _mapSize = newSize;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _moveCameraToRadius();
          });
        }

        return Stack(
          children: [
            MapWidget(
              key: ValueKey("mapWidget"),
              onMapCreated: _onMapCreated,
              styleUri: MapboxStyles.LIGHT,
              onStyleLoadedListener: _onStyleLoaded,
              cameraOptions: CameraOptions(
                center: Point(coordinates: Position(widget.long, widget.lat)),
                zoom: _defaultZoom,
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: EdgeInsetsGeometry.only(bottom: 16, right: 16),
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
    );
  }

  _onMapCreated(MapboxMap mapboxMap) async {
    _map = mapboxMap;
    mapboxMap.scaleBar.updateSettings(ScaleBarSettings(enabled: false));
    mapboxMap.scaleBar.updateSettings(ScaleBarSettings(enabled: false));
    mapboxMap.compass.updateSettings(CompassSettings(enabled: false));
    mapboxMap.attribution.updateSettings(AttributionSettings(enabled: false));

    // Создаем менеджеры аннотаций
    final pointAnnotationManager = await mapboxMap.annotations.createPointAnnotationManager();
    var position = Point(coordinates: Position(widget.long, widget.lat));

    final ByteData bytes = await rootBundle.load('assets/image/shield.png');
    final Uint8List list = bytes.buffer.asUint8List();

    pointAnnotationManager.create(
      PointAnnotationOptions(geometry: position, image: list, iconSize: 1.0),
    );
  }

  Future<void> _onStyleLoaded(StyleLoadedEventData data) async {
    await _setupRoute();
    _moveCameraToRadius();
  }

  Future<void> _setupRoute() async {
    await _map?.style.styleSourceExists(_sourcePolygonId).then((value) async {
      if (!value) {
        await _map?.style.addSource(
          GeoJsonSource(id: _sourcePolygonId, data: widget.incidentRange ?? ""),
        );
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
    }
  }

  double _calculateZoom({
    required double latitude,
    required double? radiusMeters,
    required Size size,
    double padding = 32,
  }) {
    final radius = radiusMeters;

    if (radius == null || radius <= 0 || radius.isNaN || radius.isInfinite) {
      return _defaultZoom;
    }

    if (size.width <= 0 || size.height <= 0) {
      return _defaultZoom;
    }

    final usablePixels = math.max(
      1.0,
      math.min(size.width, size.height) - padding * 2,
    );

    final diameterMeters = math.max(radius * 2, 1.0);

    final latitudeRad = latitude * math.pi / 180.0;
    final metersPerPixelAtZoom0 = 156543.03392 * math.cos(latitudeRad);

    final zoom =
        math.log(metersPerPixelAtZoom0 * usablePixels / diameterMeters) / math.ln2;

    if (zoom.isNaN || zoom.isInfinite) {
      return _defaultZoom;
    }

    return (zoom-1).clamp(2.0, 18.0);
  }

  Future<void> _moveCameraToRadius() async {
    final map = _map;
    if (map == null || _mapSize == Size(width: 0, height: 0)) return;

    final zoom = _calculateZoom(
      latitude: widget.lat,
      radiusMeters: widget.radiusMeters,
      size: _mapSize,
      padding: 40,
    );

    await map.flyTo(
      CameraOptions(
        center: Point(coordinates: Position(widget.long, widget.lat)),
        zoom: zoom,
        bearing: 0,
        pitch: 0,
      ),
      MapAnimationOptions(duration: 400),
    );
  }

}
