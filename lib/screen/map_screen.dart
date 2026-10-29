
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

import '../services/pet_service.dart';
import 'report_lost_screen.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'bluetooth_scanner_screen.dart';
import 'radar_screen.dart';

class MapScreen extends StatefulWidget {
  final bool selectLocation;

  const MapScreen({
    super.key,
    this.selectLocation = false,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static const Color primaryBlue = Color(0xFF4169E1);
  static const Color lostPetRed = Color(0xFFE53935);

  final MapController _mapController = MapController();
  final PetService _petService = PetService();

  static const LatLng _defaultLocation =
      LatLng(7.2083, 79.8358);

  LatLng? _currentLocation;
  String? _locationMessage;

  bool _loadingLocation = true;
  bool _loadingLostPets = true;

  final List<Map<String, dynamic>> _lostPetLocations = [];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();

    if (!widget.selectLocation) {
      _loadLostPetLocations();
    }
  }

  int _createdAtMillis(Map<String, dynamic> pet) {
    final value = pet['createdAt'];

    if (value == null) return 0;

    if (value is DateTime) {
      return value.millisecondsSinceEpoch;
    }

    try {
      return (value as dynamic)
          .toDate()
          .millisecondsSinceEpoch as int;
    } catch (_) {
      return 0;
    }
  }

  Map<String, dynamic>? get _latestLostPet {
    if (_lostPetLocations.isEmpty) return null;

    final pets =
        List<Map<String, dynamic>>.from(_lostPetLocations);

    pets.sort(
      (a, b) =>
          _createdAtMillis(b).compareTo(_createdAtMillis(a)),
    );

    return pets.first;
  }

  // Calculate GPS distance between user and lost pet.
  String _distanceFromCurrentLocation(
    Map<String, dynamic> pet,
  ) {
    if (_currentLocation == null ||
        pet['latitude'] is! num ||
        pet['longitude'] is! num) {
      return 'Distance unavailable';
    }

    final distanceMetres = Geolocator.distanceBetween(
      _currentLocation!.latitude,
      _currentLocation!.longitude,
      (pet['latitude'] as num).toDouble(),
      (pet['longitude'] as num).toDouble(),
    );

    if (distanceMetres < 1000) {
      return 'Last seen ${distanceMetres.round()} m away';
    }

    return 'Last seen ${(distanceMetres / 1000).toStringAsFixed(1)} km away';
  }

  // Milestone 2: GPS proximity classification.
  String _proximityStatus(Map<String, dynamic> pet) {
    if (_currentLocation == null ||
        pet['latitude'] is! num ||
        pet['longitude'] is! num) {
      return 'Unknown';
    }

    final distance = Geolocator.distanceBetween(
      _currentLocation!.latitude,
      _currentLocation!.longitude,
      (pet['latitude'] as num).toDouble(),
      (pet['longitude'] as num).toDouble(),
    );

    if (distance < 500) {
      return 'Nearby';
    } else if (distance < 2000) {
      return 'Moderate Distance';
    } else {
      return 'Far Away';
    }
  }

  Future<void> _loadLostPetLocations() async {
    try {
      final pets = await _petService.getLostPetLocations();

      if (!mounted) return;

      setState(() {
        _lostPetLocations
          ..clear()
          ..addAll(
            pets.where(
              (pet) =>
                  pet['latitude'] is num &&
                  pet['longitude'] is num,
            ),
          );
      });
    } catch (e) {
      debugPrint('Error loading Lost Pet markers: $e');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Could not load saved Lost Pet markers.',
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _loadingLostPets = false);
      }
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      final serviceEnabled =
          await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        _showLocationMessage(
          'Please enable your device location.',
        );
        return;
      }

