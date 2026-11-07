final class AuthInfoEntity {
  final String token;
  final String refreshToken;
  final int userId;
  final String username;
  final int expiresIn;

  AuthInfoEntity({
    required this.token,
    required this.refreshToken,
    required this.userId,
    required this.username,
    required this.expiresIn,
  });
}
