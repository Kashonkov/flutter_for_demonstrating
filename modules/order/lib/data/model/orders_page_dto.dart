import 'package:json_annotation/json_annotation.dart';
import 'package:order/data/model/order_dto.dart';

part 'orders_page_dto.g.dart';

@JsonSerializable(createToJson: false)
class OrdersPageDto {
  final List<OrderDto> items;
  final int page;
  final int pageSize;
  final int totalSize;

  OrdersPageDto({
    required this.items,
    required this.page,
    required this.pageSize,
    required this.totalSize,
  });

  factory OrdersPageDto.fromJson(Map<String, dynamic> json) => _$OrdersPageDtoFromJson(json);
}
