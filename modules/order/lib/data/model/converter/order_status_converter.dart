import 'package:json_annotation/json_annotation.dart';
import 'package:order/domain/entity/order_status.dart';

const _created = "created";
const _paid = "paid";

final class OrderStatusConverter extends JsonConverter<OrderStatus, String> {
  const OrderStatusConverter();

  @override
  OrderStatus fromJson(String json) {
    return switch (json.toLowerCase()) {
      _created => OrderStatus.created,
      _paid => OrderStatus.paid,
      _ => OrderStatus.undefined,
    };
  }

  @override
  String toJson(OrderStatus object) {
    return switch (object) {
      OrderStatus.created => _created,
      OrderStatus.paid => _paid,
      OrderStatus.undefined => "",
    };
  }
}
