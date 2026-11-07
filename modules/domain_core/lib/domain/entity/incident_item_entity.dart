import 'package:domain_core/domain/entity/incident_seal_entity.dart';
import 'package:domain_core/domain/entity/position_entity.dart';

final class IncidentEntity {
  final String id;
  final String shipmentId;
  final DateTime createdDate;
  final DateTime updatedDate;
  final String description;
  final int? accuracyInMeters;
  final PositionEntity position;
  final String? shipmentReference;
  final String? shipmentContainer;
  final List<IncidentSealEntity> seals;

  IncidentEntity({
    required this.id,
    required this.shipmentId,
    required this.createdDate,
    required this.updatedDate,
    required this.description,
    required this.position,
    required this.seals,
    this.shipmentReference,
    this.shipmentContainer,
    this.accuracyInMeters,
  });
}
