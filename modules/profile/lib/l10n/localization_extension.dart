import 'package:flutter/material.dart';
import 'package:profile/l10n/profile_localizations.dart';

extension LocalizedBuildContext on BuildContext {
  ProfileLocalizations get loc => ProfileLocalizations.of(this);
}
