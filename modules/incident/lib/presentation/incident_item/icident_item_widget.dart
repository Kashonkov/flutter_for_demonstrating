import 'package:common/exception/build_context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:incident/l10n/localization_extension.dart';
import 'package:incident/presentation/incident_item/model/incident_presentation_model.dart';
import 'package:ui_kit/index.dart';

class IncidentItem extends StatelessWidget {
  final IncidentPresentationModel incident;
  final VoidCallback onTap;

  const IncidentItem({super.key, required this.incident, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: RfCard(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(incident.shipment, style: context.rfTextTheme().body1),
                Gap(8),
                Expanded(
                  child: Text(
                    incident.description,
                    textAlign: TextAlign.end,
                    style: context.rfTextTheme().body3.copyWith(color: Color(0xB2000000)),
                  ),
                ),
              ],
            ),
            Text(
              "${incident.positionDate}${incident.positionTitle.isEmpty ? '' : '| ${incident.positionTitle}'}",
              style: context.rfTextTheme().body2,
            ),
          ],
        ),
      ),
    );
  }
}
