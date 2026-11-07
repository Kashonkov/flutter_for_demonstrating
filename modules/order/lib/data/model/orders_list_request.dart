import 'package:json_annotation/json_annotation.dart';

part 'orders_list_request.g.dart';

@JsonSerializable(createFactory: false, includeIfNull: false)
class OrdersListRequest {
  String? query;
  final int page;
  final int pageSize;

  OrdersListRequest({required this.page, required this.pageSize, this.query});

  Map<String, dynamic> toJson() => _$OrdersListRequestToJson(this);
}
