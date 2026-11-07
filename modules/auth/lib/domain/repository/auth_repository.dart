import 'package:auth/domain/entity/auth_info_entity.dart';

abstract interface class AuthRepository {
  Future<AuthInfoEntity> login({required String email, required String password});

  Future<AuthInfoEntity> refresh({required String refreshToken});
}
