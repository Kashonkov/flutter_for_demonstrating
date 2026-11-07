/// The class contains the configuration of URLs for creating a pool of clients
/// [baseConfig] - config for accessing common platform services
/// [trustedCertFingerprints] - SHA-256 certificate fingerprints for ssl pinning
class ApiConfig {
  final UrlConfig authConfig;
  final UrlConfig baseConfig;
  final List<String>? trustedCertFingerprints;

  ApiConfig({
    required this.authConfig,
    required this.baseConfig,
    this.trustedCertFingerprints,
  });
}

/// Class for configuring URLs
/// [url] - URL for accessing the resource
/// [timeoutMilliseconds] - access timeout in milliseconds
/// [isLoggingEnable] - flag whether logging is available
/// [trustedCertFingerprints] - SHA-256 certificate fingerprints for ssl pinning
class UrlConfig {
  final String url;
  final int timeoutMilliseconds;
  final bool isLoggingEnable;
  final List<String>? trustedCertFingerprints;

  UrlConfig({
    required this.url,
    this.timeoutMilliseconds = 60000,
    this.isLoggingEnable = false,
    this.trustedCertFingerprints,
  });
}
