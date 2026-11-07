import 'package:auto_route/auto_route.dart';
import 'package:common/exception/build_context_extensions.dart';
import 'package:common/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:shipment/domain/entity/date_range.dart';
import 'package:shipment/l10n/localization_extension.dart';
import 'package:shipment/domain/entity/filter_shipment_status.dart';
import 'package:shipment/presentation/shipment_filter_bottom_sheet/model/shipment_filter.dart';
import 'package:ui_kit/assets/ui_assets.dart';
import 'package:ui_kit/button/rf_button.dart';
import 'package:ui_kit/gap/gap.dart';
import 'package:ui_kit/index.dart';
import 'package:ui_kit/radio/radio_item.dart';
import 'package:ui_kit/text_field/rf_selectsble_text_field.dart';

typedef OnFilterSelected = Function(ShipmentBottomFilters filter);

class FiltersBottomSheet extends StatefulWidget {
  final ShipmentBottomFilters? filter;
  final OnFilterSelected onFilterSelected;

  const FiltersBottomSheet({super.key, this.filter, required this.onFilterSelected});

  @override
  State<FiltersBottomSheet> createState() => _FiltersBottomSheetState();
}

class _FiltersBottomSheetState extends State<FiltersBottomSheet> {
  FilterShipmentStatus? _status;
  DateTimeRange? _range;

  @override
  void initState() {
    super.initState();
    _status = widget.filter?.status;
    final currentRange = widget.filter?.range;
    if (currentRange != null) {
      _range = DateTimeRange(start: currentRange.startDate, end: currentRange.endDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.loc.filters,
          style: context.rfTextTheme().header1,
        ),
        Gap(24),
        _DateRangeFrame(
          initialRange: _range,
          onRangeSelected: (range) {
            setState(() {
              _range = range;
            });
          },
        ),
        Gap(12),
        _StatusFrame(
          status: _status ?? FilterShipmentStatus.all,
          onStatusSelected: (FilterShipmentStatus status) {
            setState(() {
              _status = status;
            });
          },
        ),
        Gap(24),
        Row(
          spacing: 12,
          children: [
            Expanded(
              child: RfButton(
                type: ButtonType.secondary,
                title: context.loc.cancel.toUpperCase(),
                onPressed: () {
                  AutoRouter.of(context).pop();
                },
              ),
            ),
            Expanded(
              child: RfButton(
                title: context.loc.apply.toUpperCase(),
                onPressed: () {
                  final currentRange = _range;
                  DateRange? range;
                  if (currentRange != null) {
                    range = DateRange(startDate: currentRange.start, endDate: currentRange.end);
                  }
                  widget.onFilterSelected(ShipmentBottomFilters(status: _status, range: range));
                  AutoRouter.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

typedef OnRangeSelected = Function(DateTimeRange? range);

class _DateRangeFrame extends StatelessWidget {
  final DateTimeRange? initialRange;
  final OnRangeSelected onRangeSelected;

  const _DateRangeFrame({super.key, this.initialRange, required this.onRangeSelected});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.loc.dateRange, style: context.rfTextTheme().body2,),
        Gap(4),
        RfSelectableTextField(
          text: initialRange != null
              ? "${initialRange?.start.formatDate()} - ${initialRange?.end.formatDate()}"
              : "",
          onTap: () {
            showDateRangePicker(
              context: context,
              firstDate: DateTime.now().subtract(Duration(days: 365 * 5)),
              lastDate: DateTime.now(),
              initialDateRange: initialRange,
            ).then((value) {
              onRangeSelected(value);
            });
          },
          iconPath: UiIcons.calendar,
        ),
      ],
    );
  }
}

typedef OnStatusSelected = Function(FilterShipmentStatus status);

class _StatusFrame extends StatelessWidget {
  final FilterShipmentStatus status;
  final OnStatusSelected onStatusSelected;

  const _StatusFrame({super.key, required this.status, required this.onStatusSelected});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.loc.status, style: context.rfTextTheme().body2,),
        Gap(4),
        SizedBox(
          height: 40,
          child: Row(
            spacing: 40,
            children: [
              RadioItem(
                value: status == FilterShipmentStatus.all,
                title: context.loc.all,
                onTap: () {
                  onStatusSelected(FilterShipmentStatus.all);
                },
              ),
              RadioItem(
                value: status == FilterShipmentStatus.ok,
                title: context.loc.ok,
                onTap: () {
                  onStatusSelected(FilterShipmentStatus.ok);
                },
              ),
              RadioItem(
                value: status == FilterShipmentStatus.hasProblem,
                title: context.loc.hasProblem,
                onTap: () {
                  onStatusSelected(FilterShipmentStatus.hasProblem);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}