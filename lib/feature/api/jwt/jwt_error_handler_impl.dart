import 'package:api/jwt/domain/use_case/jwt_error_handler.dart';
import 'package:auth/navigation/auth_router.gr.dart';
import 'package:lxe_app/router/app_router.dart';

final class JwtErrorHandlerImpl extends JwtErrorHandler{
  final AppRouter router;

  JwtErrorHandlerImpl(this.router);

  @override
  onError(Exception exception, StackTrace trace) {
    router.replaceAll([LoginRoute()]);
  }
}