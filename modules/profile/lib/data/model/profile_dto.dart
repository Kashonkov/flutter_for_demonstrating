import 'dart:math';

import 'package:json_annotation/json_annotation.dart';
import 'package:profile/domain/entity/profile_entity.dart';

part 'profile_dto.g.dart';

@JsonSerializable(includeIfNull: false)
final class ProfileDto {
  final String id;
  final String username;
  final String name;
  final String? phone;
  final String email;
  final String? companyName;

  ProfileDto({
    required this.id,
    required this.username,
    required this.name,
    required this.phone,
    required this.email,
    required this.companyName,
  });

  factory ProfileDto.fromJson(Map<String, dynamic> json) => _$ProfileDtoFromJson(json);

  factory ProfileDto.fromEntity(ProfileEntity entity) => ProfileDto(
    id: entity.id,
    username: entity.name,
    name: entity.name,
    phone: entity.phone,
    email: entity.email,
    companyName: entity.company,
  );

  Map<String, dynamic> toJson() => _$ProfileDtoToJson(this);

  ProfileEntity toEntity() =>
      ProfileEntity(id: id, name: name, phone: phone, email: email, company: companyName ?? "");
}
