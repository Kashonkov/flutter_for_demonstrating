import 'package:api/exception/error_handler.dart';
import 'package:auth/data/api/auth_api.dart';
import 'package:auth/data/model/login_request.dart';
import 'package:auth/data/model/refresh_request.dart';
import 'package:auth/domain/entity/auth_info_entity.dart';

abstract interface class AuthRemoteDataSource {
  Future<AuthInfoEntity> login({required String email, required String password});

  Future<AuthInfoEntity> refresh({required String refreshToken});
}

final class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final AuthApi api;

  AuthRemoteDataSourceImpl(this.api);

  @override
  Future<AuthInfoEntity> login({required String email, required String password}) async {
    final result = await checkNetErrors(
      () => api.login(LoginRequest(login: email, password: password)),
    );
    return result.toEntity();
  }

  @override
  Future<AuthInfoEntity> refresh({required String refreshToken}) async {
    final result = await checkNetErrors(
      () => api.refresh(RefreshRequest(refreshToken: refreshToken)),
    );
    return result.toEntity();
  }
}
