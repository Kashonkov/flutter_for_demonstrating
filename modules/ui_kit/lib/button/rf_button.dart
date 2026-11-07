import 'package:flutter/material.dart';
import 'package:ui_kit/gap/gap.dart';
import 'package:ui_kit/index.dart';

enum ButtonSize { small, medium, large }

extension ButtonSizeExtension on ButtonSize {
  double get height {
    switch (this) {
      case ButtonSize.large:
        return 48.0;
      case ButtonSize.medium:
        return 40.0;
      case ButtonSize.small:
        return 32.0;
    }
  }

  double get width => double.infinity;

  /// Размер лоадера
  // UiLoaderSize get loaderSize => switch (this) {
  //   UiButtonSize.large => UiLoaderSize.large,
  //   UiButtonSize.medium => UiLoaderSize.small,
  //   UiButtonSize.small => UiLoaderSize.small,
  // };

  /// Стили текста в зависимости от размера кнопки
  // TextStyle getTextStyle(TextThemeExtension textTheme) => switch (this) {

  /// Кастомная высота для центрирования текста по вертикали
  double get textHeight => switch (this) {
    ButtonSize.small || ButtonSize.medium => 1,
    ButtonSize.large => 1.2,
  };
}

enum ButtonType { primary, secondary, textButton }

// enum UiButtonState { base, active, loading }
enum ButtonState { base, active }

// Snippet использования виджета
/// ```dart
/// const btn1 = UiButton(
///   isFullWidth: false,
///   title: '+',
///   icon: UiIcon(UiAssets.cart24, color: Colors.white),
/// );
/// const btn2 = Row(
///   children: [
///     UiButton(isInsideRowOrFlex: true, title: 'Base in row, large'),
///     Gap(10),
///     UiButton(isInsideRowOrFlex: true, title: 'Base in row, small', size: UiButtonSize.medium),
///   ],
/// );
/// ```
class RfButton extends StatelessWidget {
  /// Виджет корпоративной кнопки
  const RfButton({
    super.key,
    this.title,
    this.icon,
    this.width,
    this.onPressed,
    this.size = ButtonSize.medium,
    this.type = ButtonType.primary,
    this.state = ButtonState.base,
    this.isInsideRowOrFlex = false,
    this.isFullWidth = true,
    this.customTextColor,
    this.customBackgroundColor,
    this.customPadding,
    this.fontWeight,
    this.textStyle,
    this.customRadius,
  });

  /// Состояние кнопки, active, disabled
  final ButtonState state;

  /// Тип кнопки, primary, secondary, textButton
  final ButtonType type;

  /// Вариант размера кнопки, small, medium, large
  final ButtonSize size;

  /// Текст кнопки
  final String? title;

  /// Виджет иконки для текстовой кнопки
  final Widget? icon;

  /// Кастомная ширина кнопки.
  final double? width;

  /// Действие, которое выполнится по нажатию на кнопку
  final VoidCallback? onPressed;

  /// Флаг отвечающий за то что кнопка внутри Row или Flex
  final bool isInsideRowOrFlex;

  /// Флаг означающий что кнопка по умолчанию занимает всю ширину родителя
  final bool isFullWidth;

  /// Кастомный цвет текста
  final Color? customTextColor;

  /// Кастомный цвет фона кнопки
  final Color? customBackgroundColor;

  /// Кастомный паддинг между контентом кнопки и ее границами
  final EdgeInsets? customPadding;

  /// Болд текста внутри кнопки
  final FontWeight? fontWeight;

  /// Стили текста внутри кнопки
  final TextStyle? textStyle;

  final double? customRadius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // final colors = theme.extension<UiColors>().checkColorsTheme();
    // final textTheme = theme.extension<TextThemeExtension>().checkTextTheme();
    final calcHeight = type == ButtonType.textButton ?  24.0 : size.height;

    Color? foregroundColor;
    Color? backgroundColor;
    Color? borderColor;
    switch (type) {
      case ButtonType.primary:
        foregroundColor = Colors.white;
        // state == UiButtonState.active || state == UiButtonState.loading ? colors.primary : colors.textContrast;
        backgroundColor = Colors.black;
        // state == UiButtonState.active || state == UiButtonState.loading ? colors.primary[50] : colors.primary[700];
        break;
      case ButtonType.secondary:
        foregroundColor = Colors.black;
        backgroundColor = Colors.transparent;
        borderColor = Colors.black;
        break;
      case ButtonType.textButton:
        backgroundColor = Colors.transparent;
        foregroundColor = Colors.black;
        break;
    }

    final widget = ElevatedButton(
      onPressed: onPressed, //state == UiButtonState.loading ? null : onPressed,
      style:
          ElevatedButton.styleFrom(
            alignment: Alignment.center,
            fixedSize: Size.fromHeight(calcHeight),
            padding:
                customPadding ??
                EdgeInsets.symmetric(
                  horizontal: type == ButtonType.textButton ? 0.0 : 16,
                  vertical: .0,
                ),
            elevation: 0,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(customRadius ?? calcHeight),
              side: borderColor != null ? BorderSide(color: borderColor) : BorderSide.none,
            ),
            textStyle:
                textStyle ??
                context.rfTextTheme().button.copyWith(
                  color: customTextColor ?? foregroundColor,
                  fontWeight: fontWeight,
                ),
          ).copyWith(
            backgroundColor: WidgetStateProperty.resolveWith<Color?>(
              (_) => customBackgroundColor ?? backgroundColor,
            ),
            foregroundColor: WidgetStateProperty.resolveWith<Color?>(
              (_) => customTextColor ?? foregroundColor,
            ),
            overlayColor: WidgetStateProperty.all<Color?>(Colors.transparent),
            surfaceTintColor: WidgetStateProperty.resolveWith<Color?>((_) => Colors.transparent),
          ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (icon != null) icon ?? const SizedBox.shrink(),
          if (icon != null && title != null) const Gap(8.0),
          if (title != null) Text(title ?? '', style: textStyle),
        ],
      ),
    );

    return isInsideRowOrFlex
        ? Expanded(
            child: SizedBox(height: calcHeight, width: width, child: widget),
          )
        : icon != null && !isFullWidth || !isFullWidth
        ? IntrinsicWidth(
            child: SizedBox(height: calcHeight, width: width, child: widget),
          )
        : SizedBox(width: isFullWidth ? double.infinity : width, height: calcHeight, child: widget);
  }
}
