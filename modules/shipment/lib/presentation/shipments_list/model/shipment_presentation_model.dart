import 'package:domain_core/domain/entity/position_entity.dart';
import 'package:shipment/domain/entity/connection_status.dart';
import 'package:shipment/domain/entity/delivery_status.dart';
import 'package:shipment/presentation/presentation/shipment_item_model.dart';

sealed class ShipmentItemPresentationModel {}

final class TodayPresentationModel extends ShipmentItemPresentationModel {}

final class YesterdayPresentationModel extends ShipmentItemPresentationModel {}

final class DatePresentationModel extends ShipmentItemPresentationModel {
  final String date;

  DatePresentationModel({required this.date});
}
final class ShipmentPresentationModel extends ShipmentItemPresentationModel {
  final ShipmentItemModel model;

  ShipmentPresentationModel({required this.model});
}
