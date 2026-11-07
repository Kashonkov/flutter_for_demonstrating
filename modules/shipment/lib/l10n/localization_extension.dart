import 'package:flutter/material.dart';
import 'package:incident/l10n/incident_localizations.dart';
import 'package:order/l10n/order_localizations.dart';
import 'package:shipment/l10n/shipment_localizations.dart';

extension LocalizedBuildContext on BuildContext {
  ShipmentLocalizations get loc => ShipmentLocalizations.of(this);
}
