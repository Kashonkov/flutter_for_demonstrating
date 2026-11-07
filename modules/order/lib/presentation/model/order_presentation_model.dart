import 'package:order/domain/entity/order_status.dart';

sealed class OrderListPresentationModel {}

final class TodayPresentationModel extends OrderListPresentationModel {}

final class YesterdayPresentationModel extends OrderListPresentationModel {}

final class DatePresentationModel extends OrderListPresentationModel {
  final String date;

  DatePresentationModel({required this.date});
}

final class OrderPresentationModel extends OrderListPresentationModel {
  final String orderNumber;
  final OrderStatus orderStatus;
  final String? sealType;
  final String? sealColor;
  final String? logo;
  final int amount;
  // final String price;
  // final String? sealNumbers;

  OrderPresentationModel({
    required this.orderNumber,
    required this.orderStatus,
    this.sealType,
    this.sealColor,
    this.logo,
    required this.amount,
    // required this.price,
    // this.sealNumbers,
  });
}
