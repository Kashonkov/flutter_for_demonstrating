import 'package:flutter/material.dart';

extension MediaQueryExt on BuildContext {
  Size get mediaQuerySize => MediaQuery.sizeOf(this);

  EdgeInsets get mediaQueryPadding => MediaQuery.paddingOf(this);

  EdgeInsets get mediaQueryViewPadding => MediaQuery.viewPaddingOf(this);

  EdgeInsets get mediaQueryViewInsets => MediaQuery.viewInsetsOf(this);

  Orientation get orientation => MediaQuery.orientationOf(this);

  bool get isLandscape => orientation == Orientation.landscape;

  bool get isPortrait => orientation == Orientation.portrait;

  bool get alwaysUse24HourFormat => MediaQuery.alwaysUse24HourFormatOf(this);

  double get devicePixelRatio => MediaQuery.devicePixelRatioOf(this);

  Brightness get platformBrightness => MediaQuery.platformBrightnessOf(this);

  double textScaleFactor(double fontSize) => MediaQuery.textScalerOf(this).scale(fontSize);

  double get mediaQueryShortestSide => mediaQuerySize.shortestSide;

  /// True if the current device is Phone.
  bool get isPhone => mediaQueryShortestSide < 600;

  /// 600dp: a 7” tablet (600x1024 mdpi).
  bool get isSmallTablet => mediaQueryShortestSide >= 600;

  /// 720dp: a 10” tablet (720x1280 mdpi, 800x1280 mdpi, etc).
  bool get isLargeTablet => mediaQueryShortestSide >= 720;

  /// True if the current device is Tablet.
  bool get isTablet => isSmallTablet || isLargeTablet;
}

extension NavigatorExt on BuildContext {
  Future<T?> push<T>(Route<T> route) => Navigator.push(this, route);

  void pop<T extends Object>([T? result]) => Navigator.pop(this, result);

  Future<T?> pushNamed<T>(String routeName, {Object? arguments}) =>
      Navigator.pushNamed<T?>(this, routeName, arguments: arguments);

  bool canPop() => Navigator.canPop(this);

  void popUntil(RoutePredicate predicate) =>
      Navigator.popUntil(this, predicate);
}

extension ThemeExt on BuildContext {
  ThemeData get theme => Theme.of(this);

  TextTheme get textTheme => Theme.of(this).textTheme;

  TextTheme get primaryTextTheme => Theme.of(this).primaryTextTheme;

  BottomAppBarThemeData get bottomAppBarTheme => Theme.of(this).bottomAppBarTheme;

  BottomSheetThemeData get bottomSheetTheme => Theme.of(this).bottomSheetTheme;

  Color get backgroundColor => Theme.of(this).colorScheme.surface;

  Color get primaryColor => Theme.of(this).primaryColor;

  Color get scaffoldBackgroundColor => Theme.of(this).scaffoldBackgroundColor;

  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  AppBarThemeData get appBarTheme => Theme.of(this).appBarTheme;

  TargetPlatform get platform => Theme.of(this).platform;

  bool get isAndroid => platform == TargetPlatform.android;

  bool get isIOS => platform == TargetPlatform.iOS;

  bool get isMacOS => platform == TargetPlatform.macOS;

  bool get isWindows => platform == TargetPlatform.windows;

  bool get isFuchsia => platform == TargetPlatform.fuchsia;

  bool get isLinux => platform == TargetPlatform.linux;
}

extension ScaffoldExt on BuildContext {
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(
    SnackBar snackbar,
  ) =>
      ScaffoldMessenger.of(this).showSnackBar(snackbar);

  void removeCurrentSnackBar({
    SnackBarClosedReason reason = SnackBarClosedReason.remove,
  }) =>
      ScaffoldMessenger.of(this).removeCurrentSnackBar(reason: reason);

  void hideCurrentSnackBar({
    SnackBarClosedReason reason = SnackBarClosedReason.hide,
  }) =>
      ScaffoldMessenger.of(this).hideCurrentSnackBar(reason: reason);

  void openDrawer() => Scaffold.of(this).openDrawer();

  void openEndDrawer() => Scaffold.of(this).openEndDrawer();

  PersistentBottomSheetController showBottomSheet(
    WidgetBuilder builder, {
    Color? backgroundColor,
    double? elevation,
    ShapeBorder? shape,
    Clip? clipBehaviour,
  }) =>
      Scaffold.of(this).showBottomSheet(
        builder,
        backgroundColor: backgroundColor,
        elevation: elevation,
        shape: shape,
        clipBehavior: clipBehaviour,
      );
}

class _Form {
  final BuildContext _context;

  _Form(this._context);

  bool validate() => Form.of(_context).validate();
  void reset() => Form.of(_context).reset();
  void save() => Form.of(_context).save();
}

extension FormExt on BuildContext {
  _Form get form => _Form(this);
}

class _FocusScope {
  final BuildContext _context;

  bool get hasFocus => _node().hasFocus;

  bool get isFirstFocus => _node().isFirstFocus;

  bool get hasPrimaryFocus => _node().hasPrimaryFocus;

  bool get canRequestFocus => _node().canRequestFocus;

  const _FocusScope(this._context);

  void nextFocus() => _node().nextFocus();

  void requestFocus([FocusNode? node]) => _node().requestFocus(node);

  void previousFocus() => _node().previousFocus();

  void unfocus({UnfocusDisposition disposition = UnfocusDisposition.scope}) =>
      _node().unfocus(disposition: disposition);

  void setFirstFocus(FocusScopeNode scope) => _node().setFirstFocus(scope);

  bool consumeKeyboardToken() => _node().consumeKeyboardToken();
  FocusScopeNode _node() => FocusScope.of(_context);
}

extension FocusScopeExt on BuildContext {
  _FocusScope get focusScope => _FocusScope(this);

  void closeKeyboard() => focusScope.requestFocus(FocusNode());
}

extension ModalRouteExt<T> on BuildContext {
  ModalRoute<T>? get modalRoute => ModalRoute.of<T>(this);

  RouteSettings? get routeSettings => modalRoute?.settings;
}
