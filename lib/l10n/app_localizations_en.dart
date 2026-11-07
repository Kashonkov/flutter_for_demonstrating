// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get unknownExceptionErrorText => 'Unknown Exception';

  @override
  String get requestError => 'Something went wrong';

  @override
  String get close => 'Close';

  @override
  String get back => 'Back';

  @override
  String get retry => 'Try again';

  @override
  String get shipments => 'Shipments';

  @override
  String get incidents => 'Incidents';

  @override
  String get profile => 'Profile';

  @override
  String get serverError =>
      'Something went wrong on our side. Please try again later.';

  @override
  String get connectionTimeoutError =>
      'The request took too long. Please check your internet connection and try again.';

  @override
  String get connectionError =>
      'A network error occurred. Please check your connection and try again.';
}
