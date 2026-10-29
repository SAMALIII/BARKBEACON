
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

  final PetService _petService = PetService();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _petNameController =
      TextEditingController();
  final TextEditingController _breedController =
      TextEditingController();
  final TextEditingController _descriptionController =
      TextEditingController();

  List<Map<String, dynamic>> _pets = [];

  String? _editingPetId;
  bool _isLoading = true;
  bool _isSaving = false;
  bool _isAddingPet = false;

  @override
  void initState() {
    super.initState();
    _loadPets();
  }

  Future<void> _loadPets() async {
    try {
      final pets = await _petService.getPetProfiles();
      final oldProfile = await _petService.getPetProfile();

      if (oldProfile != null &&
          oldProfile['petname'] != null &&
          !pets.any((pet) => pet['id'] == 'my_pet_profile')) {
        pets.insert(0, {
          'id': 'my_pet_profile',
          ...oldProfile,
        });
      }

      if (!mounted) return;

      setState(() {
        _pets = pets;
        _isAddingPet = pets.isEmpty;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not load pets: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _startAddingPet() {
    _petNameController.clear();
    _breedController.clear();
    _descriptionController.clear();
    _formKey.currentState?.reset();

    setState(() {
      _editingPetId = null;
      _isAddingPet = true;
    });
  }

  void _startEditingPet(Map<String, dynamic> pet) {
    _petNameController.text = pet['petname']?.toString() ?? '';
    _breedController.text = pet['breed']?.toString() ?? '';
    _descriptionController.text =
        pet['description']?.toString() ?? '';

    setState(() {
      _editingPetId = pet['id']?.toString();
      _isAddingPet = true;
    });
  }

  String? _validatePetName(String? value) {
    final name = value?.trim() ?? '';

    if (name.isEmpty) {
      return 'Please enter your pet name.';
    }

    if (name.length < 2 || name.length > 30) {
      return 'Name must be 2–30 characters.';
    }

    if (!RegExp(r"^[a-zA-Z][a-zA-Z .'-]*$").hasMatch(name)) {
      return 'Use letters and common name characters only.';
    }

    return null;
  }


String? _validateBreed(String? value) {
  final breed = value?.trim() ?? '';

  if (breed.isEmpty) {
    return 'Please enter your pet breed.';
  }

  if (breed.length < 2 || breed.length > 40) {
    return 'Breed must be 2–40 characters.';
  }

  if (!RegExp(r"^[a-zA-Z][a-zA-Z .'-]*$").hasMatch(breed)) {
    return 'Breed must contain letters only.';
  }

  return null;
}


  String? _validateDescription(String? value) {
    final description = value?.trim() ?? '';

    if (description.isEmpty) {
      return 'Please enter a description.';
    }

    if (description.length < 5 || description.length > 200) {
      return 'Description must be 5–200 characters.';
    }

    return null;
  }

  Future<void> _savePet() async {
    if (_isSaving) return;

    FocusScope.of(context).unfocus();

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final name = _petNameController.text.trim();
    final breed = _breedController.text.trim();
    final description = _descriptionController.text.trim();

    setState(() {
      _isSaving = true;
    });

    try {
      if (_editingPetId == 'my_pet_profile') {
        await _petService.savePetProfile(
          petName: name,
          breed: breed,
          description: description,
        );
      } else if (_editingPetId != null) {
        await _petService.updatePetProfile(
          petId: _editingPetId!,
          petName: name,
          breed: breed,
          description: description,
        );
      } else {
        await _petService.addPetProfile(
          petName: name,
          breed: breed,
          description: description,
        );
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pet profile saved successfully!'),
        ),
      );

      setState(() {
        _isAddingPet = false;
        _editingPetId = null;
        _isLoading = true;
      });

      await _loadPets();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to save pet: $e')),
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
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 15,
                      ),
                      child: Column(
                        children: [
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
                          const SizedBox(height: 20),

                          if (_isAddingPet) ...[
                            Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  _fieldTitle('Pet Name'),
                                  TextFormField(
                                    controller: _petNameController,
                                    validator: _validatePetName,
                                    maxLength: 30,
                                    textCapitalization:
                                        TextCapitalization.words,
                                    decoration:
                                        _inputDecoration('e.g. Milo'),
                                  ),
                                  const SizedBox(height: 18),

                                  _fieldTitle('Breed'),
                                  TextFormField(
                                    controller: _breedController,
                                    validator: _validateBreed,
                                    maxLength: 40,
                                    textCapitalization:
                                        TextCapitalization.words,
                                    decoration: _inputDecoration(
                                      'e.g. Golden Retriever',
                                    ),
                                  ),
                                  const SizedBox(height: 18),

                                  _fieldTitle('Description'),
                                  TextFormField(
                                    controller: _descriptionController,
                                    validator: _validateDescription,
                                    maxLength: 200,
                                    maxLines: 3,
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    decoration: _inputDecoration(
                                      'e.g. Friendly, 3 years old...',
                                    ),
                                  ),
                                  const SizedBox(height: 25),

                                  SizedBox(
                                    width: double.infinity,
                                    height: 50,
                                    child: ElevatedButton(
                                      onPressed:
                                          _isSaving ? null : _savePet,
                                      style: _buttonStyle(),
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
                                              'Save Pet',
                                              style: TextStyle(
                                                fontWeight:
                                                    FontWeight.bold,
                                              ),
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            if (_pets.isNotEmpty)
                              TextButton(
                                onPressed: _isSaving
                                    ? null
                                    : () {
                                        FocusScope.of(context).unfocus();
                                        _formKey.currentState?.reset();

                                        setState(() {
                                          _isAddingPet = false;
                                          _editingPetId = null;
                                        });
                                      },
                                child: const Text('Cancel'),
                              ),
                          ] else ...[
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'My Registered Pets',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),

                            ..._pets.map((pet) {
                              return Card(
                                color: lightBlue,
                                elevation: 0,
                                margin:
                                    const EdgeInsets.only(bottom: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(18),
                                  side: const BorderSide(
                                    color: Color(0xFF8CB4E8),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.pets,
                                            color: primaryBlue,
                                            size: 30,
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Text(
                                              pet['petname']
                                                      ?.toString() ??
                                                  'Unnamed Pet',
                                              style: const TextStyle(
                                                fontWeight:
                                                    FontWeight.bold,
                                                fontSize: 17,
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: _isSaving
                                                ? null
                                                : () =>
                                                    _startEditingPet(
                                                      pet,
                                                    ),
                                            icon: const Icon(
                                              Icons.edit_outlined,
                                              color: primaryBlue,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        'Breed: ${pet['breed']?.toString().isNotEmpty == true ? pet['breed'] : 'Not provided'}',
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        'Description: ${pet['description']?.toString().isNotEmpty == true ? pet['description'] : 'Not provided'}',
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),

                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton.icon(
                                onPressed:
                                    _isSaving ? null : _startAddingPet,
                                icon: const Icon(Icons.add),
                                label: const Text('Add Another Pet'),
                                style: _buttonStyle(),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),

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

  ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: lightBlue,
      foregroundColor: Colors.black87,
      elevation: 0,
      side: const BorderSide(color: Color(0xFF8CB4E8)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  Widget _fieldTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 4, bottom: 6),
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
        borderSide: BorderSide(color: Colors.grey.shade300),
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
