import 'package:api/jwt/domain/entity/access_token_info.dart';
import 'package:api/jwt/domain/entity/refresh_token_info.dart';
import 'package:api/jwt/domain/entity/token_pair_info.dart';
import 'package:api/jwt/domain/use_case/force_set_jwt_tokens_use_case.dart';
import 'package:auth/domain/entity/auth_exception.dart';
import 'package:auth/domain/repository/auth_repository.dart';
import 'package:common/index.dart';

final class LoginUseCase extends UseCase<EmptyUseCaseResult, LoginUseCaseParams> {
  final AuthRepository repository;
  final ForceSetJwtTokensUseCase setTokenUseCase;

  LoginUseCase(this.repository, this.setTokenUseCase);

  @override
  Future<UseCaseResult<EmptyUseCaseResult>> call(LoginUseCaseParams params) => innerCall(() async {
    final email = params.email;
    _validateEmail(email);

    final password = params.password;
    _validatePassword(password);

    final authInfo = await repository.login(email: email, password: password);

    final setTokensResult = await setTokenUseCase(
      TokenPairInfo(
        accessToken: AccessTokenInfo(token: authInfo.token, expiredInSeconds: authInfo.expiresIn),
        refreshToken: RefreshTokenInfo(token: authInfo.refreshToken, expiredInDate: DateTime.now().add(Duration(days: 28))),
      ),
    );

    if (!setTokensResult.isSuccessful) {
      throw setTokensResult.exception;
    }

    return EmptyUseCaseResult();
  });

  void _validateEmail(String email) {
    if (email.trim().isEmpty) {
      throw EmptyEmailException();
    }
  }

  void _validatePassword(String password) {
    if (password.trim().isEmpty) {
      throw EmptyPasswordException();
    }
  }
}

final class LoginUseCaseParams {
  final String email;
  final String password;

  LoginUseCaseParams({required this.email, required this.password});
}
