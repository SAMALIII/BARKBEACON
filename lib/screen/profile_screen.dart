import 'package:flutter/material.dart';
import '../services/pet_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const Color primaryBlue = Color(0xFF4169E1);
  static const Color lightBlue = Color(0xFFEAF4FF);

  final TextEditingController _petNameController =
      TextEditingController();

  final TextEditingController _breedController =
      TextEditingController();

  final TextEditingController _descriptionController =
      TextEditingController();

  final PetService _petService = PetService();

  bool _isSaving = false;

  Future<void> _savePet() async {
    final petName = _petNameController.text.trim();

    if (petName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your pet name.'),
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      // Uses your existing Firebase PetService.
      await _petService.savePet(petName);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '$petName saved successfully to Firebase!',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Unable to save pet: $e',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _petNameController.dispose();
    _breedController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        foregroundColor: Colors.black,
        title: const Text(
          'Pet Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),

      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 15,
                ),
                child: Column(
                  children: [
                    // Pet Photo
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.shade100,
                        border: Border.all(
                          color: Colors.black54,
                        ),
                      ),
                      child: const Icon(
                        Icons.pets,
                        size: 55,
                        color: Colors.black54,
                      ),
                    ),

                    const SizedBox(height: 8),

                    TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Photo upload will be implemented later.',
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        'Change Photo',
                        style: TextStyle(
                          color: primaryBlue,
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // Pet Name
                    _fieldTitle('Pet Name'),

                    TextField(
                      controller: _petNameController,
                      decoration: _inputDecoration(
                        'e.g. Milo',
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Breed
                    _fieldTitle('Breed'),

                    TextField(
                      controller: _breedController,
                      decoration: _inputDecoration(
                        'e.g. Golden Retriever',
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Description
                    _fieldTitle('Description'),

                    TextField(
                      controller: _descriptionController,
                      maxLines: 3,
                      decoration: _inputDecoration(
                        'e.g. Friendly, 3 years old...',
                      ),
                    ),

                    const SizedBox(height: 28),

                    // SAVE
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed:
                            _isSaving ? null : _savePet,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: lightBlue,
                          foregroundColor: Colors.black87,
                          elevation: 0,
                          side: const BorderSide(
                            color: Color(0xFF8CB4E8),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(20),
                          ),
                        ),
                        child: _isSaving
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child:
                                    CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Save',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom navigation
            BottomNavigationBar(
              currentIndex: 3,
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
                if (index == 0) {
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _fieldTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 4,
          bottom: 6,
        ),
        child: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: Colors.grey.shade500,
        fontSize: 13,
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(
          color: Colors.grey.shade300,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(
          color: primaryBlue,
          width: 1.5,
        ),
      ),
    );
  }
}