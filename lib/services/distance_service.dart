
import 'dart:math';

class DistanceService {
  static double calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const earthRadius = 6371000.0;

    double toRadians(double degrees) {
      return degrees * pi / 180;
    }

    final dLat = toRadians(lat2 - lat1);
    final dLon = toRadians(lon2 - lon1);

    final a = pow(sin(dLat / 2), 2) +
        cos(toRadians(lat1)) *
            cos(toRadians(lat2)) *
            pow(sin(dLon / 2), 2);

    final safeA = a.clamp(0.0, 1.0).toDouble();

    final c = 2 * atan2(
      sqrt(safeA),
      sqrt(1 - safeA),
    );

    return earthRadius * c;
  }

  static String proximityStatus(double distance) {
    if (distance < 500) {
      return "Nearby";
    } else if (distance < 2000) {
      return "Moderate Distance";
    } else {
      return "Far Away";
    }
  }
}
