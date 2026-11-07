import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ui_kit/gap/gap.dart';

Future<T?> showUiModalBottomSheet<T>({
  required BuildContext context,
  required Widget Function(BuildContext) builder,
  Decoration? decoration,
  String? barrierLabel,
  double? elevation,
  ShapeBorder shape = const RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
  ),
  Clip? clipBehavior,
  BoxConstraints? constraints,
  Color? barrierColor = Colors.black54,
  bool isScrollControlled = true,
  bool useRootNavigator = false,
  bool isDismissible = true,
  bool enableDrag = true,
  bool? showDragHandle,
  bool useSafeArea = false,
  ImageFilter? blur,
  RouteSettings? routeSettings,
  AnimationController? transitionAnimationController,
  Offset? anchorPoint,
  Color backgroundColor = Colors.transparent,
}) async => await showModalBottomSheet<T>(
  context: context,
  builder: (context) => ModalContainer(
    blur: blur,
    decoration: decoration,
    child: Builder(builder: builder),
  ),
  barrierLabel: barrierLabel,
  elevation: elevation,
  shape: shape,
  clipBehavior: clipBehavior,
  constraints: constraints,
  barrierColor: barrierColor,
  isScrollControlled: isScrollControlled,
  useRootNavigator: useRootNavigator,
  isDismissible: isDismissible,
  enableDrag: enableDrag,
  showDragHandle: showDragHandle,
  useSafeArea: useSafeArea,
  routeSettings: routeSettings,
  transitionAnimationController: transitionAnimationController,
  anchorPoint: anchorPoint,
  backgroundColor: backgroundColor,
);

class ModalContainer extends StatelessWidget {
  /// контейнер для всех модалок с градиентом в тёмной теме
  const ModalContainer({super.key, required this.child, this.decoration, this.blur});

  final Widget child;

  /// по дефолту BoxDecoration c градиентом для тёмной темы
  final Decoration? decoration;

  final ImageFilter? blur;

  @override
  Widget build(BuildContext context) {
    // final colors = Theme.of(context).extension<UiColors>();

    return BackdropFilter(
      filter: blur ?? ImageFilter.blur(sigmaX: 1, sigmaY: 1),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.07),
              offset: Offset.zero,
              blurRadius: 14,
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: 16 + MediaQuery.of(context).viewPadding.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.grey,
                  ),
                  child: const SizedBox(width: 24, height: 4),
                ),
              ),
              Gap(12),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
