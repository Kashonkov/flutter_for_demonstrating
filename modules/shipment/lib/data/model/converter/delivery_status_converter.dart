import 'package:json_annotation/json_annotation.dart';
import 'package:shipment/domain/entity/delivery_status.dart';

const _transit = "transit";
const _delivered = "delivered";

final class DeliveryStatusConverter extends JsonConverter<DeliveryStatus, String> {
  const DeliveryStatusConverter();

  @override
  DeliveryStatus fromJson(String json) {
    return switch (json) {
      _transit => DeliveryStatus.transit,
      _delivered => DeliveryStatus.delivered,
      _ => DeliveryStatus.undefined,
    };
  }

  @override
  String toJson(DeliveryStatus object) {
    return switch (object) {
      DeliveryStatus.transit => _transit,
      DeliveryStatus.delivered => _delivered,
      DeliveryStatus.undefined => "",
    };
  }
}
