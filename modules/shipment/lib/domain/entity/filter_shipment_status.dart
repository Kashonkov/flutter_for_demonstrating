import 'package:domain_core/domain/entity/seal_status.dart';

enum FilterShipmentStatus { all, ok, hasProblem }

extension StatusExtension on FilterShipmentStatus? {
  List<SealStatus>? mapSealStatuses() {
    final status = this;
    if (status == null) return null;
    return switch (status) {
      FilterShipmentStatus.all => null,
      FilterShipmentStatus.ok => [SealStatus.ok],
      FilterShipmentStatus.hasProblem => [
        SealStatus.cableCut,
        SealStatus.deactivated,
        SealStatus.lowBattery,
      ],
    };
  }
}
