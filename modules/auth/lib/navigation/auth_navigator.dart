import 'package:auth/navigation/external_auth_navigator.dart';

abstract interface class AuthNavigator {
  void navigateFromLogin();
}

final class AuthNavigatorImpl implements AuthNavigator {
  final ExternalAuthNavigator externalAuthNavigator;

  AuthNavigatorImpl(this.externalAuthNavigator);

  @override
  void navigateFromLogin() => externalAuthNavigator.navigateFromLogin();
}
