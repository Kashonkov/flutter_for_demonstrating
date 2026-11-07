import 'package:profile/navigation/external_profile_navigator.dart';

abstract interface class ProfileNavigator {
  void navigateToLogout();

  void navigateToOrders();
}

final class ProfileNavigatorImpl implements ProfileNavigator {
  final ExternalProfileNavigator externalNavigator;

  ProfileNavigatorImpl(this.externalNavigator);

  @override
  void navigateToLogout() {
    externalNavigator.navigateToLogout();
  }

  @override
  void navigateToOrders() {
    externalNavigator.navigateToOrders();
  }
}
