import 'package:domain_core/domain/entity/seal_status.dart';

final class IncidentSealEntity {
  final String id;
  final String number;
  final SealStatus status;

  IncidentSealEntity({required this.id, required this.number, required this.status});
}
