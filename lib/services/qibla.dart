// Qibla math (v2.0) — pure Dart, no plugin needed for the numbers.
// The device heading itself comes from flutter_compass (see the Qibla
// screen); this file only computes the bearing and the distance from
// any lat/lon to the Kaaba (21.4225, 39.8262).
import 'dart:math';

const double kaabaLat = 21.4225;
const double kaabaLon = 39.8262;

/// Great-circle initial bearing (degrees, 0 = North, clockwise) from
/// [lat]/[lon] to the Kaaba.
double qiblaBearing(double lat, double lon) {
  final phi1 = lat * pi / 180;
  final phi2 = kaabaLat * pi / 180;
  final dLon = (kaabaLon - lon) * pi / 180;
  final y = sin(dLon) * cos(phi2);
  final x = cos(phi1) * sin(phi2) - sin(phi1) * cos(phi2) * cos(dLon);
  return (atan2(y, x) * 180 / pi + 360) % 360;
}

/// Great-circle distance to the Kaaba in kilometres (haversine).
double distanceToMakkahKm(double lat, double lon) {
  const r = 6371.0;
  final dLat = (kaabaLat - lat) * pi / 180;
  final dLon = (kaabaLon - lon) * pi / 180;
  final a = sin(dLat / 2) * sin(dLat / 2) +
      cos(lat * pi / 180) *
          cos(kaabaLat * pi / 180) *
          sin(dLon / 2) *
          sin(dLon / 2);
  return 2 * r * asin(sqrt(a));
}

const List<String> _directionsBn = [
  'উত্তর',
  'উত্তর-পূর্ব',
  'পূর্ব',
  'দক্ষিণ-পূর্ব',
  'দক্ষিণ',
  'দক্ষিণ-পশ্চিম',
  'পশ্চিম',
  'উত্তর-পশ্চিম',
];

const List<String> _directionsEn = [
  'North',
  'North-East',
  'East',
  'South-East',
  'South',
  'South-West',
  'West',
  'North-West',
];

/// 8-wind compass direction name for [degrees].
String compassDirection(double degrees, {bool bangla = true}) {
  final idx = (((degrees + 22.5) % 360) / 45).floor() % 8;
  return bangla ? _directionsBn[idx] : _directionsEn[idx];
}
