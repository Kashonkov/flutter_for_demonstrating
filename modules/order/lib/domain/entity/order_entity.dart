import 'package:order/domain/entity/order_status.dart';

final class OrderEntity {
  final String id;
  // final String orderNumber;
  final OrderStatus orderStatus;
  // final DateTime? deliveryDate;
  final DateTime orderDate;
  final String? sealType;
  final String? sealColor;
  final String? logo;
  final int amount;
  // final String price;
  // final List<String>? sealNumbers;

  OrderEntity({
    required this.id,
    // required this.orderNumber,
    required this.orderStatus,
    // this.deliveryDate,
    this.sealType,
    this.sealColor,
    required this.orderDate,
    this.logo,
    required this.amount,
    // required this.price,
    // this.sealNumbers,
  });
}
