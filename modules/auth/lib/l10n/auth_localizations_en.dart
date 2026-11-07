// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'auth_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AuthLocalizationsEn extends AuthLocalizations {
  AuthLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get signInTitle => 'Sign in to your\nAccount';

  @override
  String get enterCreds => 'Enter your email and password to log in';

  @override
  String get invalidCreds => 'Invalid email or password';

  @override
  String get emptyFieldError => 'Must not be empty';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get signIn => 'Sign in';
}
