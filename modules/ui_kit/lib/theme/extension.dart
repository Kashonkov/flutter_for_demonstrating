import 'package:common/exception/build_context_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:ui_kit/theme/text_theme.dart';

extension ContextTHemeExtension on BuildContext{
  TextThemeExtension rfTextTheme() => theme.extension<TextThemeExtension>()!;
}