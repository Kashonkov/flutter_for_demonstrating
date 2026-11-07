import 'package:auth/data/data_source/auth_remote_data_source.dart';
import 'package:auth/domain/entity/auth_info_entity.dart';
import 'package:auth/domain/repository/auth_repository.dart';

final class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;

  AuthRepositoryImpl(this.authRemoteDataSource);

  @override
  Future<AuthInfoEntity> login({required String email, required String password}) =>
      authRemoteDataSource.login(email: email, password: password);

  @override
  Future<AuthInfoEntity> refresh({required String refreshToken}) =>
      authRemoteDataSource.refresh(refreshToken: refreshToken);
}
