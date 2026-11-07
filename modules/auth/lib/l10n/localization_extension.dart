import 'package:auth/l10n/auth_localizations.dart';
import 'package:flutter/material.dart';

extension LocalizedBuildContext on BuildContext {
  AuthLocalizations get loc => AuthLocalizations.of(this);
}
