import 'package:common/bloc/bloc.dart';
import 'package:common/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:incident/l10n/localization_extension.dart';
import 'package:incident/presentation/incident_details/bloc/incident_details_cubit.dart';
import 'package:incident/presentation/incident_details/bloc/incident_details_state.dart';
import 'package:incident/presentation/incident_details/incident_map.dart';
import 'package:incident/presentation/incident_details/model/incident_presentation_model.dart';
import 'package:ui_kit/assets/ui_assets.dart';
import 'package:ui_kit/bottom_sheet/draggable_modal_bottom_sheet.dart';
import 'package:ui_kit/button/rf_back_button.dart';
import 'package:ui_kit/button/rf_button.dart';
import 'package:ui_kit/gap/gap.dart';
import 'package:ui_kit/index.dart';
import 'package:ui_kit/l10n/localization_extension.dart';
import 'package:ui_kit/labeled/label_dotted.dart';
import 'package:ui_kit/loading/loading_frame.dart';
import 'package:ui_kit/map/map_widget.dart';
import 'package:ui_kit/ui_icon/ui_icon.dart';

class IncidentDetailsScreenContent extends StatefulWidget {
  const IncidentDetailsScreenContent({super.key});

  @override
  State<IncidentDetailsScreenContent> createState() => _IncidentDetailsScreenContentState();
}

