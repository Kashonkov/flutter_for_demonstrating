import 'package:flutter/material.dart';

class TextThemeExtension extends ThemeExtension<TextThemeExtension> {
  final TextStyle largeTitle;
  final TextStyle smallTitle;
  final TextStyle header1;
  final TextStyle body1;
  final TextStyle body1Variant;
  final TextStyle subtitle1;
  final TextStyle body2;
  final TextStyle body2Variant;
  final TextStyle body3;
  final TextStyle body4;
  final TextStyle button;
  final TextStyle caption;

  TextThemeExtension({
    required this.largeTitle,
    required this.smallTitle,
    required this.header1,
    required this.body1,
    required this.body1Variant,
    required this.subtitle1,
    required this.body2,
    required this.body2Variant,
    required this.body3,
    required this.body4,
    required this.caption,
    required this.button,
  });

  @override
  ThemeExtension<TextThemeExtension> copyWith({
    TextStyle? largeTitle,
    TextStyle? smallTitle,
    TextStyle? header1,
    TextStyle? body1,
    TextStyle? body1Variant,
    TextStyle? subtitle1,
    TextStyle? body2,
    TextStyle? body2Variant,
    TextStyle? body3,
    TextStyle? body4,
    TextStyle? button,
    TextStyle? caption,
  }) =>
      TextThemeExtension(
        largeTitle: largeTitle ?? this.largeTitle,
        smallTitle: smallTitle ?? this.smallTitle,
        header1: header1 ?? this.header1,
        body1: body1 ?? this.body1,
        body1Variant: body1Variant ?? this.body1Variant,
        subtitle1: subtitle1 ?? this.subtitle1,
        body2: body2 ?? this.body2,
        body2Variant: body2Variant ?? this.body2Variant,
        body3: body3 ?? this.body3,
        body4: body4 ?? this.body4,
        button: button ?? this.button,
        caption: caption ?? this.caption,
      );

  @override
  ThemeExtension<TextThemeExtension> lerp(ThemeExtension<TextThemeExtension>? other, double t) {
    if (other is! TextThemeExtension) {
      return this;
    }
    return TextThemeExtension(
      largeTitle: TextStyle.lerp(largeTitle, other.largeTitle, t) ?? largeTitle,
      smallTitle: TextStyle.lerp(smallTitle, other.smallTitle, t) ?? smallTitle,
      body1: TextStyle.lerp(body1, other.body1, t) ?? body1,
      header1: TextStyle.lerp(header1, other.header1, t) ?? body1,
      body1Variant: TextStyle.lerp(body1Variant, other.body1Variant, t) ?? body1Variant,
      subtitle1: TextStyle.lerp(subtitle1, other.subtitle1, t) ?? subtitle1,
      body2: TextStyle.lerp(body2, other.body2, t) ?? body2,
      body2Variant: TextStyle.lerp(body2Variant, other.body2Variant, t) ?? body2Variant,
      body3: TextStyle.lerp(body3, other.body3, t) ?? body3,
      body4: TextStyle.lerp(body4, other.body4, t) ?? body4,
      caption: TextStyle.lerp(caption, other.caption, t) ?? caption,
      button: TextStyle.lerp(button, other.button, t) ?? button,
    );
  }
}