import 'package:flutter/material.dart';
import 'package:incident/l10n/incident_localizations.dart';
import 'package:order/l10n/order_localizations.dart';

extension LocalizedBuildContext on BuildContext {
  IncidentLocalizations get loc => IncidentLocalizations.of(this);
}
