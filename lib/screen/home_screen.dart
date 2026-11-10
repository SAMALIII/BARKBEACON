import 'package:flutter/material.dart';

import 'profile_screen.dart';
import 'report_lost_screen.dart';
import 'map_screen.dart';
import 'bluetooth_scanner_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // BarkBeacon theme colours
  static const Color navy = Color(0xFF142B52);
  static const Color electricBlue = Color(0xFF2563EB);
  static const Color paleBlue = Color(0xFFE8F0FF);
  static const Color white = Color(0xFFFFFFFF);
  static const Color amber = Color(0xFFF59E0B);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 15),

              // Logo
              const Icon(Icons.pets, color: electricBlue, size: 48),

              const SizedBox(height: 8),

              // App name
              const Text(
                'BarkBeacon',
                style: TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.bold,
                  color: navy,
                ),
              ),

              const SizedBox(height: 4),

              // Tagline
              const Text(
                'Find Your Furry Friend',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  color: navy,
                ),
              ),

              const SizedBox(height: 20),

              // Description
              const Text(
                'A community-powered network to find lost pets and keep them safe.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, height: 1.4, color: navy),
              ),

              const SizedBox(height: 22),

              // Pet image placeholder
              Container(
                height: 145,
                width: 145,
                decoration: BoxDecoration(
                  color: paleBlue,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: electricBlue, width: 2),
                ),
                child: const Icon(Icons.pets, color: electricBlue, size: 85),
              ),

              const SizedBox(height: 22),

              // My Pet Profile
              _menuButton(
                title: 'My Pet Profile',
                icon: Icons.pets,
                highlighted: true,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfileScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 13),

              // Report Lost Pet
              _menuButton(
                title: 'Report a Lost Pet',
                icon: Icons.warning_amber_rounded,
                highlighted: false,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ReportLostScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 13),

              // Find a Pet
              _menuButton(
                title: 'Find a Pet',
                icon: Icons.location_on,
                highlighted: false,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MapScreen()),
                  );
                },
              ),

              const SizedBox(height: 13),

              // Bluetooth Scanner
              _menuButton(
                title: 'Bluetooth Scanner',
                icon: Icons.bluetooth,
                highlighted: false,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BluetoothScannerScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),

      // Bottom navigation
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: white,
          border: Border(top: BorderSide(color: paleBlue, width: 2)),
        ),
        child: BottomNavigationBar(
          currentIndex: 0,
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
                return;
              case 1:
                destination = const MapScreen();
                break;
              case 2:
                destination = const BluetoothScannerScreen();
                break;
              case 3:
                destination = const ProfileScreen();
                break;
            }

            if (destination != null) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => destination!),
              );
            }
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
              icon: Icon(Icons.location_on),
              label: 'Map',
            ),
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
      ),
    );
  }

  // Reusable menu button
  static Widget _menuButton({
    required String title,
    required IconData icon,
    required bool highlighted,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 62,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          backgroundColor: highlighted ? paleBlue : white,
          foregroundColor: electricBlue,
          side: const BorderSide(color: electricBlue, width: 2.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 32, color: highlighted ? amber : electricBlue),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: navy,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
