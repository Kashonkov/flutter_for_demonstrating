import 'package:equatable/equatable.dart';
import 'package:shipment/domain/entity/date_range.dart';
import 'package:shipment/domain/entity/filter_shipment_status.dart';

final class ShipmentBottomFilters extends Equatable {
  final FilterShipmentStatus? status;
  final DateRange? range;

  const ShipmentBottomFilters({this.status, this.range});

  ShipmentBottomFilters copyWith({String? query, FilterShipmentStatus? status, DateRange? range}) {
    return ShipmentBottomFilters(status: status ?? this.status, range: range ?? this.range);
  }

  @override
  List<Object?> get props => [status, range];
}
