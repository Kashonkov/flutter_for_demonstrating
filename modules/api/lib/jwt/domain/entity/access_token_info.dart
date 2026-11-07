final class AccessTokenInfo {
  final String token;
  final int expiredInSeconds;

  AccessTokenInfo({
    required this.token,
    required this.expiredInSeconds,
  });
}
