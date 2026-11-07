import 'package:flutter/material.dart';
import 'package:order/l10n/order_localizations.dart';

extension LocalizedBuildContext on BuildContext {
  OrderLocalizations get loc => OrderLocalizations.of(this);
}
