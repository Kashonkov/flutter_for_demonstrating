import 'package:common/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:lxe_app/feature/splash/presentation/bloc/splash_bloc.dart';

class SplashScreenContent extends StatefulWidget {
  const SplashScreenContent({super.key});

  @override
  State<SplashScreenContent> createState() => _SplashScreenContentState();
}

class _SplashScreenContentState extends StateWithBloc<SplashBloc, SplashScreenContent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Center(child: Text("SPLASH"))),
    );
  }
}
