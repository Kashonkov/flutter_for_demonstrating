// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'incident_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class IncidentLocalizationsEn extends IncidentLocalizations {
  IncidentLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get incidents => 'Incidents';

  @override
  String get openShipment => 'Open shipment page';

  @override
  String get company => 'Company';

  @override
  String get download => 'Download';

  @override
  String get share => 'Share';

  @override
  String locationChanged(String position) {
    return 'Location has changed $position';
  }

  @override
  String shipment(String title) {
    return 'Shipment $title';
  }

  @override
  String coordinates(double lat, double long) {
    return '$lat, $long';
  }

  @override
  String accuracy(String value) {
    return '(±${value}km)';
  }
}
