import 'package:api/config/api_config.dart';
import 'package:common/di/di.dart';
import 'package:flutter/material.dart';
import 'package:lxe_app/app_dart.dart';
import 'package:lxe_app/di/init_di.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _prepareApp();
  const String mapAT = String.fromEnvironment("MAT");
  MapboxOptions.setAccessToken(mapAT);
  runApp(MainApp(router: getIt()));
}

Future<void> _prepareApp() async {
  await initDI(_createConfig());
}

ApiConfig _createConfig() => ApiConfig(
  authConfig: UrlConfig(url: "https://test", isLoggingEnable: true),
  baseConfig: UrlConfig(url: "https://test", isLoggingEnable: true),
);
