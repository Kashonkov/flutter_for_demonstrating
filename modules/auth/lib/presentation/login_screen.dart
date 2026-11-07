import 'package:auth/l10n/localization_extension.dart';
import 'package:auth/presentation/bloc/login_screen_bloc.dart';
import 'package:auth/presentation/bloc/login_screen_event.dart';
import 'package:auth/presentation/bloc/login_screen_state.dart';
import 'package:common/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ui_kit/button/rf_button.dart';
import 'package:ui_kit/index.dart';
import 'package:ui_kit/loading/loading_frame.dart';

class LoginScreenContent extends StatefulWidget {
  const LoginScreenContent({super.key});

  @override
  State<LoginScreenContent> createState() => _LoginScreenContentState();
}

class _LoginScreenContentState extends StateWithBloc<LoginScreenBloc, LoginScreenContent> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    emailController.addListener(() => bloc.add(OnEmailChangedEvent(emailController.text)));
    passwordController.addListener(() => bloc.add(OnPasswordChangedEvent(passwordController.text)));
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: BlocBuilder<LoginScreenBloc, LoginScreenState>(
            bloc: bloc,
            builder: (context, state) {
              return switch (state) {
                LoadingState() => LoadingFrame(),
                InputState() => _DataFrame(
                  emailController: emailController,
                  passwordController: passwordController,
                  emailError: state.emailError,
                  passwordError: state.passwordError,
                  onLoginClickedEvent: () {
                    bloc.add(OnLoginClickedEvent());
                  },
                ),
              };
            },
          ),
        ),
      ),
    );
  }
}

class _DataFrame extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final String? emailError;
  final String? passwordError;
  final VoidCallback onLoginClickedEvent;

  const _DataFrame({
    super.key,
    required this.emailController,
    required this.passwordController,
    this.emailError,
    this.passwordError,
    required this.onLoginClickedEvent,
  });

  @override
  State<_DataFrame> createState() => _DataFrameState();
}

class _DataFrameState extends State<_DataFrame> {
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(context.loc.signInTitle, style: context.rfTextTheme().largeTitle),
            Gap(8),
            Text(context.loc.enterCreds, style: context.rfTextTheme().body2),
            Gap(40),
            RfTextField(
              controller: widget.emailController,
              maxLines: 1,
              label: context.loc.email,
              error: widget.emailError,
            ),
            Gap(12),
            RfTextField(
              controller: widget.passwordController,
              label: context.loc.password,
              error: widget.passwordError,
              isObscured: _isObscured,
              maxLines: 1,
              suffix: GestureDetector(
                onTap: () {
                  setState(() {
                    _isObscured = !_isObscured;
                  });
                },
                behavior: HitTestBehavior.opaque,
                child: _isObscured
                    ? FaIcon(FontAwesomeIcons.eye, size: 16, color: Colors.black)
                    : FaIcon(FontAwesomeIcons.eyeSlash, size: 16, color: Colors.black),
              ),
            ),
            Gap(56),
            RfButton(onPressed: widget.onLoginClickedEvent, title: context.loc.signIn.toUpperCase()),
          ],
        ),
      ),
    );
  }
}
