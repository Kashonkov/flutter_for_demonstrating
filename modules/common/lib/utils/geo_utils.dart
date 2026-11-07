import 'dart:math' as math;

List<List<double>> buildGeodesicCircleRing({
  required double lon,
  required double lat,
  required double radiusMeters,
  int segments = 64,
}) {
  final ring = <List<double>>[];

  for (int i = 0; i <= segments; i++) {
    final bearingDeg = (360.0 * i) / segments; // <= чтобы замкнуть кольцо
    final point = _destinationPoint(
      lonDeg: lon,
      latDeg: lat,
      bearingDeg: bearingDeg,
      distanceMeters: radiusMeters,
    );
    ring.add([point.$1, point.$2]); // [lon, lat]
  }

  return ring;
}

/// Возвращает (lon, lat) точки назначения по старту, азимуту и дистанции.
/// Сфера Земли, достаточно точно для UI-радиуса.
(double, double) _destinationPoint({
  required double lonDeg,
  required double latDeg,
  required double bearingDeg,
  required double distanceMeters,
}) {
  const earthRadius = 6371008.8; // meters

  final curve = distanceMeters / earthRadius;
  final bearingRad = _degToRad(bearingDeg);

  final latRad = _degToRad(latDeg);
  final lonRad = _degToRad(lonDeg);

  final sinLatRad = math.sin(latRad);
  final cosLatRad = math.cos(latRad);
  final sinCurve = math.sin(curve);
  final cosCurve = math.cos(curve);
  final sinBearingRad = math.sin(bearingRad);
  final cosBearingRad = math.cos(bearingRad);

  final sinTeth = sinLatRad * cosCurve + cosLatRad * sinCurve * cosBearingRad;
  final teth = math.asin(sinTeth);

  final y = sinBearingRad * sinCurve * cosLatRad;
  final x = cosCurve - sinLatRad * math.sin(teth);
  final lambda = lonRad + math.atan2(y, x);

  // Нормализация долготы в диапазон [-180..180]
  final lon2 = ((_radToDeg(lambda) + 540) % 360) - 180;
  final lat2 = _radToDeg(teth);

  return (lon2, lat2);
}

double _degToRad(double deg) => deg * math.pi / 180.0;

double _radToDeg(double rad) => rad * 180.0 / math.pi;