class _IncidentDetailsScreenContentState
    extends StateWithCubit<IncidentDetailsCubit, IncidentDetailsScreenContent> {
  final DraggableScrollableController _sheetController = DraggableScrollableController();
  double _currentExtent = 0.45;

  @override
  void dispose() {
    _sheetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: BlocBuilder<IncidentDetailsCubit, IncidentDetailsState>(
        builder: (context, state) {
          return switch (state) {
            LoadingState() => LoadingFrame(),
            DataState() => Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: MediaQuery.of(context).size.height * (1 - _currentExtent),
                  child: IncidentMap(
                    lat: state.model.incidentInfo.lat,
                    long: state.model.incidentInfo.long,
                    incidentRange: state.model.incidentInfo.incidentMapRange,
                    radiusMeters: state.model.incidentInfo.range?.toDouble(),
                  ),
                ),
                Positioned(top: 60, left: 16, child: RfBackButton()),
                NotificationListener<DraggableScrollableNotification>(
                  onNotification: (notification) {
                    setState(() {
                      _currentExtent = notification.extent;
                    });
                    return true;
                  },
                  child: DraggableScrollableSheet(
                    controller: _sheetController,
                    maxChildSize: 0.45,
                    initialChildSize: 0.45,
                    builder: (context, controller) {
                      return DraggableModalContainer(
                        controller: controller,
                        onDrag: (dy) {
                          final deltaSize = dy / height;
                          final next = (_sheetController.size - deltaSize)
                              .clamp(0.2, 0.45)
                              .toDouble();
                          _sheetController.jumpTo(next);
                        },
                        stickyChild: _IncidentInfoTitleWidget(info: state.model.incidentInfo),
                        child: _IncidentInfoWidget(
                          containerInfo: state.model.containerInfo,
                          onShipmentTap: () => bloc.onOpenShipmentTap(),
                          onDownloadTap: bloc.onDownloadTap,
                          onShareTap: bloc.onShareTap,
                          isShareLoading: state.isShareLoading,
                          isDocumentLoading: state.isDownloadLoading,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          };
        },
      ),
    );
  }
}

class _IncidentInfoTitleWidget extends StatelessWidget {
  final IncidentInfoPresentationModel info;

  const _IncidentInfoTitleWidget({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(info.shipment, style: context.rfTextTheme().header1),
        Gap(16),
        _IncidentLocationWidget(position: info, onMapTap: () {}),
      ],
    );
  }
}

class _IncidentInfoWidget extends StatelessWidget {
  final ContainerInfoPresentationModel containerInfo;
  final VoidCallback onShipmentTap;
  final VoidCallback onDownloadTap;
  final VoidCallback onShareTap;
  final bool isShareLoading;
  final bool isDocumentLoading;

  const _IncidentInfoWidget({
    super.key,
    required this.containerInfo,
    required this.onShipmentTap,
    required this.onDownloadTap,
    required this.onShareTap,
    required this.isShareLoading,
    required this.isDocumentLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Gap(16),
        _ContainerInfo(model: containerInfo),
        Gap(16),
        _IncidentReportOptionsWidget(
          onDownloadTap: onDownloadTap,
          onShareTap: onShareTap,
          isShareLoading: isShareLoading,
          isDocumentLoading: isDocumentLoading,
        ),
        Gap(20),
        RfButton(
          type: ButtonType.textButton,
          title: context.loc.openShipment,
          onPressed: onShipmentTap,
        ),
      ],
    );
  }
}

class _IncidentLocationWidget extends StatelessWidget {
  final VoidCallback onMapTap;
  final IncidentInfoPresentationModel position;

  const _IncidentLocationWidget({super.key, required this.onMapTap, required this.position});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.red.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _IncidentStatusWidget(status: position.status),
                  Text(position.createdDate, style: context.rfTextTheme().body3),
                ],
              ),
              Gap(8),
              Text(position.address, style: context.rfTextTheme().body1),
              Gap(5),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "${context.loc.coordinates(position.lat, position.long)} ${position.accuracy != null ? context.loc.accuracy(position.accuracy?.twoDigits() ?? "") : ""}",
                      style: context.rfTextTheme().body2Variant.copyWith(color: Color(0x80000000)),
                    ),
                  ),
                  // RfButton(
                  //   onPressed: onMapTap,
                  //   type: ButtonType.textButton,
                  //   title: context.commonLoc.onMap,
                  //   isFullWidth: false,
                  //   icon: UiIcon(UiIcons.pin, size: UiIconSize.xsmall),
                  //   textStyle: TextStyle().copyWith(color: Colors.red, fontSize: 12),
                  // ),
                ],
              ),
            ],
          ),
        ),
        if (position.updatedDate != null) ...[
          Gap(4),
          Row(
            children: [
              Icon(Icons.info_outline, size: 12),
              Text(
                context.loc.locationChanged(position.updatedDate ?? ""),
                style: context.rfTextTheme().body3,
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _IncidentStatusWidget extends StatelessWidget {
  final String status;

  const _IncidentStatusWidget({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(16)),
      child: Text(status, style: context.rfTextTheme().body3.copyWith(color: Colors.white)),
    );
  }
}

class _ContainerInfo extends StatelessWidget {
  final ContainerInfoPresentationModel model;

  const _ContainerInfo({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        LabeledValue(label: context.commonLoc.reference, value: model.reference),
        if (model.number.isNotEmpty)
          LabeledValue(label: context.commonLoc.container, value: model.number),
        // LabelDottedValue(label: context.loc.company, value: model.company),
      ],
    );
  }
}

class _IncidentReportOptionsWidget extends StatelessWidget {
  final VoidCallback onDownloadTap;
  final VoidCallback onShareTap;
  final bool isShareLoading;
  final bool isDocumentLoading;

  const _IncidentReportOptionsWidget({
    super.key,
    required this.onDownloadTap,
    required this.onShareTap,
    required this.isShareLoading,
    required this.isDocumentLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _OptionsButton(
            onTap: onDownloadTap,
            title: context.loc.download,
            iconPath: UiIcons.download,
            isLoading: isDocumentLoading,
          ),
        ),
        Gap(12),
        Expanded(
          child: _OptionsButton(
            onTap: onShareTap,
            title: context.loc.share,
            iconPath: UiIcons.upload,
            isLoading: isShareLoading,
          ),
        ),
      ],
    );
  }
}

class _OptionsButton extends StatelessWidget {
  final VoidCallback onTap;
  final String iconPath;
  final String title;
  final bool isLoading;

  const _OptionsButton({
    super.key,
    required this.onTap,
    required this.iconPath,
    required this.title,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        height: 40,
        decoration: BoxDecoration(color: Color(0xFFE5E5E5), borderRadius: BorderRadius.circular(8)),
        alignment: Alignment.center,
        child: isLoading
            ? Align(child: SizedBox(height: 24, width: 24, child: CircularProgressIndicator()))
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  UiIcon(iconPath, size: UiIconSize.small),
                  Gap(8),
                  Text(title, style: context.rfTextTheme().button),
                ],
              ),
      ),
    );
  }
}