      LocationPermission permission =
          await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        _showLocationMessage(
          'Location permission was denied.',
        );
        return;
      }

      if (permission == LocationPermission.deniedForever) {
        _showLocationMessage(
          'Location permission is blocked. Enable it in app settings.',
        );
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 15),
        ),
      );

      if (!mounted) return;

      final location = LatLng(
        position.latitude,
        position.longitude,
      );

      setState(() {
        _currentLocation = location;
        _locationMessage = null;
      });

      _mapController.move(location, 16);
    } catch (e) {
      _showLocationMessage(
        'Could not get your location. Please try again.',
      );

      debugPrint('GPS error: $e');
    } finally {
      if (mounted) {
        setState(() => _loadingLocation = false);
      }
    }
  }

  void _showLocationMessage(String message) {
    if (!mounted) return;

    setState(() {
      _locationMessage = message;
    });
  }

  // FIXED: Open Radar Screen without undefined target.
  void _openPetRadar(Map<String, dynamic> pet) {
    final latitude = pet['latitude'];
    final longitude = pet['longitude'];

    if (latitude is! num || longitude is! num) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pet location is unavailable.'),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RadarScreen(),
      ),
    );
  }

  // Show selected pet details.
  void _showPetDetails(Map<String, dynamic> pet) {
    final petName =
        (pet['petname'] ?? 'Lost Pet').toString();

    final breed =
        (pet['breed'] ?? 'Unknown').toString();

    final colour =
        (pet['colour'] ?? 'Unknown').toString();

    final description =
        (pet['description'] ??
                'No description available.')
            .toString();

    final latitude = pet['latitude'];
    final longitude = pet['longitude'];

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              const Icon(
                Icons.pets,
                color: lostPetRed,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(petName),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                _detailRow('Breed', breed),
                const SizedBox(height: 12),

                _detailRow('Colour', colour),
                const SizedBox(height: 12),

                _detailRow(
                  'Description',
                  description,
                ),
                const SizedBox(height: 12),

                _detailRow(
                  'Last-seen latitude',
                  latitude?.toString() ?? 'Unavailable',
                ),
                const SizedBox(height: 8),

                _detailRow(
                  'Last-seen longitude',
                  longitude?.toString() ?? 'Unavailable',
                ),
                const SizedBox(height: 12),

                _detailRow(
                  'Distance',
                  _distanceFromCurrentLocation(pet),
                ),
                const SizedBox(height: 12),

                _detailRow(
                  'GPS Proximity',
                  _proximityStatus(pet),
                ),
                const SizedBox(height: 12),

                const Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: lostPetRed,
                      size: 20,
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        'Reported as a lost pet',
                        style: TextStyle(
                          color: lostPetRed,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            // NEW: Track Pet button.
            TextButton.icon(
              onPressed: () {
                Navigator.pop(dialogContext);
                _openPetRadar(pet);
              },
              icon: const Icon(Icons.radar),
              label: const Text('Track Pet'),
            ),

            // Edit existing pet report.
            TextButton(
              onPressed: () async {
                Navigator.pop(dialogContext);

                final result =
                    await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ReportLostScreen(
                      existingReport:
                          Map<String, dynamic>.from(pet),
                    ),
                  ),
                );

                if (!mounted) return;

                if (result == true) {
                  setState(() {
                    _loadingLostPets = true;
                  });

                  await _loadLostPetLocations();
                }
              },
              child: const Text('Edit'),
            ),

            // Mark pet as found.
            TextButton(
              onPressed: () async {
                final reportId = pet['id']?.toString();

                if (reportId == null || reportId.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Could not find this pet report.',
                      ),
                    ),
                  );
                  return;
                }

                Navigator.pop(dialogContext);

                try {
                  await _petService
                      .markLostPetAsFound(reportId);

                  if (!mounted) return;

                  setState(() {
                    _lostPetLocations.removeWhere(
                      (item) =>
                          item['id']?.toString() == reportId,
                    );
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '$petName marked as found!',
                      ),
                    ),
                  );
                } catch (e) {
                  if (!mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Could not mark this pet as found. Please try again.',
                      ),
                    ),
                  );

                  debugPrint(
                    'Error marking pet as found: $e',
                  );
                }
              },
              child: const Text(
                'Mark as Found',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),

            TextButton(
              onPressed: () =>
                  Navigator.pop(dialogContext),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _detailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 3),
        Text(value),
      ],
    );
  }

  // Display latest active lost-pet report.
  Widget _buildBuddyCard() {
    final pet = _latestLostPet;

    if (_loadingLostPets && pet == null) {
      return _buddyCardContent(
        icon: Icons.hourglass_empty,
        title: 'Loading lost pets...',
        subtitle: 'Getting the latest reports',
        distance: '',
      );
    }

    if (pet == null) {
      return _buddyCardContent(
        icon: Icons.pets,
        title: 'No active lost pets',
        subtitle: 'Be the first to report a lost pet.',
        distance: '',
      );
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () => _showPetDetails(pet),
        child: _buddyCardContent(
          icon: Icons.pets,
          title:
              (pet['petname'] ?? 'Lost Pet').toString(),
          subtitle:
              (pet['breed'] ?? 'Unknown').toString(),
          distance:
              _distanceFromCurrentLocation(pet),
        ),
      ),
    );
  }

  Widget _buddyCardContent({
    required IconData icon,
    required String title,
    required String subtitle,
    required String distance,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF4FF),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xFF8CB4E8),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: const Color(0xFFD8ECDD),
            child: Icon(
              icon,
              color: primaryBlue,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(subtitle),
                if (distance.isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text(
                    distance,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right,
            color: primaryBlue,
          ),
        ],
      ),
    );
  }

  Future<void> _openReportLostScreen() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ReportLostScreen(),
      ),
    );

    if (!mounted) return;

    setState(() {
      _loadingLostPets = true;
    });

    await _loadLostPetLocations();
  }

  Future<void> _refreshLostPets() async {
    if (_loadingLostPets) return;

    setState(() {
      _loadingLostPets = true;
    });

    await _loadLostPetLocations();
  }

  @override
  Widget build(BuildContext context) {
    final mapCenter =
        _currentLocation ?? _defaultLocation;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          widget.selectLocation
              ? 'Select Last-Seen Location'
              : 'Find a Pet',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          if (!widget.selectLocation)
            IconButton(
              tooltip: 'Refresh lost pets',
              onPressed: _refreshLostPets,
              icon: const Icon(Icons.refresh),
            ),
          if (widget.selectLocation)
            IconButton(
              tooltip: 'Location selection help',
              icon: const Icon(Icons.info_outline),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Tap the map to select the last-seen location.',
                    ),
                  ),
                );
              },
            ),
        ],
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
                        clipBehavior: Clip.hardEdge,
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
                            FlutterMap(
                              mapController: _mapController,
                              options: MapOptions(
                                initialCenter: mapCenter,
                                initialZoom: 14,
                                onTap: (tapPosition, point) {
                                  if (widget.selectLocation) {
                                    Navigator.pop(
                                      context,
                                      point,
                                    );
                                  }
                                },
                              ),
                              children: [
                                TileLayer(
                                  urlTemplate:
                                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                  userAgentPackageName:
                                      'barkbeacon',
                                ),

                                // Current GPS location marker.
                                if (_currentLocation != null)
                                  MarkerLayer(
                                    markers: [
                                      Marker(
                                        point: _currentLocation!,
                                        width: 50,
                                        height: 50,
                                        child: const Icon(
                                          Icons.my_location,
                                          color: primaryBlue,
                                          size: 35,
                                        ),
                                      ),
                                    ],
                                  ),

                                // Lost pet markers.
                                if (!widget.selectLocation)
                                  MarkerLayer(
                                    markers:
                                        _lostPetLocations.map((pet) {
                                      final location = LatLng(
                                        (pet['latitude'] as num)
                                            .toDouble(),
                                        (pet['longitude'] as num)
                                            .toDouble(),
                                      );

                                      final petName =
                                          (pet['petname'] ??
                                                  'Lost Pet')
                                              .toString();

                                      return Marker(
                                        point: location,
                                        width: 140,
                                        height: 75,
                                        child: GestureDetector(
                                          behavior:
                                              HitTestBehavior.opaque,
                                          onTap: () =>
                                              _showPetDetails(pet),
                                          child: Column(
                                            mainAxisSize:
                                                MainAxisSize.min,
                                            children: [
                                              Container(
                                                constraints:
                                                    const BoxConstraints(
                                                  maxWidth: 135,
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 8,
                                                  vertical: 4,
                                                ),
                                                decoration:
                                                    BoxDecoration(
                                                  color:
                                                      Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8),
                                                  border:
                                                      Border.all(
                                                    color:
                                                        lostPetRed,
                                                  ),
                                                ),
                                                child: Text(
                                                  petName,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign:
                                                      TextAlign.center,
                                                  style:
                                                      const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                              const Icon(
                                                Icons.location_on,
                                                color: lostPetRed,
                                                size: 38,
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                              ],
                            ),

                            if (_loadingLocation)
                              const Positioned(
                                top: 12,
                                left: 12,
                                right: 12,
                                child: Card(
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Text(
                                      'Finding your location...',
                                      textAlign:
                                          TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),

                            if (_locationMessage != null)
                              Positioned(
                                top: 12,
                                left: 12,
                                right: 12,
                                child: Card(
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.all(10),
                                    child: Text(
                                      _locationMessage!,
                                      textAlign:
                                          TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),

                            if (!widget.selectLocation)
                              Positioned(
                                left: 12,
                                bottom: 12,
                                child: Card(
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 7,
                                    ),
                                    child: Row(
                                      mainAxisSize:
                                          MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.location_on,
                                          color: lostPetRed,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          _loadingLostPets
                                              ? 'Loading Lost Pets...'
                                              : 'Lost Pets: ${_lostPetLocations.length}',
                                          style:
                                              const TextStyle(
                                            fontWeight:
                                                FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                            Positioned(
                              right: 12,
                              bottom: 12,
                              child: FloatingActionButton.small(
                                heroTag: widget.selectLocation
                                    ? 'selectLocationGpsButton'
                                    : 'currentLocationButton',
                                backgroundColor: Colors.white,
                                foregroundColor: primaryBlue,
                                onPressed: () {
                                  setState(() {
                                    _loadingLocation = true;
                                    _locationMessage = null;
                                  });
                                  _getCurrentLocation();
                                },
                                child: const Icon(
                                  Icons.my_location,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    if (widget.selectLocation)
                      const Padding(
                        padding: EdgeInsets.only(top: 12),
                        child: Text(
                          'Tap the map where your pet was last seen.',
                          textAlign: TextAlign.center,
                        ),
                      ),

                    const SizedBox(height: 20),

                    if (!widget.selectLocation)
                      _buildBuddyCard(),
                  ],
                ),
              ),
            ),

            if (!widget.selectLocation) ...[
              Padding(
                padding:
                    const EdgeInsets.fromLTRB(20, 0, 20, 10),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _openReportLostScreen,
                    icon: const Icon(
                      Icons.campaign_outlined,
                    ),
                    label: const Text(
                      'Report a Lost Pet',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryBlue,
                      foregroundColor: Colors.white,
                      padding:
                          const EdgeInsets.symmetric(
                        vertical: 13,
                      ),
                    ),
                  ),
                ),
              ),
              const _MapBottomBar(),
            ],
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
    const primaryBlue = Color(0xFF4169E1);

    return BottomNavigationBar(
      currentIndex: 1,
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
        switch (index) {
          case 0:
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) => const HomeScreen(),
              ),
              (route) => false,
            );
            break;

          case 1:
            // Already on the Map screen.
            break;

          case 2:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    const BluetoothScannerScreen(),
              ),
            );
            break;

          case 3:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const ProfileScreen(),
              ),
            );
            break;
        }
      },
    );
  }
}
