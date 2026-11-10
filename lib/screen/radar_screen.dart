import 'package:flutter/material.dart';

import 'home_screen.dart';
import 'map_screen.dart';
import 'bluetooth_scanner_screen.dart';
import 'profile_screen.dart';

class RadarScreen extends StatelessWidget {
  const RadarScreen({super.key});

  // BarkBeacon colour theme
  static const Color navy = Color(0xFF142B52);
  static const Color electricBlue = Color(0xFF2563EB);
  static const Color paleBlue = Color(0xFFE8F0FF);
  static const Color white = Color(0xFFFFFFFF);
  static const Color amber = Color(0xFFF59E0B);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,

      // App bar
      appBar: AppBar(
        backgroundColor: white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: navy),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Bluetooth Scanner',
          style: TextStyle(
            color: navy,
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // Main content
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              const SizedBox(height: 18),

              // Pet found notification
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [paleBlue, white]),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: electricBlue, width: 2),
                ),
                child: const Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.pets, color: electricBlue, size: 42),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Pet Found Nearby!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: navy,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 8),

                    Text(
                      'Follow the direction and signal strength to reach your pet.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: navy, fontSize: 16, height: 1.4),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Radar illustration
              Container(
                height: 215,
                width: 215,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: paleBlue,
                  border: Border.all(color: electricBlue, width: 4),
                ),
                child: const Icon(
                  Icons.bluetooth_searching,
                  color: electricBlue,
                  size: 115,
                ),
              ),

              const SizedBox(height: 35),

              // Signal strength card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: electricBlue, width: 2),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.signal_cellular_alt,
                      color: electricBlue,
                      size: 43,
                    ),

                    const SizedBox(width: 14),

                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Signal Strength',
                            style: TextStyle(
                              color: navy,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          SizedBox(height: 3),

                          Text(
                            '-68 dBm',
                            style: TextStyle(color: navy, fontSize: 19),
                          ),
                        ],
                      ),
                    ),

                    // Signal status
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 17,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: amber,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Text(
                        'Nearby',
                        style: TextStyle(
                          color: navy,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Distance and direction
              Row(
                children: [
                  Expanded(
                    child: _detailCard(
                      icon: Icons.social_distance,
                      title: 'Distance',
                      value: 'Not available',
                    ),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: _detailCard(
                      icon: Icons.explore,
                      title: 'Direction',
                      value: 'Not available',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              // Back to scanner button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.bluetooth_searching),
                  label: const Text(
                    'Back to Scanner',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: electricBlue,
                    side: const BorderSide(color: electricBlue, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),

      // Bottom navigation
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        type: BottomNavigationBarType.fixed,
        backgroundColor: white,
        selectedItemColor: electricBlue,
        unselectedItemColor: navy,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        onTap: (index) {
          Widget? destination;

          switch (index) {
            case 0:
              destination = const HomeScreen();
              break;
            case 1:
              destination = const MapScreen();
              break;
            case 2:
              return;
            case 3:
              destination = const ProfileScreen();
              break;
          }

          if (destination != null) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => destination!),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.location_on), label: 'Map'),
          BottomNavigationBarItem(
            icon: Icon(Icons.bluetooth),
            label: 'Scanner',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  // Reusable information card
  static Widget _detailCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
      decoration: BoxDecoration(
        color: paleBlue,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: electricBlue, width: 2),
      ),
      child: Column(
        children: [
          Icon(icon, color: electricBlue, size: 26),

          const SizedBox(height: 5),

          Text(
            title,
            style: const TextStyle(
              color: navy,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(color: navy, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
