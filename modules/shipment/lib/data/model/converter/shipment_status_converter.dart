import 'package:json_annotation/json_annotation.dart';
import 'package:shipment/domain/entity/connection_status.dart';
import 'package:domain_core/domain/entity/seal_status.dart';
import 'package:shipment/domain/entity/shipment_status.dart';

const _ok = "ok";
const _problem = "problem";

final class ShipmentStatusConverter extends JsonConverter<ShipmentStatus, String> {
  const ShipmentStatusConverter();

  @override
  ShipmentStatus fromJson(String json) {
    return switch (json) {
      _ok => ShipmentStatus.ok,
      _problem => ShipmentStatus.problem,
      _ => ShipmentStatus.ok,
    };
  }

  @override
  String toJson(ShipmentStatus object) {
    return switch (object) {
      ShipmentStatus.ok => _ok,
      ShipmentStatus.problem => _problem,
    };
  }
}