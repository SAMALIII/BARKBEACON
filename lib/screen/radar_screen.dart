

import 'package:flutter/material.dart';
import '../app_colors.dart';

class RadarScreen extends StatelessWidget {
  final String? petName;
  final double? latitude;
  final double? longitude;
  final double? distance;

  const RadarScreen({
    super.key,
    this.petName,
    this.latitude,
    this.longitude,
    this.distance,
  });

  String get formattedDistance {
    if (distance == null) return 'Not available';

    if (distance! >= 1000) {
      return '${(distance! / 1000).toStringAsFixed(2)} km';
    }

    return '${distance!.toStringAsFixed(0)} m';
  }

  String get formattedLocation {
    if (latitude == null || longitude == null) {
      return 'Not available';
    }

    return '${latitude!.toStringAsFixed(5)}, '
        '${longitude!.toStringAsFixed(5)}';
  }

  Widget _infoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.secondaryBlue,
            size: 28,
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.primaryNavy,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: AppColors.primaryNavy,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text(
          'Pet Radar',
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primaryNavy,
        iconTheme: const IconThemeData(
          color: AppColors.white,
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 15),

            const Icon(
              Icons.radar,
              size: 45,
              color: AppColors.secondaryBlue,
            ),

            const SizedBox(height: 12),

            Text(
              '${petName ?? 'Nearby Pet'} is nearby!',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryNavy,
              ),
            ),

            const SizedBox(height: 25),

            // Radar visual
            SizedBox(
              height: 260,
              width: 260,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.secondaryBlue,
                        width: 2,
                      ),
                    ),
                  ),

                  Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.secondaryBlue.withValues(
                          alpha: 0.6,
                        ),
                        width: 2,
                      ),
                    ),
                  ),

                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.secondaryBlue.withValues(
                        alpha: 0.12,
                      ),
                      border: Border.all(
                        color: AppColors.secondaryBlue,
                        width: 2,
                      ),
                    ),
                  ),

                  const Icon(
                    Icons.pets,
                    size: 42,
                    color: AppColors.primaryNavy,
                  ),

                  const Positioned(
                    top: 0,
                    child: Text(
                      'N',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryNavy,
                      ),
                    ),
                  ),

                  const Positioned(
                    bottom: 0,
                    child: Text(
                      'S',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryNavy,
                      ),
                    ),
                  ),

                  const Positioned(
                    left: 0,
                    child: Text(
                      'W',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryNavy,
                      ),
                    ),
                  ),

                  const Positioned(
                    right: 0,
                    child: Text(
                      'E',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryNavy,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            _infoCard(
              icon: Icons.pets,
              title: 'Pet Name',
              value: petName ?? 'Not available',
            ),

            _infoCard(
              icon: Icons.social_distance,
              title: 'Distance from you',
              value: formattedDistance,
            ),

            _infoCard(
              icon: Icons.location_on,
              title: 'Pet Location',
              value: formattedLocation,
            ),

            const SizedBox(height: 15),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Text(
                'Radar is currently a visual prototype. '
                'Live Bluetooth scanning, signal strength and '
                'compass direction are not yet implemented.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.primaryNavy,
                  fontSize: 13,
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
