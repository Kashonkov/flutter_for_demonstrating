import 'package:anchor_ui/anchor_ui.dart';
import 'package:flutter/material.dart';
import 'package:shipment/domain/entity/route_point_entity.dart';
import 'package:shipment/presentation/shipment_details/model/route_model.dart';
import 'package:shipment/presentation/shipment_details/widgets/point_menu.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:ui_kit/index.dart';

typedef OnTimeProgressChanged = Function(double value);

class TimeSlider extends StatefulWidget {
  final OnTimeProgressChanged onTimeProgressChanged;
  final OnOpenIncidentTap onOpenIncidentTap;
  final TimelineModel timeline;
  final bool isFinished;

  const TimeSlider({
    super.key,
    required this.onTimeProgressChanged,
    required this.timeline,
    required this.onOpenIncidentTap,
    this.isFinished = false,
  });

  @override
  State<TimeSlider> createState() => _TimeSliderState();
}

class _TimeSliderState extends State<TimeSlider> {
  double _value = 100;
  final double _pointOffset = 20;

  @override
  Widget build(BuildContext context) {
    final List<LinearWidgetPointer> incidentPointers = widget.timeline.incidentTimelinePoint.map((
      incident,
    ) {
      return LinearWidgetPointer(
        value: incident.timeProgress * 100,
        offset: _pointOffset,
        position: LinearElementPosition.outside,
        child: _IncidentPointer(
          incident: incident.point,
          onOpenIncidentTap: widget.onOpenIncidentTap,
        ),
      );
    }).toList();
    final originTimePoint = widget.timeline.originTimelinePoint;
    final LinearWidgetPointer? origin;
    if (originTimePoint != null) {
      origin = LinearWidgetPointer(
        value: originTimePoint.timeProgress * 100,
        offset: _pointOffset,
        position: LinearElementPosition.outside,
        child: _OriginPointer(point: originTimePoint.point),
      );
    } else {
      origin = null;
    }

    final destinationTimePoint = widget.timeline.destinationTimelinePoint;
    final LinearWidgetPointer? destination;
    if (destinationTimePoint != null) {
      destination = LinearWidgetPointer(
        value: destinationTimePoint.timeProgress * 100,
        offset: _pointOffset,
        position: LinearElementPosition.outside,
        child: _DestinationPointer(point: destinationTimePoint.point),
      );
    } else {
      destination = null;
    }

    final currentTimePoint = widget.timeline.currentTimelinePoint;
    final LinearWidgetPointer? current;
    if (currentTimePoint != null) {
      current = LinearWidgetPointer(
        value: currentTimePoint.timeProgress * 100,
        offset: _pointOffset,
        position: LinearElementPosition.outside,
        child: _CurrentPointer(point: currentTimePoint.point),
      );
    } else {
      current = null;
    }

    return SizedBox(
      width: 90,
      height: widget.isFinished? 370 : 410,
      child: Stack(
        children: [
          Positioned(
            right: 0,
            child: Container(
              width: 48,
              height: widget.isFinished? 370 : 410,
              padding: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(width: 1, color: Colors.black.withAlpha(75)),
                borderRadius: BorderRadius.circular(22),
              ),
            ),
          ),
          Positioned(
            right: 12,
            bottom: 16,
            child: SizedBox(
              height:  widget.isFinished ? 334 : 320,
              child: SfLinearGauge(
                showTicks: false,
                showLabels: false,
                orientation: LinearGaugeOrientation.vertical,
                markerPointers: [
                  if (origin != null) origin,
                  if (destination != null) destination,
                  if (current != null) current,
                  ...incidentPointers,
                  LinearShapePointer(
                    value: _value,
                    position: LinearElementPosition.cross,
                    color: Color(0xFF404040),
                    width: 24,
                    height: 24,
                    shapeType: LinearShapePointerType.circle,
                    onChanged: (value) {
                      setState(() {
                        _value = value;
                        widget.onTimeProgressChanged(value);
                      });
                    },
                  ),
                ],
                barPointers: [
                  LinearBarPointer(
                    value: 100,
                    color: Colors.black.withAlpha(75),
                    thickness: 10,
                    edgeStyle: LinearEdgeStyle.bothCurve,
                  ),
                  LinearBarPointer(
                    value: _value,
                    color: Color(0xFF404040),
                    thickness: 10,
                    edgeStyle: LinearEdgeStyle.bothCurve,
                  ),
                ],
              ),
            ),
          ),
          if (!widget.isFinished) ...[
            Positioned(
              right: 19,
              bottom: 330,
              child: Column(spacing: 8, children: [_Dash(), _Dash(), _Dash()]),
            ),
            Positioned(
                right: 47,
                top: 20,
                child: _DestinationPoint()),
          ],
        ],
      ),
    );
  }
}

class _Dash extends StatelessWidget {
  const _Dash({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(75),
        borderRadius: BorderRadius.circular(4),
      ),
      height: 12,
      width: 10,
    );
  }
}

class _IncidentPointer extends StatelessWidget {
  final IncidentPointEntity incident;
  final OnOpenIncidentTap onOpenIncidentTap;

  const _IncidentPointer({super.key, required this.incident, required this.onOpenIncidentTap});

  @override
  Widget build(BuildContext context) {
    return AnchorPopover(
      child: _PointerContainer(child: Image.asset(UiImages.shield, width: 22, height: 22)),
      overlayBuilder: (context) {
        return PointMenu(point: incident, onOpenIncidentTap: onOpenIncidentTap);
      },
    );
  }
}

class _OriginPointer extends StatelessWidget {
  final OriginPointEntity point;

  const _OriginPointer({super.key, required this.point});

  @override
  Widget build(BuildContext context) {
    return AnchorPopover(
      child: _PointerContainer(child: Image.asset(UiImages.origin, width: 22, height: 22)),
      overlayBuilder: (context) {
        return PointMenu(point: point, onOpenIncidentTap: (_) {});
      },
    );
  }
}

class _DestinationPointer extends StatelessWidget {
  final DestinationPointEntity point;

  const _DestinationPointer({super.key, required this.point});

  @override
  Widget build(BuildContext context) {
    return AnchorPopover(
      child: _DestinationPoint(),
      overlayBuilder: (context) {
        return PointMenu(point: point, onOpenIncidentTap: (_) {});
      },
    );
  }
}

class _CurrentPointer extends StatelessWidget {
  final CurrentPointEntity point;

  const _CurrentPointer({super.key, required this.point});

  @override
  Widget build(BuildContext context) {
    return AnchorPopover(
      child: _PointerContainer(child: Icon(Icons.navigation, size: 22)),
      overlayBuilder: (context) {
        return PointMenu(point: point, onOpenIncidentTap: (_) {});
      },
    );
  }
}

class _DestinationPoint extends StatelessWidget {
  const _DestinationPoint({super.key});

  @override
  Widget build(BuildContext context) {
    return _PointerContainer(child: Image.asset(UiImages.destination, width: 22, height: 22));
  }
}

class _PointerContainer extends StatelessWidget {
  final Widget child;

  const _PointerContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final BorderSide side = BorderSide(width: 1, color: Colors.black.withAlpha(75));
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: side, bottom: side, left: side),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          bottomLeft: Radius.circular(16),
        ),
      ),
      padding: EdgeInsets.all(4),
      child: child,
    );
  }
}
