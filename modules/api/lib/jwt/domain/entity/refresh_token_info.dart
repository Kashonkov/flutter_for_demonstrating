final class RefreshTokenInfo {
  final String token;
  final DateTime expiredInDate;

  RefreshTokenInfo({
    required this.token,
    required this.expiredInDate,
  });
}
