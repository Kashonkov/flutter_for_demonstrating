import 'package:common/utils/string_utils.dart';
import 'package:domain_core/domain/entity/incident_item_entity.dart';
import 'package:flutter/material.dart';
import 'package:shipment/domain/entity/route_point_entity.dart';
import 'package:shipment/l10n/localization_extension.dart';
import 'package:ui_kit/button/rf_button.dart';
import 'package:ui_kit/index.dart';

typedef OnOpenIncidentTap = Function(IncidentEntity incident);

class PointMenu extends StatelessWidget {
  final RoutePointEntity point;
  final OnOpenIncidentTap onOpenIncidentTap;

  const PointMenu({super.key, required this.point, required this.onOpenIncidentTap});

  @override
  Widget build(BuildContext context) {
    final p = point;
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.symmetric(horizontal: 8),
      constraints: BoxConstraints(maxWidth: 256),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
      ),
      child: switch (p) {
        OriginPointEntity() => _OriginPointMenu(point: p),
        DestinationPointEntity() => _DestinationPointMenu(point: p),
        IncidentPointEntity() => _IncidentMenu(point: p, onOpenIncidentTap: onOpenIncidentTap),
        WaypointEntity() => _WaypointMenu(point: p),
        CurrentPointEntity() => _CurrentPointMenu(point: p),
      },
    );
  }
}

class _WaypointMenu extends StatelessWidget {
  final WaypointEntity point;

  const _WaypointMenu({super.key, required this.point});

  @override
  Widget build(BuildContext context) {
    bool showClusterInfo = point.count > 1;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: 4,
      children: [
        _PointProperty(title: context.loc.lat, value: point.position.latitude.toString()),
        _PointProperty(title: context.loc.ln, value: point.position.longitude.toString()),
        _PointProperty(title: context.loc.date, value: point.position.time.format()),
        if (point.speed != null)
          _PointProperty(title: context.loc.speed, value: point.speed?.toString() ?? ""),
        if (showClusterInfo) ...[
          _PointProperty(title: context.loc.enteredDate, value: point.enteredAt.format()),
          _PointProperty(title: context.loc.leftDate, value: point.leftAt.format()),
          _PointProperty(
            title: context.loc.range,
            value: "${(point.rangeInMeters / 1609).toStringAsFixed(2)} mi",
          ),
          _PointProperty(title: context.loc.entrance, value: point.count.toString()),
        ],
      ],
    );
  }
}

class _IncidentMenu extends StatelessWidget {
  final IncidentPointEntity point;
  final OnOpenIncidentTap onOpenIncidentTap;

  const _IncidentMenu({super.key, required this.point, required this.onOpenIncidentTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [
        Align(alignment: Alignment.center, child: Text(context.loc.incident, style: context.rfTextTheme().body1)),
        Gap(0),
        _PointProperty(title: context.loc.lat, value: point.position.latitude.toString()),
        _PointProperty(title: context.loc.ln, value: point.position.longitude.toString()),
        _PointProperty(title: context.loc.date, value: point.position.time.format()),
        _PointProperty(title: context.loc.incident, value: point.incident.description),
        Gap(0),
        RfButton(
          type: ButtonType.textButton,
          title: context.loc.openIncident,
          textStyle: TextStyle().copyWith(color: Colors.red),
          onPressed: () {
            onOpenIncidentTap(point.incident);
          },
        ),
      ],
    );
  }
}

class _DestinationPointMenu extends StatelessWidget {
  final RoutePointEntity point;

  const _DestinationPointMenu({super.key, required this.point});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: 4,
      children: [
        Align(alignment: Alignment.center, child: Text(context.loc.destination, style: context.rfTextTheme().body1)),
        Gap(0),
        _PointProperty(title: context.loc.lat, value: point.position.latitude.toString()),
        _PointProperty(title: context.loc.ln, value: point.position.longitude.toString()),
        _PointProperty(title: context.loc.date, value: point.position.time.format()),
      ],
    );
  }
}

class _OriginPointMenu extends StatelessWidget {
  final RoutePointEntity point;

  const _OriginPointMenu({super.key, required this.point});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [
        Align(alignment: Alignment.center, child: Text(context.loc.origin, style: context.rfTextTheme().body1,)),
        Gap(0),
        _PointProperty(title: context.loc.lat, value: point.position.latitude.toString()),
        _PointProperty(title: context.loc.ln, value: point.position.longitude.toString()),
        _PointProperty(title: context.loc.date, value: point.position.time.format()),
      ],
    );
  }
}

class _CurrentPointMenu extends StatelessWidget {
  final CurrentPointEntity point;

  const _CurrentPointMenu({super.key, required this.point});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [
        _PointProperty(title: context.loc.lat, value: point.position.latitude.toString()),
        _PointProperty(title: context.loc.ln, value: point.position.longitude.toString()),
        _PointProperty(title: context.loc.date, value: point.position.time.format()),
        if (point.speed != null)
          _PointProperty(title: context.loc.speed, value: point.speed?.toString() ?? ""),
      ],
    );
  }
}

class _PointProperty extends StatelessWidget {
  final String title;
  final String value;

  const _PointProperty({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("$title:", style: context.rfTextTheme().body2Variant.copyWith(color: Color(0x80000000)),),
        Gap(4),
        Flexible(child: Text(value, style: context.rfTextTheme().body2Variant)),
      ],
    );
  }
}
