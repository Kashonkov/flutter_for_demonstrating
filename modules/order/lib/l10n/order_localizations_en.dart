// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'order_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class OrderLocalizationsEn extends OrderLocalizations {
  OrderLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get orders => 'Orders';

  @override
  String get order => 'Order';

  @override
  String get seals => 'Seals';

  @override
  String get pcs => 'pcs';

  @override
  String get paid => 'Paid';

  @override
  String get created => 'Created';

  @override
  String itemQuantity(int quantity) {
    return '${quantity}pcs';
  }
}
