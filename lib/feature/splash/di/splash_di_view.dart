import 'package:auto_route/auto_route.dart';
import 'package:common/di/di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lxe_app/feature/splash/presentation/bloc/splash_bloc.dart';
import 'package:lxe_app/feature/splash/presentation/splash_screen.dart';

@RoutePage()
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SplashBloc(navigator: getIt(), initJwtTokenAuthorizationUseCase: getIt()),
      child: SplashScreenContent(),
    );
  }
}
