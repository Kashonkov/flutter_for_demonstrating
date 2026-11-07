import 'package:auto_route/auto_route.dart';
import 'package:common/di/get_it_extensions.dart';
import 'package:flutter/material.dart';
import 'package:lxe_app/feature/main_screen/main_screen.dart';

@RoutePage()
class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MainScreenContent(navigator: getIt());
  }
}
