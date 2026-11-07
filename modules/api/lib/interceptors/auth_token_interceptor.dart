import 'package:api/jwt/domain/use_case/get_access_token_use_case.dart';
import 'package:common/usecase/usecase.dart';
import 'package:dio/dio.dart';

class AuthTokenInterceptor extends Interceptor {
  final GetAccessTokenUseCase getAccessTokenUseCase;

  AuthTokenInterceptor({required this.getAccessTokenUseCase});

  @override
  Future onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    options.headers.addAll({'Content-Type': 'application/json'});
    String? token = _getAuthorizedToken();

    if (token != null) {
      options.headers.addAll({if (token.isNotEmpty) 'Authorization': "Bearer $token"});
    }
    super.onRequest(options, handler);
  }

  String? _getAuthorizedToken() {
    final tokenResult = getAccessTokenUseCase(EmptyUsecaseParams());
    if (tokenResult.isSuccessful) {
      return tokenResult.result?.token;
    } else {
      return null;
    }
  }
}
