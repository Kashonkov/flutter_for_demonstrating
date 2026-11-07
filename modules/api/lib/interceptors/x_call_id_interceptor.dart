import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';

const callIdHeader = "X-Call-Id";

class XCallIdInterceptor extends Interceptor {
  @override
  Future onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    options.headers.addAll({
      callIdHeader: const Uuid().v4(),
    });
    super.onRequest(options, handler);
  }
}
