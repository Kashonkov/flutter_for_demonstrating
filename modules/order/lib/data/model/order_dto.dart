import 'package:json_annotation/json_annotation.dart';
import 'package:order/data/model/converter/order_status_converter.dart';
import 'package:order/domain/entity/order_entity.dart';
import 'package:order/domain/entity/order_status.dart';

part 'order_dto.g.dart';

@JsonSerializable(createToJson: false)
class OrderDto {
  final String id;
  final String sealColor;
  final String cableLength;
  final String logo;
  final String companyName;
  final String contactName;
  final String email;
  final String phone;
  final String billingAddress;
  final String deliveryAddress;
  final String? instructions;
  final int amount;
  @OrderStatusConverter()
  final OrderStatus state;
  final String ownerId;
  final DateTime createdAt;
  final DateTime updatedAt;

  OrderDto({
    required this.id,
    required this.sealColor,
    required this.cableLength,
    required this.logo,
    required this.companyName,
    required this.contactName,
    required this.email,
    required this.phone,
    required this.billingAddress,
    required this.deliveryAddress,
    this.instructions,
    required this.amount,
    required this.state,
    required this.ownerId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrderDto.fromJson(Map<String, dynamic> json) => _$OrderDtoFromJson(json);

  OrderEntity toEntity() => OrderEntity(
    id: id,
    orderStatus: state,
    sealColor: sealColor,
    orderDate: createdAt,
    sealType: cableLength,
    logo: logo,
    amount: amount,
  );
}
