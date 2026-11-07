import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'shipment_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of ShipmentLocalizations
/// returned by `ShipmentLocalizations.of(context)`.
///
/// Applications need to include `ShipmentLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/shipment_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: ShipmentLocalizations.localizationsDelegates,
///   supportedLocales: ShipmentLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the ShipmentLocalizations.supportedLocales
/// property.
abstract class ShipmentLocalizations {
  ShipmentLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static ShipmentLocalizations of(BuildContext context) {
    return Localizations.of<ShipmentLocalizations>(
      context,
      ShipmentLocalizations,
    )!;
  }

  static const LocalizationsDelegate<ShipmentLocalizations> delegate =
      _ShipmentLocalizationsDelegate();

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

  /// No description provided for @shipments.
  ///
  /// In en, this message translates to:
  /// **'Shipments'**
  String get shipments;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get ok;

  /// No description provided for @cableCut.
  ///
  /// In en, this message translates to:
  /// **'Cable Cut'**
  String get cableCut;

  /// No description provided for @lowBattery.
  ///
  /// In en, this message translates to:
  /// **'Low Battery'**
  String get lowBattery;

  /// No description provided for @deactivated.
  ///
  /// In en, this message translates to:
  /// **'Deactivated'**
  String get deactivated;

  /// No description provided for @mainInfo.
  ///
  /// In en, this message translates to:
  /// **'Main Info'**
  String get mainInfo;

  /// No description provided for @origin.
  ///
  /// In en, this message translates to:
  /// **'Origin'**
  String get origin;

  /// No description provided for @destination.
  ///
  /// In en, this message translates to:
  /// **'Destination'**
  String get destination;

  /// No description provided for @lastLocation.
  ///
  /// In en, this message translates to:
  /// **'Latest location'**
  String get lastLocation;

  /// No description provided for @allTime.
  ///
  /// In en, this message translates to:
  /// **'All time'**
  String get allTime;

  /// No description provided for @distance.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get distance;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @idle.
  ///
  /// In en, this message translates to:
  /// **'Idle'**
  String get idle;

  /// No description provided for @inMotion.
  ///
  /// In en, this message translates to:
  /// **'In motion'**
  String get inMotion;

  /// No description provided for @addToWatchList.
  ///
  /// In en, this message translates to:
  /// **'Add to watchlist'**
  String get addToWatchList;

  /// No description provided for @editName.
  ///
  /// In en, this message translates to:
  /// **'Edit name'**
  String get editName;

  /// No description provided for @complete.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get complete;

  /// No description provided for @transit.
  ///
  /// In en, this message translates to:
  /// **'In transit'**
  String get transit;

  /// No description provided for @delivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get delivered;

  /// No description provided for @filters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filters;

  /// No description provided for @dateRange.
  ///
  /// In en, this message translates to:
  /// **'Day or date range'**
  String get dateRange;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @hasProblem.
  ///
  /// In en, this message translates to:
  /// **'Has problem'**
  String get hasProblem;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'{value} (total)'**
  String total(String value);

  /// No description provided for @seals.
  ///
  /// In en, this message translates to:
  /// **'Seals({count})'**
  String seals(int count);

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @locationAddress.
  ///
  /// In en, this message translates to:
  /// **'Location address'**
  String get locationAddress;

  /// No description provided for @shipmentStatus.
  ///
  /// In en, this message translates to:
  /// **'Shipment status'**
  String get shipmentStatus;

  /// No description provided for @problem.
  ///
  /// In en, this message translates to:
  /// **'Problem'**
  String get problem;

  /// No description provided for @comment.
  ///
  /// In en, this message translates to:
  /// **'Comment'**
  String get comment;

  /// No description provided for @problemComment.
  ///
  /// In en, this message translates to:
  /// **'Comment on the problem'**
  String get problemComment;

  /// No description provided for @lat.
  ///
  /// In en, this message translates to:
  /// **'Lat'**
  String get lat;

  /// No description provided for @ln.
  ///
  /// In en, this message translates to:
  /// **'Ln'**
  String get ln;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @speed.
  ///
  /// In en, this message translates to:
  /// **'Speed'**
  String get speed;

  /// No description provided for @enteredDate.
  ///
  /// In en, this message translates to:
  /// **'Entered date'**
  String get enteredDate;

  /// No description provided for @leftDate.
  ///
  /// In en, this message translates to:
  /// **'Left date'**
  String get leftDate;

  /// No description provided for @range.
  ///
  /// In en, this message translates to:
  /// **'Range'**
  String get range;

  /// No description provided for @entrance.
  ///
  /// In en, this message translates to:
  /// **'GPS fixes'**
  String get entrance;

  /// No description provided for @incident.
  ///
  /// In en, this message translates to:
  /// **'Incident'**
  String get incident;

  /// No description provided for @openIncident.
  ///
  /// In en, this message translates to:
  /// **'Open incident page'**
  String get openIncident;
}

class _ShipmentLocalizationsDelegate
    extends LocalizationsDelegate<ShipmentLocalizations> {
  const _ShipmentLocalizationsDelegate();

  @override
  Future<ShipmentLocalizations> load(Locale locale) {
    return SynchronousFuture<ShipmentLocalizations>(
      lookupShipmentLocalizations(locale),
    );
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_ShipmentLocalizationsDelegate old) => false;
}

ShipmentLocalizations lookupShipmentLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return ShipmentLocalizationsEn();
  }

  throw FlutterError(
    'ShipmentLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
