import 'package:api/exception/auth_exception.dart';
import 'package:auth/domain/entity/auth_exception.dart';
import 'package:auth/domain/use_case/login_use_case.dart';
import 'package:auth/l10n/auth_localizations.dart';
import 'package:auth/navigation/auth_navigator.dart';
import 'package:auth/presentation/bloc/login_screen_event.dart';
import 'package:auth/presentation/bloc/login_screen_state.dart';
import 'package:common/bloc/base_bloc.dart';
import 'package:common/exception/common_exceptions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final class LoginScreenBloc extends BaseBloc<LoginScreenEvent, LoginScreenState> {
  final LoginUseCase loginUseCase;
  final AuthLocalizations localizations;
  final AuthNavigator authNavigator;

  bool _isInvalidCreds = false;
  String _email = "";
  String _password = "";

  LoginScreenBloc({
    required this.loginUseCase,
    required this.authNavigator,
    required this.localizations,
  }) : super(InputState()) {
    on<OnEmailChangedEvent>(_onEmailChanged);
    on<OnPasswordChangedEvent>(_onPasswordChanged);
    on<OnLoginClickedEvent>(_onLoginClicked);
  }

  void _onEmailChanged(OnEmailChangedEvent event, Emitter emit) {
    _email = event.email;

    final currentState = state;
    if (currentState is InputState) {
      if (_isInvalidCreds) {
        emit(InputState());
        _isInvalidCreds = false;
      } else {
        emit(InputState(passwordError: currentState.passwordError));
      }
    }
  }

  void _onPasswordChanged(OnPasswordChangedEvent event, Emitter emit) {
    _password = event.password;
    final currentState = state;
    if (currentState is InputState) {
      if (_isInvalidCreds) {
        emit(InputState());
        _isInvalidCreds = false;
      } else {
        emit(InputState(emailError: currentState.emailError));
      }
    }
  }

  void _onLoginClicked(OnLoginClickedEvent event, Emitter emit) async {
    emit(LoadingState());
    await processUseCase(
      () => loginUseCase(LoginUseCaseParams(email: _email, password: _password)),
      onSuccess: (result) {
        authNavigator.navigateFromLogin();
      },
      onError: (error) {
        _processError(error, emit);
      },
    );
  }

  void _processError(Exception error, Emitter emit) {
    switch (error) {
      case EmptyEmailException():
        emit(InputState(emailError: localizations.emptyFieldError));
      case EmptyPasswordException():
        emit(InputState(passwordError: localizations.emptyFieldError));
      case SessionExpiredException():
        _isInvalidCreds = true;
        emit(
          InputState(
            emailError: localizations.invalidCreds,
            passwordError: localizations.invalidCreds,
          ),
        );
      default:
        emit(InputState());
        handleUseCaseError(error);
    }
  }
}
