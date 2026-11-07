part of 'gap.dart';

/// Виджет, занимающий не более места в виджете [Row], [Column] или [Flex].
/// Виджет [MaxGap] должен быть потомком [Row], [Column] или [Flex], а путь от виджета [MaxGap]
/// к охватывающим его [Row], [Column] или [Flex ] должен содержать только [StatelessWidget]
/// или [StatefulWidget] (не другие виды виджетов, например [RenderObjectWidget]).
///
/// Смотрите также:
///
/// * [Gap], негибкая версия этого виджета.
class MaxGap extends StatelessWidget {
  /// Создает виджет, который занимает не более указанного [mainAxisExtent]
  /// пространства в виджете [Row], [Column] или [Flex].
  ///
  /// [mainAxisExtent] не должен быть нулевым и должен быть положительным.
  /// [crossAxisExtent] должен быть нулевым или положительным.
  const MaxGap(
    this.mainAxisExtent, {
    Key? key,
    this.crossAxisExtent,
    this.color,
  }) : super(key: key);

  /// Создает виджет, который занимает не более указанного [mainAxisExtent] пространства в виджете [Row],
  /// [Column] или [Flex] и расширяется в направлении поперечной оси.
  /// [mainAxisExtent] не должен быть нулевым и должен быть положительным.
  /// [crossAxisExtent] должен быть нулевым или положительным.
  const MaxGap.expand(
    double mainAxisExtent, {
    Key? key,
    Color? color,
  }) : this(
          mainAxisExtent,
          key: key,
          crossAxisExtent: double.infinity,
          color: color,
        );

  /// Количество места, которое этот виджет занимает в направлении родителя.
  /// Если родителем является [Column], это высота этого виджета.
  /// Если родителем является [Row], это ширина этого виджета.
  /// Не должно быть нулевым и должно быть положительным.
  final double mainAxisExtent;

  /// Количество места, которое этот виджет занимает в направлении, противоположном родителю.
  /// Если родителем является [Столбец], это ширина этого виджета.
  /// Если родителем является [Row], это высота этого виджета.
  /// Должен быть положительным или нулевым.
  /// Если он равен нулю (по умолчанию), экстент поперечной оси будет таким же,
  /// как ограничения родителя в противоположном направлении.
  final double? crossAxisExtent;

  /// Цвет, используемый для заполнения пробела.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: RawGap(
        mainAxisExtent,
        crossAxisExtent: crossAxisExtent,
        color: color,
      ),
    );
  }
}
