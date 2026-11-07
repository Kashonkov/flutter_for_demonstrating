import 'package:json_annotation/json_annotation.dart';
import 'package:shipment/data/model/converter/delivery_status_converter.dart';
import 'package:domain_core/data/model/converter/seal_status_converter.dart';
import 'package:shipment/domain/entity/delivery_status.dart';
import 'package:domain_core/domain/entity/seal_status.dart';

part 'active_shipments_request.g.dart';

@JsonSerializable(createFactory: false, includeIfNull: false)
class ActiveShipmentsRequest {
  @SealStatusConverter()
  final List<SealStatus>? sealStatus;

  String? query;

  final DateTime? dateFrom;

  final DateTime? dateTo;

  ActiveShipmentsRequest({
    this.sealStatus,
    this.dateFrom,
    this.dateTo,
    this.query,
  });

  Map<String, dynamic> toJson() => _$ActiveShipmentsRequestToJson(this);
}
