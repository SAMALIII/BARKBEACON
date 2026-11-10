import 'package:flutter/material.dart';

import 'home_screen.dart';
import 'profile_screen.dart';
import 'bluetooth_scanner_screen.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

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
          'Map',
          style: TextStyle(
            color: navy,
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // Main content
      body: Column(
        children: [
          // Map area
          Expanded(
            child: Stack(
              children: [
                // Map placeholder
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(color: paleBlue),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Map background decoration
                      CustomPaint(
                        size: Size.infinite,
                        painter: MapBackgroundPainter(),
                      ),

                      // Map location marker
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: electricBlue,
                              shape: BoxShape.circle,
                              border: Border.all(color: white, width: 3),
                              boxShadow: [
                                BoxShadow(
                                  color: navy.withValues(alpha: 0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.pets,
                              color: white,
                              size: 30,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Text(
                              'Lost Pet',
                              style: TextStyle(
                                color: navy,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Current location button
                Positioned(
                  right: 16,
                  top: 16,
                  child: FloatingActionButton.small(
                    heroTag: 'currentLocation',
                    backgroundColor: white,
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Current location will be available after GPS integration.',
                          ),
                        ),
                      );
                    },
                    child: const Icon(Icons.my_location, color: electricBlue),
                  ),
                ),

                // Map label
                Positioned(
                  left: 16,
                  top: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Nearby Lost Pets',
                      style: TextStyle(
                        color: navy,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Pet information card
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 18, 12, 18),
            child: InkWell(
              borderRadius: BorderRadius.circular(22),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(25),
                    ),
                  ),
                  builder: (context) {
                    return Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Buddy',
                            style: TextStyle(
                              color: navy,
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Breed: Golden Retriever',
                            style: TextStyle(color: navy, fontSize: 17),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Last seen: 2.3 km away',
                            style: TextStyle(color: navy, fontSize: 17),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    );
                  },
                );
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [paleBlue, Color(0xFFFFFFFF)],
                  ),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: electricBlue, width: 2),
                ),
                child: Row(
                  children: [
                    // Pet image placeholder
                    Container(
                      height: 82,
                      width: 82,
                      decoration: BoxDecoration(
                        color: white,
                        border: Border.all(color: electricBlue, width: 1.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.pets,
                        color: electricBlue,
                        size: 45,
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Pet details
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Buddy',
                            style: TextStyle(
                              color: navy,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            'Golden Retriever',
                            style: TextStyle(color: navy, fontSize: 16),
                          ),
                          Text(
                            'Last seen 2.3 km away',
                            style: TextStyle(color: navy, fontSize: 15),
                          ),
                        ],
                      ),
                    ),

                    const Icon(
                      Icons.arrow_forward_ios,
                      color: electricBlue,
                      size: 23,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      // Bottom navigation
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
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
              return;
            case 2:
              destination = const BluetoothScannerScreen();
              break;
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
}

// Decorative map background
class MapBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke;

    final thinRoadPaint = Paint()
      ..color = const Color(0xFFB9D0F5)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Decorative roads
    canvas.drawLine(
      Offset(0, size.height * 0.2),
      Offset(size.width, size.height * 0.65),
      roadPaint,
    );

    canvas.drawLine(
      Offset(size.width * 0.1, 0),
      Offset(size.width * 0.65, size.height),
      roadPaint,
    );

    canvas.drawLine(
      Offset(0, size.height * 0.8),
      Offset(size.width, size.height * 0.3),
      thinRoadPaint,
    );

    canvas.drawLine(
      Offset(size.width * 0.85, 0),
      Offset(size.width * 0.25, size.height),
      thinRoadPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
