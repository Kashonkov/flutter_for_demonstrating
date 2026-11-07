import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class RfMapWidget extends StatefulWidget {
  const RfMapWidget({super.key});

  @override
  State<RfMapWidget> createState() => _MapState();
}

class _MapState extends State<RfMapWidget> {
  MapboxMap? mapboxMap;

  _onMapCreated(MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
    mapboxMap.scaleBar.updateSettings(ScaleBarSettings(enabled: false));
  }

  @override
  Widget build(BuildContext context) {
    return MapWidget(
      key: ValueKey("mapWidget"),
      onMapCreated: _onMapCreated,
      styleUri: MapboxStyles.LIGHT,
      cameraOptions: CameraOptions(
        center: Point(coordinates: Position(-80.1263, 25.7845)),
        zoom: 14.0,
      ),
    );
  }
}
