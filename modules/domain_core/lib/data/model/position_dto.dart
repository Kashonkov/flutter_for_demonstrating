import 'package:domain_core/domain/entity/position_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'position_dto.g.dart';

@JsonSerializable(createToJson: false)
final class PositionDto {
  final DateTime createdAt;
  final double latitude;
  final double longitude;
  final String? address;

  PositionDto({
    required this.createdAt,
    required this.latitude,
    required this.longitude,
    this.address,
  });

  factory PositionDto.fromJson(Map<String, dynamic> json) => _$PositionDtoFromJson(json);

  PositionEntity toEntity() => PositionEntity(
    time: createdAt,
    title: address ?? "",
    latitude: latitude,
    longitude: longitude,
  );
}
