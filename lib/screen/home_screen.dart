
import 'package:flutter/material.dart';

import '../app_colors.dart';
import 'profile_screen.dart';
import 'report_lost_screen.dart';
import 'map_screen.dart';
import 'bluetooth_scanner_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 12),

                    // APP LOGO
                    Container(
                      height: 75,
                      width: 75,
                      decoration: BoxDecoration(
                        color: AppColors.primaryNavy,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: const Icon(
                        Icons.pets,
                        color: AppColors.white,
                        size: 43,
                      ),
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      'BarkBeacon',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryNavy,
                      ),
                    ),

                    const SizedBox(height: 5),

                    const Text(
                      'Find Your Furry Friend',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.secondaryBlue,
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      'A community-powered network to find lost pets '
                      'and keep them safe.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.primaryNavy,
                      ),
                    ),

                    const SizedBox(height: 25),

                    // WELCOME CARD
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.primaryNavy,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Every Pet Deserves a Way Home',
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Report missing pets, explore nearby '
                            'reports and help reunite pets with '
                            'their families.',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Explore BarkBeacon',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryNavy,
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // PET PROFILE
                    _menuButton(
                      icon: Icons.pets,
                      text: 'My Pet Profile',
                      subtitle: 'View and manage your pet details',
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

                    // REPORT LOST PET
                    _menuButton(
                      icon: Icons.warning_amber_rounded,
                      text: 'Report a Lost Pet',
                      subtitle: 'Create a lost pet report',
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

                    // FIND A PET
                    _menuButton(
                      icon: Icons.location_on_outlined,
                      text: 'Find a Pet',
                      subtitle: 'Explore lost pet locations on the map',
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

                    // BLUETOOTH SCANNER
                    _menuButton(
                      icon: Icons.bluetooth_searching,
                      text: 'Bluetooth Scanner',
                      subtitle: 'Open the pet scanning screen',
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

                    const SizedBox(height: 20),

                    const Text(
                      'Together, we bring pets home.',
                      style: TextStyle(
                        color: AppColors.primaryNavy,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),

            // BOTTOM NAVIGATION
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                border: Border(
                  top: BorderSide(
                    color: AppColors.primaryNavy.withValues(
                      alpha: 0.12,
                    ),
                  ),
                ),
              ),
              child: BottomNavigationBar(
                currentIndex: 0,
                type: BottomNavigationBarType.fixed,
                backgroundColor: AppColors.white,
                selectedItemColor: AppColors.secondaryBlue,
                unselectedItemColor: Colors.blueGrey,
                selectedFontSize: 11,
                unselectedFontSize: 11,
                elevation: 0,

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
                  if (index == 0) return;

                  Widget screen;

                  if (index == 1) {
                    screen = const MapScreen();
                  } else if (index == 2) {
                    screen = const BluetoothScannerScreen();
                  } else {
                    screen = const ProfileScreen();
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => screen,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // REUSABLE MENU BUTTON
  Widget _menuButton({
    required IconData icon,
    required String text,
    required String subtitle,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.white,
          foregroundColor: AppColors.primaryNavy,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          side: const BorderSide(
            color: AppColors.secondaryBlue,
            width: 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          children: [
            Container(
              height: 46,
              width: 46,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(
                icon,
                color: AppColors.secondaryBlue,
                size: 25,
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: AppColors.primaryNavy,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.arrow_forward_ios,
              size: 15,
              color: AppColors.secondaryBlue,
            ),
          ],
        ),
      ),
    );
  }
}
