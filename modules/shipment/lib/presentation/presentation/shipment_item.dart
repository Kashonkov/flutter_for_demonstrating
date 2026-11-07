import 'package:common/exception/build_context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:shipment/domain/entity/connection_status.dart';
import 'package:shipment/domain/entity/delivery_status.dart';
import 'package:shipment/l10n/localization_extension.dart';
import 'package:shipment/presentation/presentation/shipment_item_model.dart';
import 'package:ui_kit/gps/gps_indicator.dart';
import 'package:ui_kit/index.dart';

class ShipmentItem extends StatelessWidget {
  final ShipmentItemModel shipment;

  const ShipmentItem({super.key, required this.shipment});

  @override
  Widget build(BuildContext context) {
    return RfCard(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(shipment.title, style: context.rfTextTheme().body1Variant),
                      Gap(8),
                      shipment.gpsStatus == ConnectionStatus.online
                          ? GpsIndicator()
                          : InactiveGpsIndicator(),
                      Spacer(),
                      _TransitStatusWidget(status: shipment.deliveryStatus),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "${shipment.positionTime}${shipment.positionTitle.isEmpty ? '' : '| ${shipment.positionTitle}'}",
                        style: context.rfTextTheme().body2,
                      ),
                      Spacer(),
                      //TODO - change to problem icon
                      if (shipment.hasIncidents)
                        Container(
                          height: 16,
                          width: 22,
                          decoration: BoxDecoration(color: Color(0xFFF2F2F2), borderRadius: BorderRadius.circular(6)),
                          child: Icon(Icons.warning, size: 14, color: Color(0xFF000000).withAlpha(127),),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TransitStatusWidget extends StatelessWidget {
  final DeliveryStatus status;

  const _TransitStatusWidget({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(color: _mapColor(), borderRadius: BorderRadius.circular(16)),
      child: Text(
        _mapStatus(context),
        style: context.rfTextTheme().body3.copyWith(color: _mapTextColor()),
      ),
    );
  }

  String _mapStatus(BuildContext context) {
    return switch (status) {
      DeliveryStatus.transit => context.loc.transit,
      DeliveryStatus.delivered => context.loc.delivered,
      DeliveryStatus.undefined => "",
    };
  }

  Color _mapColor() {
    return switch (status) {
      DeliveryStatus.transit => Color(0x372196F3),
      DeliveryStatus.delivered => Colors.green,
      DeliveryStatus.undefined => Colors.grey,
    };
  }

  Color _mapTextColor() {
    return switch (status) {
      DeliveryStatus.transit => Color(0xFF2196F3),
      DeliveryStatus.delivered => Colors.white,
      DeliveryStatus.undefined => Colors.grey,
    };
  }
}
