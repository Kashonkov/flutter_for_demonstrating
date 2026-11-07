import 'package:common/utils/string_utils.dart';
import 'package:profile/domain/entity/avatar_entity.dart';

final class ProfileEntity {
  final String id;
  final AvatarEntity? avatar;
  final String name;
  final String? phone;
  final String email;
  final String company;

  ProfileEntity({
    required this.id,
    this.avatar,
    required this.name,
    this.phone,
    required this.email,
    required this.company,
  });

  bool isEmpty() {
    return name.isNullOrEmpty() &&
        phone.isNullOrEmpty() &&
        email.isNullOrEmpty() &&
        company.isNullOrEmpty();
  }
}
