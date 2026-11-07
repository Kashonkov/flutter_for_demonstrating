import 'package:json_annotation/json_annotation.dart';
import 'package:shipment/domain/entity/connection_status.dart';
import 'package:domain_core/domain/entity/seal_status.dart';

const _ok = "ok";
const _cableCut = "cableCut";
const _lowBattery = "lowBattery";
const _deactivated = "deactivated";

final class SealStatusConverter extends JsonConverter<SealStatus, String> {
  const SealStatusConverter();

  @override
  SealStatus fromJson(String json) {
    return switch (json) {
      _ok => SealStatus.ok,
      _cableCut => SealStatus.cableCut,
      _lowBattery => SealStatus.lowBattery,
      _deactivated => SealStatus.deactivated,
      _ => SealStatus.undefined,
    };
  }

  @override
  String toJson(SealStatus object) {
    return switch (object) {
      SealStatus.ok => _ok,
      SealStatus.cableCut => _cableCut,
      SealStatus.lowBattery => _lowBattery,
      SealStatus.deactivated => _deactivated,
      SealStatus.undefined => "",
    };
  }
}