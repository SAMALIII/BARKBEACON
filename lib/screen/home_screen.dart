import 'package:flutter/material.dart';

import 'profile_screen.dart';
import 'report_lost_screen.dart';
import 'map_screen.dart';
import 'bluetooth_scanner_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const Color primaryBlue = Color(0xFF4169E1);
  static const Color lightBlue = Color(0xFFEAF4FF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 15,
                ),
                child: Column(
                  children: [
                    // Top decoration
                    Container(
                      width: 70,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.blueGrey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // BarkBeacon Logo
                    const Icon(
                      Icons.pets,
                      size: 48,
                      color: primaryBlue,
                    ),

                    const SizedBox(height: 6),

                    const Text(
                      'BarkBeacon',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: primaryBlue,
                      ),
                    ),

                    const SizedBox(height: 3),

                    const Text(
                      'Find Your Furry Friend',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'A community-powered network to find lost pets and keep them safe.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),

                    const SizedBox(height: 22),

                    // Pet image placeholder
                    Container(
                      width: 125,
                      height: 125,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        border: Border.all(
                          color: Colors.black54,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.pets,
                        size: 65,
                        color: Colors.black54,
                      ),
                    ),

                    const SizedBox(height: 25),

                    // MY PET PROFILE
                    _menuButton(
                      icon: Icons.pets,
                      text: 'My Pet Profile',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const ProfileScreen(),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 10),

                    // REPORT LOST PET
                    _menuButton(
                      icon: Icons.warning_amber_rounded,
                      text: 'Report a Lost Pet',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const ReportLostScreen(),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 10),

                    // FIND A PET / MAP
                    _menuButton(
                      icon: Icons.location_on_outlined,
                      text: 'Find a Pet',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const MapScreen(),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 10),

                    // BLUETOOTH SCANNER
                    _menuButton(
                      icon: Icons.bluetooth,
                      text: 'Bluetooth Scanner',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const BluetoothScannerScreen(),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 15),
                  ],
                ),
              ),
            ),

            // BOTTOM NAVIGATION
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(
                    color: Colors.grey.shade300,
                  ),
                ),
              ),
              child: BottomNavigationBar(
                currentIndex: 0,
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.white,
                selectedItemColor: primaryBlue,
                unselectedItemColor: Colors.blueGrey,
                selectedFontSize: 11,
                unselectedFontSize: 11,

                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),

                  BottomNavigationBarItem(
                    icon: Icon(Icons.map_outlined),
                    label: 'Map',
                  ),

                  BottomNavigationBarItem(
                    icon: Icon(Icons.bluetooth_searching),
                    label: 'Scanner',
                  ),

                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: 'Profile',
                  ),
                ],

                onTap: (index) {
                  // HOME
                  if (index == 0) {
                    return;
                  }

                  // MAP
                  if (index == 1) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const MapScreen(),
                      ),
                    );
                  }

                  // SCANNER
                  else if (index == 2) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const BluetoothScannerScreen(),
                      ),
                    );
                  }

                  // PROFILE
                  else if (index == 3) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const ProfileScreen(),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Reusable Home button
  Widget _menuButton({
    required IconData icon,
    required String text,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton(
        onPressed: onPressed,

        style: OutlinedButton.styleFrom(
          backgroundColor: lightBlue,
          foregroundColor: Colors.black87,

          side: const BorderSide(
            color: Color(0xFF8CB4E8),
          ),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),

        child: Row(
          children: [
            Icon(
              icon,
              color: primaryBlue,
              size: 22,
            ),

            const SizedBox(width: 14),

            Text(
              text,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}