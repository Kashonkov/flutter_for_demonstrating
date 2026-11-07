import 'package:api/jwt/domain/use_case/init_jwt_token_authorization_use_case.dart';
import 'package:common/bloc/base_bloc.dart';
import 'package:common/index.dart';
import 'package:lxe_app/feature/splash/navigation/splash_navigator.dart';
import 'package:lxe_app/feature/splash/presentation/bloc/splash_event.dart';
import 'package:lxe_app/feature/splash/presentation/bloc/splash_state.dart';
import 'package:profile/domain/use_case/get_profile_use_case.dart';

final class SplashBloc extends BaseBloc<SplashEvent, SplashState> {
  final InitJwtTokenAuthorizationUseCase initJwtTokenAuthorizationUseCase;
  final SplashNavigator navigator;

  SplashBloc({required this.initJwtTokenAuthorizationUseCase, required this.navigator}) : super(IdleState()) {
    init();
  }

  Future<void> init() async {
    await processUseCase(() => initJwtTokenAuthorizationUseCase(EmptyUsecaseParams()), onSuccess: (result){
      navigator.navigateToMainScreen();
    }, onError: (error){
      navigator.navigateToAuth();
    });
  }
}
