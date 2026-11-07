import 'package:flutter/material.dart';
import 'package:order/l10n/order_localizations.dart';
import 'package:ui_kit/l10n/common_localizations.dart';

extension LocalizedBuildContext on BuildContext {
  CommonLocalizations get commonLoc => CommonLocalizations.of(this);
}
