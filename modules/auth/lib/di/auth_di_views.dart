import 'package:auth/l10n/auth_localizations.dart';
import 'package:auth/presentation/bloc/login_screen_bloc.dart';
import 'package:auth/presentation/login_screen.dart';
import 'package:auto_route/auto_route.dart';
import 'package:common/di/di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginScreenBloc(
        loginUseCase: getIt(),
        authNavigator: getIt(),
        localizations: AuthLocalizations.of(context),
      ),
      child: LoginScreenContent(),
    );
  }
}
