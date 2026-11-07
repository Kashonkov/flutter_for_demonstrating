import 'package:api/exception/auth_exception_handler.dart';
import 'package:auth/navigation/auth_router.gr.dart';
import 'package:lxe_app/router/app_router.dart';

final class AuthExceptionHandlerImpl extends AuthExceptionHandler {
  final AppRouter router;

  AuthExceptionHandlerImpl(this.router);

  @override
  Future<void> onSessionExpired() async {
    router.replaceAll([LoginRoute()]);
  }
}
