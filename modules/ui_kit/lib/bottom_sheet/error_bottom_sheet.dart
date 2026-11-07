import 'package:flutter/material.dart';
import 'package:ui_kit/button/rf_button.dart';
import 'package:ui_kit/index.dart';

/// Виджет контента ботом щита при ошибке от сервера
class ErrorBottomSheet extends StatelessWidget {
  const ErrorBottomSheet({
    super.key,
    this.callId,
    required this.title,
    required this.description,
    this.animation,
    required this.buttonText,
    required this.onTap,
    this.onErrorCopyTap,
    this.hasCloseButton = true,
  });

  /// Call-id вызова
  final String? callId;

  /// Колбек на тап по копированию текста ошибки
  final VoidCallback? onErrorCopyTap;

  /// Тайтл ботом щита
  final String title;

  /// Описание проблемы/ошибки
  final String description;

  /// Виджет анимации, как правило Rive animation
  final Widget? animation;

  /// Текст кнопки
  final String buttonText;

  /// Колбек по клику кнопки
  final VoidCallback onTap;

  /// Наличие крестика в углу
  final bool hasCloseButton;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: context.rfTextTheme().header1),
          Gap(16),
          Text(description, style: context.rfTextTheme().body1),
          if (callId != null) ...[Gap(8), Text("$callId")],
          Gap(24),
          RfButton(title: buttonText.toUpperCase(), onPressed: onTap),
        ],
      ),
    );
  }
}
