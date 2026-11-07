import 'package:json_annotation/json_annotation.dart';
import 'package:shipment/data/model/converter/delivery_status_converter.dart';
import 'package:domain_core/data/model/converter/seal_status_converter.dart';
import 'package:shipment/domain/entity/delivery_status.dart';
import 'package:domain_core/domain/entity/seal_status.dart';

part 'shipment_list_request.g.dart';

@JsonSerializable(createFactory: false, includeIfNull: false)
class ShipmentsListRequest {
  @DeliveryStatusConverter()
  final List<DeliveryStatus>? deliveryStatus;

  @SealStatusConverter()
  final List<SealStatus>? sealStatus;

  String? query;

  final DateTime? dateFrom;

  final DateTime? dateTo;

  final int page;
  final int pageSize;

  ShipmentsListRequest({
    this.deliveryStatus,
    this.sealStatus,
    this.dateFrom,
    this.dateTo,
    this.query,
    required this.page,
    required this.pageSize,
  });

  Map<String, dynamic> toJson() => _$ShipmentsListRequestToJson(this);
}
