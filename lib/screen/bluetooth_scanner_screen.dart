import 'package:flutter/material.dart';
import 'radar_screen.dart';

class BluetoothScannerScreen extends StatelessWidget {
  const BluetoothScannerScreen({super.key});

  static const Color primaryBlue = Color(0xFF4169E1);
  static const Color lightBlue = Color(0xFFEAF4FF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        centerTitle: true,
        title: const Text(
          'Bluetooth Scanner',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.shade100,
                        border: Border.all(
                          color: Colors.black45,
                        ),
                      ),
                      child: const Icon(
                        Icons.bluetooth_searching,
                        size: 60,
                        color: primaryBlue,
                      ),
                    ),

                    const SizedBox(height: 25),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: lightBlue,
                        borderRadius:
                            BorderRadius.circular(15),
                        border: Border.all(
                          color: const Color(0xFF8CB4E8),
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.bluetooth,
                            color: primaryBlue,
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Scanning for nearby pet tags...',
                                  style: TextStyle(
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Keep your phone\'s Bluetooth on and stay moving.',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Nearby Devices',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    _device(
                      context,
                      'BarkTag_1234',
                      3,
                    ),

                    _device(
                      context,
                      'BarkTag_2007',
                      2,
                    ),

                    _device(
                      context,
                      'Other Device',
                      1,
                    ),
                  ],
                ),
              ),
            ),

            const _ScannerBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _device(
    BuildContext context,
    String name,
    int strength,
  ) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: const BorderSide(
          color: Color(0xFF8CB4E8),
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListTile(
        leading: const Icon(
          Icons.bluetooth,
          color: primaryBlue,
        ),
        title: Text(name),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            3,
            (index) => Padding(
              padding:
                  const EdgeInsets.only(left: 2),
              child: Icon(
                Icons.signal_cellular_alt,
                size: 17,
                color: index < strength
                    ? primaryBlue
                    : Colors.grey.shade300,
              ),
            ),
          ),
        ),
        onTap: () {
          if (name == 'BarkTag_1234') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const RadarScreen(),
              ),
            );
          }
        },
      ),
    );
  }
}

class _ScannerBottomBar extends StatelessWidget {
  const _ScannerBottomBar();

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 2,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF4169E1),
      unselectedItemColor: Colors.blueGrey,
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
    );
  }
}