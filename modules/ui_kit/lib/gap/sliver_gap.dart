part of 'gap.dart';

/// Sliver, занимающий фиксированное количество места.
/// Смотрите также:
/// * [Gap], версия этого виджета в окне рендеринга.
class SliverGap extends LeafRenderObjectWidget {
  /// Создает Sliver, который занимает фиксированное [mainAxisExtent] пространство.
  ///
  /// [mainAxisExtent] не должен быть нулевым и должен быть положительным.
  const SliverGap(
    this.mainAxisExtent, {
    Key? key,
    this.color,
  })  : assert(mainAxisExtent >= 0 && mainAxisExtent < double.infinity),
        super(key: key);

  /// Количество места, которое этот виджет занимает в направлении родителя.
  ///
  /// Не должно быть нулевым и должно быть положительным.
  final double mainAxisExtent;

  /// Цвет, используемый для заполнения пробела.
  final Color? color;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderSliverGap(
      mainAxisExtent: mainAxisExtent,
      color: color,
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderSliverGap renderObject) {
    renderObject
      ..mainAxisExtent = mainAxisExtent
      ..color = color;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('mainAxisExtent', mainAxisExtent));
    properties.add(ColorProperty('color', color));
  }
}

class RenderSliverGap extends RenderSliver {
  RenderSliverGap({
    required double mainAxisExtent,
    Color? color,
  })  : _mainAxisExtent = mainAxisExtent,
        _color = color;

  double get mainAxisExtent => _mainAxisExtent;
  double _mainAxisExtent;

  set mainAxisExtent(double value) {
    if (_mainAxisExtent != value) {
      _mainAxisExtent = value;
      markNeedsLayout();
    }
  }

  Color? get color => _color;
  Color? _color;

  set color(Color? value) {
    if (_color != value) {
      _color = value;
      markNeedsPaint();
    }
  }

  @override
  void performLayout() {
    final double paintExtent = calculatePaintOffset(
      constraints,
      from: 0,
      to: mainAxisExtent,
    );
    final double cacheExtent = calculateCacheOffset(
      constraints,
      from: 0,
      to: mainAxisExtent,
    );

    assert(paintExtent.isFinite);
    assert(paintExtent >= 0.0);
    geometry = SliverGeometry(
      scrollExtent: mainAxisExtent,
      paintExtent: paintExtent,
      cacheExtent: cacheExtent,
      maxPaintExtent: mainAxisExtent,
      hitTestExtent: paintExtent,
      hasVisualOverflow: mainAxisExtent > constraints.remainingPaintExtent || constraints.scrollOffset > 0.0,
    );
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (color != null) {
      final Paint paint = Paint()..color = color!;
      final Size size = constraints
          .asBoxConstraints(
            minExtent: geometry!.paintExtent,
            maxExtent: geometry!.paintExtent,
          )
          .constrain(Size.zero);
      context.canvas.drawRect(offset & size, paint);
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('mainAxisExtent', mainAxisExtent));
    properties.add(ColorProperty('color', color));
  }
}
