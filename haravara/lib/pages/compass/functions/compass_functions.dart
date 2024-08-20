import 'dart:math' as math;
import 'dart:ui';

double calculateBearing(
    double startLat, double startLng, double endLat, double endLng) {
  var startLatRad = _toRadians(startLat);
  var startLngRad = _toRadians(startLng);
  var endLatRad = _toRadians(endLat);
  var endLngRad = _toRadians(endLng);

  var dLng = endLngRad - startLngRad;

  var x = math.sin(dLng) * math.cos(endLatRad);
  var y = math.cos(startLatRad) * math.sin(endLatRad) -
      math.sin(startLatRad) * math.cos(endLatRad) * math.cos(dLng);

  var bearing = math.atan2(x, y);
  bearing = _toDegrees(bearing);
  bearing = (bearing + 360) % 360;

  return bearing;
}

double _toRadians(double degree) {
  return degree * math.pi / 180;
}

double _toDegrees(double radians) {
  return radians * 180 / math.pi;
}

double calculateCompassDirection(double heading, double bearingToTarget) {
  double direction = bearingToTarget - heading;

  direction = (direction + 360) % 360;
  return direction;
}

getColorForDistance(double distance) {
  if (distance > 250) {
    return const Color.fromARGB(255, 70, 68, 205);
  }
  if (distance < 25) return Color.fromARGB(255, 233, 18, 18);
  if (distance < 100) return Color.fromARGB(255, 225, 222, 16);
  return Color.fromARGB(255, 215, 16, 246);
}
