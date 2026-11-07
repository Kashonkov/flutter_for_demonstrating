import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

part 'max_gap.dart';
part 'raw_gap.dart';
part 'sliver_gap.dart';

// Snippet использования виджета
/// ```dart
/// const gap = Gap(20);
/// const maxGap = MaxGap(20);
/// const sliverGap =  SliverGap(100);
/// ```
class Gap extends StatelessWidget {
  /// Виджет, который занимает фиксированное количество места в направлении своего родителя.
  ///
  /// Он работает только в следующих случаях:
  /// - Это потомок [Row], [Column] или [Flex], а путь от виджета [Gap] до включающего его [Row],
  /// [Column] или [Flex] должен содержать только [StatelessWidget] или [StatefulWidget]
  /// (но не другие виды виджетов, такие как [RenderObjectWidget]).
  /// - Это потомок [Scrollable].
  /// Смотрите также:
  /// * [MaxGap], Виджет, который может занимать не более указанного места.
  /// * [SliverGap], Sliver версия этого виджета.
  /// [mainAxisExtent] не может быть нулевым и должен быть положительным.
  /// [crossAxisExtent] должен быть нулевым или положительным.
  const Gap(
    this.mainAxisExtent, {
    Key? key,
    this.crossAxisExtent,
    this.color,
  })  : assert(mainAxisExtent >= 0 && mainAxisExtent < double.infinity),
        assert(crossAxisExtent == null || crossAxisExtent >= 0),
        super(key: key);

  /// Создает виджет, который занимает фиксированное [mainAxisExtent] пространство в направлении своего родителя
  /// и расширяется в направлении поперечной оси.
  /// [mainAxisExtent] не может быть нулевым и должен быть положительным.
  const Gap.expand(
    double mainAxisExtent, {
    Key? key,
    Color? color,
  }) : this(
          mainAxisExtent,
          key: key,
          crossAxisExtent: double.infinity,
          color: color,
        );

  /// Количество места, которое этот виджет занимает в направлении своего родителя.
  ///
  /// Например:
  /// - Если родителем является [Column], это высота этого виджета.
  /// - Если родителем является [Row], это ширина этого виджета.
  /// Не должно быть нулевым и должно быть положительным.
  final double mainAxisExtent;

  /// Количество места, которое этот виджет занимает в направлении, противоположном родителю.
  /// Например:
  /// - Если родителем является [Столбец], это ширина этого виджета.
  /// - Если родителем является [Строка], это высота этого виджета.
  /// Должен быть положительным или нулевым. Если он равен нулю (по умолчанию), экстент поперечной оси будет таким же,
  /// как ограничения родителя в противоположном направлении.
  final double? crossAxisExtent;

  /// Цвет, используемый для заполнения пробела.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final scrollableState = Scrollable.maybeOf(context);
    final AxisDirection? axisDirection = scrollableState?.axisDirection;
    final Axis? fallbackDirection =
        axisDirection == null ? null : axisDirectionToAxis(axisDirection);

    return RawGap(
      mainAxisExtent,
      crossAxisExtent: crossAxisExtent,
      color: color,
      fallbackDirection: fallbackDirection,
    );
  }
}
