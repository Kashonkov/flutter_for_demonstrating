import 'package:json_annotation/json_annotation.dart';
import 'package:shipment/data/model/shipment_item_dto.dart';

part 'shipments_page_dto.g.dart';

@JsonSerializable(createToJson: false)
class ShipmentsPageDto {
  final List<ShipmentItemDto> items;
  final int page;
  final int pageSize;
  final int totalSize;

  ShipmentsPageDto({
    required this.items,
    required this.page,
    required this.pageSize,
    required this.totalSize,
  });

  factory ShipmentsPageDto.fromJson(Map<String, dynamic> json) => _$ShipmentsPageDtoFromJson(json);
}
