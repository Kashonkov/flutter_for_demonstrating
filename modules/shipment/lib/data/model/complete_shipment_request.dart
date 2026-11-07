import 'package:json_annotation/json_annotation.dart';
import 'package:shipment/data/model/converter/shipment_status_converter.dart';
import 'package:shipment/domain/entity/shipment_status.dart';

part 'complete_shipment_request.g.dart';

@JsonSerializable(createFactory: false, includeIfNull: false)
class CompleteShipmentRequest {
  @ShipmentStatusConverter()
  final ShipmentStatus status;

  final String? customLocation;
  final String? comment;

  CompleteShipmentRequest({required this.status, this.customLocation, this.comment});

  Map<String, dynamic> toJson() => _$CompleteShipmentRequestToJson(this);
}
