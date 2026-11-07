import 'package:api/api_client/api_client.dart';
import 'package:api/api_client/net_factory.dart';
import 'package:api/config/api_config.dart';

/// Auth client for accessing platform methods
class AuthClient extends ApiClient {
  AuthClient._(super.dio);

  factory AuthClient.instance({
    required NetFactory netFactory,
    required UrlConfig urlConfig,
    List<String>? generalTrustedFingerprints,
  }) {
    final client = netFactory.createClient(
      urlConfig: urlConfig,
      generalTrustedFingerprints: generalTrustedFingerprints,
    );

    return AuthClient._(client);
  }
}
