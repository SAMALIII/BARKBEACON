import 'package:flutter/material.dart';

class RadarScreen extends StatelessWidget {
  const RadarScreen({super.key});

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
          'Radar',
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
                            Icons.pets,
                            color: primaryBlue,
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  'Pet Found Nearby!',
                                  style: TextStyle(
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Follow the direction and signal strength to reach your pet.',
                                  textAlign:
                                      TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 35),

                    // Compass / Radar
                    Container(
                      width: 230,
                      height: 230,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.shade50,
                        border: Border.all(
                          color: Colors.black54,
                          width: 2,
                        ),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          const Positioned(
                            top: 12,
                            child: Text(
                              'N',
                              style: TextStyle(
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ),

                          const Positioned(
                            bottom: 12,
                            child: Text(
                              'S',
                              style: TextStyle(
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ),

                          const Positioned(
                            left: 14,
                            child: Text(
                              'W',
                              style: TextStyle(
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ),

                          const Positioned(
                            right: 14,
                            child: Text(
                              'E',
                              style: TextStyle(
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ),

                          Container(
                            width: 125,
                            height: 125,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.grey,
                              ),
                            ),
                          ),

                          const Icon(
                            Icons.navigation,
                            size: 70,
                            color: primaryBlue,
                          ),

                          const Positioned(
                            bottom: 50,
                            right: 45,
                            child: Icon(
                              Icons.pets,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

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
                            Icons.signal_cellular_alt,
                            color: primaryBlue,
                          ),

                          SizedBox(width: 12),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Signal Strength',
                                  style: TextStyle(
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '-40 dBm',
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Chip(
                            label: Text(
                              'Hot',
                              style: TextStyle(
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 15),

                    Row(
                      children: [
                        Expanded(
                          child: _informationBox(
                            'Distance',
                            '12 m',
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: _informationBox(
                            'Direction',
                            'North East',
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      'Prototype values shown for Milestone 1',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const _RadarBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _informationBox(
    String title,
    String value,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xFF8CB4E8),
        ),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _RadarBottomBar extends StatelessWidget {
  const _RadarBottomBar();

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