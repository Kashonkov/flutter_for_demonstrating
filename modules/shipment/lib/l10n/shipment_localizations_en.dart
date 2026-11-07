// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'shipment_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class ShipmentLocalizationsEn extends ShipmentLocalizations {
  ShipmentLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get shipments => 'Shipments';

  @override
  String get ok => 'Ok';

  @override
  String get cableCut => 'Cable Cut';

  @override
  String get lowBattery => 'Low Battery';

  @override
  String get deactivated => 'Deactivated';

  @override
  String get mainInfo => 'Main Info';

  @override
  String get origin => 'Origin';

  @override
  String get destination => 'Destination';

  @override
  String get lastLocation => 'Latest location';

  @override
  String get allTime => 'All time';

  @override
  String get distance => 'Distance';

  @override
  String get time => 'Time';

  @override
  String get idle => 'Idle';

  @override
  String get inMotion => 'In motion';

  @override
  String get addToWatchList => 'Add to watchlist';

  @override
  String get editName => 'Edit name';

  @override
  String get complete => 'Complete';

  @override
  String get transit => 'In transit';

  @override
  String get delivered => 'Delivered';

  @override
  String get filters => 'Filters';

  @override
  String get dateRange => 'Day or date range';

  @override
  String get status => 'Status';

  @override
  String get all => 'All';

  @override
  String get hasProblem => 'Has problem';

  @override
  String get cancel => 'Cancel';

  @override
  String get apply => 'Apply';

  @override
  String total(String value) {
    return '$value (total)';
  }

  @override
  String seals(int count) {
    return 'Seals($count)';
  }

  @override
  String get location => 'Location';

  @override
  String get locationAddress => 'Location address';

  @override
  String get shipmentStatus => 'Shipment status';

  @override
  String get problem => 'Problem';

  @override
  String get comment => 'Comment';

  @override
  String get problemComment => 'Comment on the problem';

  @override
  String get lat => 'Lat';

  @override
  String get ln => 'Ln';

  @override
  String get date => 'Date';

  @override
  String get speed => 'Speed';

  @override
  String get enteredDate => 'Entered date';

  @override
  String get leftDate => 'Left date';

  @override
  String get range => 'Range';

  @override
  String get entrance => 'GPS fixes';

  @override
  String get incident => 'Incident';

  @override
  String get openIncident => 'Open incident page';
}
