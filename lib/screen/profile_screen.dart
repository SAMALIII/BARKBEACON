import 'package:flutter/material.dart';

import 'home_screen.dart';
import 'map_screen.dart';
import 'bluetooth_scanner_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const Color navy = Color(0xFF142B52);
  static const Color electricBlue = Color(0xFF2563EB);
  static const Color paleBlue = Color(0xFFE8F0FF);
  static const Color white = Color(0xFFFFFFFF);
  static const Color amber = Color(0xFFF59E0B);

  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController breedController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    breedController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void saveProfile() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pet profile saved successfully!'),
          backgroundColor: navy,
        ),
      );
    }
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
          'Pet Profile',
          style: TextStyle(
            color: navy,
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 25),

                // Pet photo placeholder
                Center(
                  child: Column(
                    children: [
                      Container(
                        height: 145,
                        width: 145,
                        decoration: BoxDecoration(
                          color: paleBlue,
                          shape: BoxShape.circle,
                          border: Border.all(color: electricBlue, width: 2),
                        ),
                        child: const Icon(
                          Icons.pets,
                          color: electricBlue,
                          size: 75,
                        ),
                      ),

                      const SizedBox(height: 12),

                      OutlinedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Photo upload can be added later.'),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: electricBlue,
                          side: const BorderSide(color: electricBlue, width: 2),
                          shape: const StadiumBorder(),
                        ),
                        child: const Text(
                          'Change Photo',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // Pet name
                const Text(
                  'Pet Name *',
                  style: TextStyle(
                    color: navy,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                _inputField(
                  controller: nameController,
                  hint: 'e.g. Max',
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your pet name';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 22),

                // Breed
                const Text(
                  'Breed',
                  style: TextStyle(
                    color: navy,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                _inputField(
                  controller: breedController,
                  hint: 'e.g. Golden Retriever',
                ),

                const SizedBox(height: 22),

                // Description
                const Text(
                  'Description',
                  style: TextStyle(
                    color: navy,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                _inputField(
                  controller: descriptionController,
                  hint: 'e.g. Friendly, 3 years old...',
                  maxLines: 3,
                ),

                const SizedBox(height: 25),

                // Save button
                SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: ElevatedButton(
                    onPressed: saveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: electricBlue,
                      foregroundColor: white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(35),
                      ),
                    ),
                    child: const Text(
                      'Save',
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

      bottomNavigationBar: _bottomNavigation(context, 3),
    );
  }

  // Reusable text input
  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      maxLines: maxLines,
      style: const TextStyle(color: navy),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 15,
        ),
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
      ),
    );
  }
}

// Shared-style bottom navigation for this screen
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
          return;
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
