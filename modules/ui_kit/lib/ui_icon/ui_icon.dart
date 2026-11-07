import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum UiIconSize { xsmall, small, medium, large }

extension UiIconSizeExtension on UiIconSize {
  double get dimension {
    return switch (this) {
      UiIconSize.xsmall => 12.0,
      UiIconSize.small => 18.0,
      UiIconSize.medium => 24.0,
      UiIconSize.large => 32.0,
    };
  }
}

/// Виджет отображения корпоративных иконок
class UiIcon extends StatelessWidget {
  const UiIcon(
    this.assetPath, {
    super.key,
    this.color,
    this.height,
    this.width,
    this.packageOverride,
    this.box,
    this.fit = BoxFit.contain,
    this.size = UiIconSize.medium,
    this.showIndicator = false,
  });

  /// путь до иконки из файла ui_kit/resources/ui_assets.dart - используем класс [UiAssets]
  final String assetPath;

  /// кастомный цвет иконки взамен дефолтного
  final Color? color;

  /// кастомная высота иконки
  final double? height;

  /// Кастомная ширина иконки
  final double? width;

  /// Если нужно использовать [assetPath] из внешнего модуля, когда файл изображения находится вне UI Kit.
  final String? packageOverride;

  /// поведение встраивания иконки в родительский блок
  final BoxFit fit;

  /// Относительный размер иконки
  final UiIconSize size;

  /// Флаг указывает будет ли отображаться индикатор на иконке
  final bool showIndicator;

  /// Одинаковые значения для ширины и высоты
  final double? box;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      assetPath,
      colorFilter: color != null ? ColorFilter.mode(color ?? Colors.black, BlendMode.srcIn) : null,
      width: box ?? width ?? size.dimension,
      height: box ?? height ?? size.dimension,
      fit: fit,
    );
  }
}
