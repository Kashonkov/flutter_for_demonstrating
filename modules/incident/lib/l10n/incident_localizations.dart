import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'incident_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of IncidentLocalizations
/// returned by `IncidentLocalizations.of(context)`.
///
/// Applications need to include `IncidentLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/incident_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: IncidentLocalizations.localizationsDelegates,
///   supportedLocales: IncidentLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the IncidentLocalizations.supportedLocales
/// property.
abstract class IncidentLocalizations {
  IncidentLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static IncidentLocalizations of(BuildContext context) {
    return Localizations.of<IncidentLocalizations>(
      context,
      IncidentLocalizations,
    )!;
  }

  static const LocalizationsDelegate<IncidentLocalizations> delegate =
      _IncidentLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// No description provided for @incidents.
  ///
  /// In en, this message translates to:
  /// **'Incidents'**
  String get incidents;

  /// No description provided for @openShipment.
  ///
  /// In en, this message translates to:
  /// **'Open shipment page'**
  String get openShipment;

  /// No description provided for @company.
  ///
  /// In en, this message translates to:
  /// **'Company'**
  String get company;

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @locationChanged.
  ///
  /// In en, this message translates to:
  /// **'Location has changed {position}'**
  String locationChanged(String position);

  /// No description provided for @shipment.
  ///
  /// In en, this message translates to:
  /// **'Shipment {title}'**
  String shipment(String title);

  /// No description provided for @coordinates.
  ///
  /// In en, this message translates to:
  /// **'{lat}, {long}'**
  String coordinates(double lat, double long);

  /// No description provided for @accuracy.
  ///
  /// In en, this message translates to:
  /// **'(±{value}km)'**
  String accuracy(String value);
}

class _IncidentLocalizationsDelegate
    extends LocalizationsDelegate<IncidentLocalizations> {
  const _IncidentLocalizationsDelegate();

  @override
  Future<IncidentLocalizations> load(Locale locale) {
    return SynchronousFuture<IncidentLocalizations>(
      lookupIncidentLocalizations(locale),
    );
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_IncidentLocalizationsDelegate old) => false;
}

IncidentLocalizations lookupIncidentLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return IncidentLocalizationsEn();
  }

  throw FlutterError(
    'IncidentLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
