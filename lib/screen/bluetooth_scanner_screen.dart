import 'package:flutter/material.dart';

import 'home_screen.dart';
import 'map_screen.dart';
import 'profile_screen.dart';

class BluetoothScannerScreen extends StatefulWidget {
  const BluetoothScannerScreen({super.key});

  @override
  State<BluetoothScannerScreen> createState() => _BluetoothScannerScreenState();
}

class _BluetoothScannerScreenState extends State<BluetoothScannerScreen> {
  // BarkBeacon colour theme
  static const Color navy = Color(0xFF142B52);
  static const Color electricBlue = Color(0xFF2563EB);
  static const Color paleBlue = Color(0xFFE8F0FF);
  static const Color white = Color(0xFFFFFFFF);
  static const Color amber = Color(0xFFF59E0B);

  // Sample Bluetooth devices for the UI
  final List<Map<String, dynamic>> devices = [
    {'name': 'BarkTag_1234', 'signal': -68, 'bars': 3},
    {'name': 'BarkTag_2007', 'signal': -75, 'bars': 2},
    {'name': 'Other Device', 'signal': -90, 'bars': 1},
  ];

  // Selected device
  Map<String, dynamic>? selectedDevice;

  void selectDevice(Map<String, dynamic> device) {
    setState(() {
      selectedDevice = device;
    });
  }

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
            if (selectedDevice != null) {
              setState(() {
                selectedDevice = null;
              });
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: Text(
          selectedDevice == null ? 'Bluetooth Scanner' : 'Bluetooth Scanner',
          style: const TextStyle(
            color: navy,
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // Main screen
      body: SafeArea(
        child: selectedDevice == null
            ? buildScannerPage()
            : buildFoundPetPage(),
      ),

      // Bottom navigation
      bottomNavigationBar: buildBottomNavigation(),
    );
  }

  // First scanner screen
  Widget buildScannerPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          const SizedBox(height: 28),

          // Scanner illustration
          Container(
            height: 180,
            width: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: paleBlue,
              border: Border.all(color: electricBlue, width: 4),
            ),
            child: const Icon(
              Icons.bluetooth_searching,
              color: electricBlue,
              size: 95,
            ),
          ),

          const SizedBox(height: 30),

          // Scanning information card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [paleBlue, Color(0xFFFFFFFF)],
              ),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: electricBlue, width: 2),
            ),
            child: Column(
              children: const [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.bluetooth, color: electricBlue, size: 35),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Scanning for nearby pet tags...',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: navy,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  'Keep your phone’s Bluetooth on and stay moving.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: navy, fontSize: 16, height: 1.4),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // Nearby devices heading
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Nearby Devices',
              style: TextStyle(
                color: navy,
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Device list
          ...devices.map((device) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: buildDeviceCard(device),
            );
          }),

          const SizedBox(height: 15),
        ],
      ),
    );
  }

  // Individual Bluetooth device card
  Widget buildDeviceCard(Map<String, dynamic> device) {
    return InkWell(
      borderRadius: BorderRadius.circular(25),
      onTap: () {
        selectDevice(device);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: electricBlue, width: 2),
        ),
        child: Row(
          children: [
            // Device icon
            Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: paleBlue,
                border: Border.all(color: electricBlue, width: 2),
              ),
              child: const Icon(Icons.bluetooth, color: electricBlue, size: 29),
            ),

            const SizedBox(width: 14),

            // Device name
            Expanded(
              child: Text(
                device['name'],
                style: const TextStyle(color: navy, fontSize: 17),
              ),
            ),

            // Signal bars
            Row(
              children: List.generate(3, (index) {
                final isActive = index < device['bars'];

                return Container(
                  margin: const EdgeInsets.only(left: 3),
                  width: 8,
                  height: 14.0 + (index * 10),
                  decoration: BoxDecoration(
                    color: isActive ? electricBlue : paleBlue,
                    borderRadius: BorderRadius.circular(2),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  // Second screen: Pet found nearby
  Widget buildFoundPetPage() {
    final signal = selectedDevice!['signal'];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          const SizedBox(height: 22),

          // Pet found notification
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [paleBlue, Color(0xFFFFFFFF)],
              ),
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
                    Text(
                      'Pet Found Nearby!',
                      style: TextStyle(
                        color: navy,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
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

          const SizedBox(height: 28),

          // Pet signal illustration
          Container(
            height: 205,
            width: 205,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: paleBlue,
              border: Border.all(color: electricBlue, width: 4),
            ),
            child: const Icon(
              Icons.bluetooth_searching,
              color: electricBlue,
              size: 110,
            ),
          ),

          const SizedBox(height: 35),

          // Signal strength card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
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
                  size: 42,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Signal Strength',
                        style: TextStyle(
                          color: navy,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '$signal dBm',
                        style: const TextStyle(color: navy, fontSize: 18),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: amber,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Text(
                    'Nearby',
                    style: TextStyle(
                      color: navy,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // Distance and direction
          Row(
            children: [
              Expanded(child: detailCard('Distance', 'Not available')),
              const SizedBox(width: 12),
              Expanded(child: detailCard('Direction', 'Not available')),
            ],
          ),

          const SizedBox(height: 20),

          // Back to device list
          OutlinedButton.icon(
            onPressed: () {
              setState(() {
                selectedDevice = null;
              });
            },
            icon: const Icon(Icons.arrow_back),
            label: const Text('Nearby Devices'),
            style: OutlinedButton.styleFrom(
              foregroundColor: electricBlue,
              side: const BorderSide(color: electricBlue, width: 2),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // Reusable detail card
  Widget detailCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: paleBlue,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: electricBlue, width: 2),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: navy,
              fontWeight: FontWeight.bold,
              fontSize: 17,
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

  // Bottom navigation bar
  Widget buildBottomNavigation() {
    return BottomNavigationBar(
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
        BottomNavigationBarItem(icon: Icon(Icons.bluetooth), label: 'Scanner'),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          label: 'Profile',
        ),
      ],
    );
  }
}
