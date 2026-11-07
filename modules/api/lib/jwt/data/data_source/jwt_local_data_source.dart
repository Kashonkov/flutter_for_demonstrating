import 'dart:convert';

import 'package:api/jwt/data/model/refresh_token_data.dart';
import 'package:api/jwt/domain/entity/access_token_info.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Локальное хранилище информации о токенах
abstract class JwtLocalDataSource {
  /// Сохранение информаци  необходимой для обновления токенов
  Future<void> saveRefreshTokenData(RefreshTokenData data);

  /// Получение информаци  необходимой для обновления токенов
  Future<RefreshTokenData?> getRefreshTokenData();

  /// Получение информации о текущем аксесс токене
  AccessTokenInfo? getAccessToken();

  /// Сохранение информации о текущем аксесс токене
  saveAccessToken(AccessTokenInfo data);

  /// Удаление информации о токенах
  Future<void> deleteTokens();
}

const _jwtKey = "JWTKey";

class JwtLocalDataSourceImpl implements JwtLocalDataSource {
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  AccessTokenInfo? _accessToken;

  JwtLocalDataSourceImpl();

  @override
  AccessTokenInfo? getAccessToken() => _accessToken;

  @override
  Future<RefreshTokenData?> getRefreshTokenData() async {
    final data = await _storage.read(key: _jwtKey);
    if (data == null) return null;
    final representation = json.decode(data);
    return RefreshTokenData.fromJson(representation);
  }

  @override
  saveAccessToken(AccessTokenInfo data) {
    _accessToken = data;
  }

  @override
  Future<void> saveRefreshTokenData(RefreshTokenData data) async {
    final representation = json.encode(data.toJson());
    // final encryptedResult = await cryptographyPluginWorker.encrypt(representation, _retrieveKey);
    await _storage.write(key: _jwtKey, value: representation);
  }

  @override
  Future<void> deleteTokens() async {
    _accessToken = null;
    await _storage.delete(key: _jwtKey);
  }
}
