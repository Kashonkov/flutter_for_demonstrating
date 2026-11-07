/// Ошибка при еще не обновленном токене
class TokenNotActiveException implements Exception {}

/// Ошибка при обновлении токена сессии
class RefreshTokenException implements Exception {}

/// Нет данных для обновления токена - возникает когда пробуют вызвать обновление токена до его получения первоначального
class EmptyTokenDataException implements Exception{}

/// Ошибка получения данных акссес токена
class AccessTokenDataException implements Exception{}