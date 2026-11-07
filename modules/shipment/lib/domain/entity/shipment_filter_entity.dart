import 'package:equatable/equatable.dart';
import 'package:shipment/domain/entity/date_range.dart';
import 'package:shipment/domain/entity/delivery_status.dart';
import 'package:shipment/domain/entity/filter_shipment_status.dart';

final class ShipmentFilterEntity extends Equatable {
  final String? query;
  final FilterShipmentStatus? status;
  final DateRange? range;
  final List<DeliveryStatus>? deliveryStatuses;

  const ShipmentFilterEntity({this.query, this.status, this.range, this.deliveryStatuses});

  @override
  List<Object?> get props => [query, status, range, deliveryStatuses];
}
