import 'dart:io';
import 'package:api/interceptors/x_call_id_interceptor.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:api/config/api_config.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';

typedef OnClientPrepared = Function(Dio client);

abstract class NetFactory {
  Dio createClient({
    required UrlConfig urlConfig,
    List<String>? generalTrustedFingerprints,
    Interceptors? interceptors,
    OnClientPrepared? onClientPrepared,
  });
}

class BaseNetFactory implements NetFactory {
  @override
  Dio createClient({
    required UrlConfig urlConfig,
    List<String>? generalTrustedFingerprints,
    Interceptors? interceptors,
    OnClientPrepared? onClientPrepared,
  }) {
    final client = Dio()
      ..options = BaseOptions(
        receiveTimeout: Duration(milliseconds: urlConfig.timeoutMilliseconds),
        connectTimeout: Duration(milliseconds: urlConfig.timeoutMilliseconds),
        baseUrl: urlConfig.url,
      );

    _setupSslPinning(client, urlConfig, generalTrustedFingerprints);

    _setupInterceptors(client, interceptors);

    onClientPrepared?.call(client);

    _setupLogger(client, urlConfig);
    return client;
  }

  void _setupSslPinning(
    Dio client,
    UrlConfig urlConfig, [
    List<String>? generalTrustedFingerprints,
  ]) {
    final List<String> fingerprints = [];
    if (generalTrustedFingerprints != null) {
      fingerprints.addAll(generalTrustedFingerprints);
    }
    final urlConfigTrustedFingerprints = urlConfig.trustedCertFingerprints;
    if (urlConfigTrustedFingerprints != null) {
      fingerprints.addAll(urlConfigTrustedFingerprints);
    }
    if (fingerprints.isEmpty) {
      return;
    }

    final normalizedCertificates = fingerprints
        .map((certificate) => certificate.toLowerCase())
        .toList();

    client.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        // Don't trust any certificate just because their root cert is trusted.
        final HttpClient client = HttpClient(context: SecurityContext(withTrustedRoots: false));
        // You can test the intermediate / root cert here. We just ignore it.
        client.badCertificateCallback = (cert, host, port) => true;
        return client;
      },
      validateCertificate: (cert, host, port) {
        // Check that the cert fingerprint matches the one we expect.
        // We definitely require _some_ certificate.
        if (cert == null) {
          return false;
        }
        // Validate it any way you want. Here we only check that
        // the fingerprint matches the OpenSSL SHA256.
        final fingerprint = sha256.convert(cert.der).toString();
        return normalizedCertificates.contains(fingerprint.toLowerCase());
      },
    );
  }

  void _setupInterceptors(Dio client, [Interceptors? interceptors]) {
    client.interceptors.add(XCallIdInterceptor());
    if (interceptors != null) {
      client.interceptors.addAll(interceptors);
    }
  }

  void _setupLogger(Dio client, UrlConfig urlConfig) {
    if (urlConfig.isLoggingEnable) {
      client.interceptors.addAll([
        TalkerDioLogger(
          settings: const TalkerDioLoggerSettings(
            printRequestHeaders: true,
            printResponseHeaders: true,
          ),
        ),
      ]);
    }
  }
}
