import 'package:flutter/material.dart';
import 'package:ui_kit/gap/gap.dart';
import 'package:ui_kit/theme/extension.dart';

class RfTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? label;
  final String? hint;
  final String? error;
  final int? minLines;
  final int? maxLines;
  final Widget? prefix;
  final Widget? suffix;
  final FocusNode? node;
  final bool isEnabled;
  final bool isObscured;
  final double verticalPadding;
  final Color? borderColor;

  const RfTextField({
    super.key,
    required this.controller,
    this.label,
    this.hint,
    this.prefix,
    this.suffix,
    this.error,
    this.node,
    this.isEnabled = true,
    this.minLines,
    this.maxLines = 1,
    this.verticalPadding = 12,
    this.borderColor,
    this.isObscured = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[Text(label ?? "", style: context.rfTextTheme().body2), Gap(4)],
        TextField(
          enabled: isEnabled,
          controller: controller,
          focusNode: node,
          minLines: minLines,
          maxLines: maxLines,
          obscureText: isObscured,
          style: context.rfTextTheme().body1,
          decoration: InputDecoration(
            hint: hint != null
                ? Text(hint ?? "", style: context.rfTextTheme().body1.copyWith(color: Color(0xFF666666)),)
                : null,
            prefixIcon: prefix != null
                ? Padding(padding: EdgeInsetsGeometry.only(left: 12), child: prefix)
                : null,
            suffixIcon: suffix != null
                ? Padding(padding: EdgeInsetsGeometry.only(right: 12), child: suffix)
                : null,
            suffixIconConstraints: BoxConstraints(maxHeight: 24, maxWidth: 36),
            prefixIconConstraints: BoxConstraints(maxHeight: 24, maxWidth: 36),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
            fillColor: isEnabled ? Colors.white : Color(0x80B3B3B3),
            error: error != null ? SizedBox.shrink() : null,
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.red),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: borderColor ?? Color(0xFFB3B3B3)),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Color(0xFF666666)),
            ),
            isDense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: verticalPadding),
            filled: true,
          ),
        ),
        if (error != null) ...[
          Gap(4),
          Text(error ?? "", style: context.rfTextTheme().body2.copyWith(color: Colors.red)),
        ],
      ],
    );
  }
}
