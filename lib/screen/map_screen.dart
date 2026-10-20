import 'package:flutter/material.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  static const Color primaryBlue = Color(0xFF4169E1);

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
          'Map',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F6F8),
                          border: Border.all(
                            color: Colors.black54,
                          ),
                          borderRadius:
                              BorderRadius.circular(4),
                        ),
                        child: Stack(
                          children: [
                            const Center(
                              child: Icon(
                                Icons.map_outlined,
                                size: 150,
                                color: Colors.blueGrey,
                              ),
                            ),

                            Center(
                              child: Container(
                                padding:
                                    const EdgeInsets.all(10),
                                decoration:
                                    const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.location_on,
                                  size: 42,
                                  color: primaryBlue,
                                ),
                              ),
                            ),

                            const Positioned(
                              bottom: 15,
                              left: 15,
                              child: Text(
                                'Map preview',
                                style: TextStyle(
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF4FF),
                        borderRadius:
                            BorderRadius.circular(15),
                        border: Border.all(
                          color: const Color(0xFF8CB4E8),
                        ),
                      ),
                      child: const Row(
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundColor:
                                Color(0xFFD8ECDD),
                            child: Icon(
                              Icons.pets,
                              color: primaryBlue,
                            ),
                          ),

                          SizedBox(width: 12),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Buddy',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Golden Retriever',
                                ),
                                SizedBox(height: 3),
                                Text(
                                  'Last seen 2.8 km away',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Icon(
                            Icons.chevron_right,
                            color: primaryBlue,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const _MapBottomBar(),
          ],
        ),
      ),
    );
  }
}

class _MapBottomBar extends StatelessWidget {
  const _MapBottomBar();

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 1,
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