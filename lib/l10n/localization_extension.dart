import 'package:flutter/material.dart';
import 'package:lxe_app/l10n/app_localizations.dart';

extension LocalizedBuildContext on BuildContext {
  AppLocalizations get loc => AppLocalizations.of(this);
}
