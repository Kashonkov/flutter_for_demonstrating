import 'package:common/exception/build_context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:shipment/l10n/localization_extension.dart';
import 'package:shipment/domain/entity/shipment_status.dart';
import 'package:ui_kit/button/rf_button.dart';
import 'package:ui_kit/gap/gap.dart';
import 'package:ui_kit/index.dart';
import 'package:ui_kit/radio/radio_item.dart';

typedef OnCompleteCallback =
    Function({String? location, required ShipmentStatus status, String? comment});

class CompleteShipmentBottomSheet extends StatefulWidget {
  final String shipmentTitle;
  final VoidCallback onCancelTap;
  final OnCompleteCallback onCompleteTap;

  const CompleteShipmentBottomSheet({
    super.key,
    required this.shipmentTitle,
    required this.onCancelTap,
    required this.onCompleteTap,
  });

  @override
  State<CompleteShipmentBottomSheet> createState() => _CompleteShipmentBottomSheetState();
}

class _CompleteShipmentBottomSheetState extends State<CompleteShipmentBottomSheet> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  ShipmentStatus _status = ShipmentStatus.ok;

  @override
  void dispose() {
    _addressController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${context.loc.complete} ${widget.shipmentTitle}",
          style: context.rfTextTheme().header1,
        ),
        Gap(24),
        RfTextField(
          label: context.loc.location,
          controller: _addressController,
          hint: context.loc.locationAddress,
        ),
        Gap(12),
        Text(context.loc.shipmentStatus, style: context.rfTextTheme().body2),
        Gap(4),
        SizedBox(
          height: 40,
          child: Row(
            children: [
              RadioItem(
                value: _status == ShipmentStatus.ok,
                title: context.loc.ok,
                onTap: () {
                  setState(() {
                    _status = ShipmentStatus.ok;
                  });
                },
              ),
              Gap(40),
              RadioItem(
                value: _status == ShipmentStatus.problem,
                title: context.loc.problem,
                onTap: () {
                  setState(() {
                    _status = ShipmentStatus.problem;
                  });
                },
              ),
            ],
          ),
        ),
        if (_status == ShipmentStatus.problem) ...[
          Gap(12),
          RfTextField(
            controller: _commentController,
            label: context.loc.comment,
            hint: context.loc.problemComment,
            minLines: 3,
            maxLines: 3,
          ),
          Gap(24),
        ],
        if (_status == ShipmentStatus.ok) Gap(86),
        Row(
          children: [
            Expanded(
              child: RfButton(
                title: context.loc.cancel.toUpperCase(),
                type: ButtonType.secondary,
                onPressed: widget.onCancelTap,
              ),
            ),
            Gap(12),
            Expanded(
              child: RfButton(
                title: context.loc.complete.toUpperCase(),
                onPressed: () {
                  widget.onCompleteTap(
                    location: _addressController.text,
                    status: _status,
                    comment: _commentController.text,
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
