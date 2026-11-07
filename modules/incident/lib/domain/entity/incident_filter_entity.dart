import 'package:equatable/equatable.dart';
import 'package:shipment/domain/entity/date_range.dart';
import 'package:shipment/domain/entity/delivery_status.dart';
import 'package:shipment/domain/entity/filter_shipment_status.dart';

final class IncidentFilterEntity extends Equatable {
  final String? query;

  const IncidentFilterEntity({this.query});

  @override
  List<Object?> get props => [query];
}
