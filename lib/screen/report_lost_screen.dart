import 'package:flutter/material.dart';

import 'home_screen.dart';
import 'map_screen.dart';
import 'profile_screen.dart';
import 'bluetooth_scanner_screen.dart';

class ReportLostScreen extends StatefulWidget {
  const ReportLostScreen({super.key});

  @override
  State<ReportLostScreen> createState() => _ReportLostScreenState();
}

class _ReportLostScreenState extends State<ReportLostScreen> {
  static const Color navy = Color(0xFF142B52);
  static const Color electricBlue = Color(0xFF2563EB);
  static const Color paleBlue = Color(0xFFE8F0FF);
  static const Color white = Color(0xFFFFFFFF);
  static const Color amber = Color(0xFFF59E0B);

  final _formKey = GlobalKey<FormState>();

  final TextEditingController locationController = TextEditingController();

  final TextEditingController dateController = TextEditingController();

  String? selectedPet;

  // Sample registered pets for the UI
  final List<String> registeredPets = ['Buddy', 'Max', 'Bella'];

  Future<void> selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: electricBlue,
              onPrimary: white,
              surface: white,
              onSurface: navy,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        dateController.text =
            '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
      });
    }
  }

  void submitReport() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$selectedPet marked as lost (demo only).'),
        backgroundColor: navy,
      ),
    );
  }

  @override
  void dispose() {
    locationController.dispose();
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,

      appBar: AppBar(
        backgroundColor: white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: navy),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Report Lost Pet',
          style: TextStyle(
            color: navy,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 20),

                // Announcement icon
                const Icon(
                  Icons.campaign_outlined,
                  color: electricBlue,
                  size: 55,
                ),

                const SizedBox(height: 8),

                const Text(
                  'Mark Your Pet as Lost',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: navy,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 18),

                const Text(
                  'This will notify the community and help others keep an eye out.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: navy, fontSize: 17, height: 1.4),
                ),

                const SizedBox(height: 22),

                // Select registered pet
                _sectionCard(
                  icon: Icons.pets,
                  title: 'Select Registered Pet',
                  child: DropdownButtonFormField<String>(
                    value: selectedPet,
                    isExpanded: true,
                    decoration: _fieldDecoration('Choose a Pet'),
                    items: registeredPets.map((pet) {
                      return DropdownMenuItem<String>(
                        value: pet,
                        child: Text(pet),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedPet = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a pet';
                      }
                      return null;
                    },
                  ),
                ),

                const SizedBox(height: 14),

                // Last seen location
                _sectionCard(
                  icon: Icons.location_on,
                  title: 'Last Seen Location',
                  child: TextFormField(
                    controller: locationController,
                    style: const TextStyle(color: navy),
                    decoration: _fieldDecoration('Enter location (optional)'),
                  ),
                ),

                const SizedBox(height: 14),

                // Date lost
                _sectionCard(
                  icon: Icons.calendar_month,
                  title: 'Date Lost',
                  child: TextFormField(
                    controller: dateController,
                    readOnly: true,
                    onTap: selectDate,
                    style: const TextStyle(color: navy),
                    decoration: _fieldDecoration('Select date (optional)')
                        .copyWith(
                          suffixIcon: const Icon(
                            Icons.calendar_today,
                            color: electricBlue,
                          ),
                        ),
                  ),
                ),

                const SizedBox(height: 24),

                // Mark as lost button
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.82,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: submitReport,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: amber,
                      foregroundColor: navy,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(35),
                      ),
                    ),
                    child: const Text(
                      'Mark as Lost',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 25),
              ],
            ),
          ),
        ),
      ),

      bottomNavigationBar: _bottomNavigation(context, 0),
    );
  }

  // Reusable form section
  Widget _sectionCard({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [paleBlue, white]),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: electricBlue, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: electricBlue, size: 30),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: navy,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          child,
        ],
      ),
    );
  }

  // Reusable input decoration
  InputDecoration _fieldDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey, fontSize: 15),
      filled: true,
      fillColor: white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: paleBlue, width: 2.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: electricBlue, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: amber),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: amber),
      ),
    );
  }
}

// Bottom navigation
Widget _bottomNavigation(BuildContext context, int currentIndex) {
  const Color navy = Color(0xFF142B52);
  const Color electricBlue = Color(0xFF2563EB);

  return BottomNavigationBar(
    currentIndex: currentIndex,
    type: BottomNavigationBarType.fixed,
    backgroundColor: Colors.white,
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
          destination = const BluetoothScannerScreen();
          break;
        case 3:
          destination = const ProfileScreen();
          break;
      }

      if (destination != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => destination!),
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
