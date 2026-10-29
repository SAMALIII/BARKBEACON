
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import '../services/pet_service.dart';
import 'map_screen.dart';
import 'profile_screen.dart';
import 'bluetooth_scanner_screen.dart';
import 'home_screen.dart';

class ReportLostScreen extends StatefulWidget {
  final Map<String, dynamic>? existingReport;

  const ReportLostScreen({
    super.key,
    this.existingReport,
  });

  @override
  State<ReportLostScreen> createState() => _ReportLostScreenState();
}

class _ReportLostScreenState extends State<ReportLostScreen> {
  static const Color primaryBlue = Color(0xFF4169E1);
  static const Color lightBlue = Color(0xFFEAF4FF);
  static const Color borderBlue = Color(0xFF8CB4E8);

  final PetService _petService = PetService();
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _breedController = TextEditingController();
  final _colourController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _dateController = TextEditingController();

  List<Map<String, dynamic>> _pets = [];
  String? _selectedPetId;
  String _reportType = 'registered';

  LatLng? _selectedLocation;
  bool _isLoadingPets = true;
  bool _isSaving = false;
  bool _locationError = false;

  bool get _isEditing => widget.existingReport != null;

  @override
  void initState() {
    super.initState();

    if (_isEditing) {
      _fillFromExistingReport();
    }

    _loadRegisteredPets();
  }

  void _fillFromExistingReport() {
    final report = widget.existingReport!;

    _nameController.text = report['petname']?.toString() ?? '';
    _breedController.text = report['breed']?.toString() ?? '';
    _colourController.text = report['colour']?.toString() ?? '';
    _descriptionController.text =
        report['description']?.toString() ?? '';
    _dateController.text = report['dateLost']?.toString() ?? '';

    _reportType =
        report['reportCategory']?.toString() == 'unknown'
            ? 'unknown'
            : 'registered';

    final latitude = report['latitude'];
    final longitude = report['longitude'];

    if (latitude is num && longitude is num) {
      _selectedLocation = LatLng(
        latitude.toDouble(),
        longitude.toDouble(),
      );

      _locationController.text =
          '${latitude.toStringAsFixed(6)}, '
          '${longitude.toStringAsFixed(6)}';
    }

    _selectedPetId = report['registeredPetId']?.toString();
  }

  Future<void> _loadRegisteredPets() async {
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

        if (!_isEditing && _pets.isNotEmpty) {
          _selectedPetId = _pets.first['id']?.toString();
          _fillFromSelectedPet();
        }
      });
    } catch (e) {
      debugPrint('Error loading pets: $e');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not load registered pets.'),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoadingPets = false);
      }
    }
  }

  Map<String, dynamic>? get _selectedPet {
    for (final pet in _pets) {
      if (pet['id']?.toString() == _selectedPetId) {
        return pet;
      }
    }
    return null;
  }

  void _fillFromSelectedPet() {
    final pet = _selectedPet;
    if (pet == null) return;

    _nameController.text = pet['petname']?.toString() ?? '';
    _breedController.text = pet['breed']?.toString() ?? '';
    _descriptionController.text =
        pet['description']?.toString() ?? '';
    _colourController.clear();
  }

  String? _validatePetName(String? value) {
    final name = value?.trim() ?? '';

    if (name.isEmpty) {
      if (_reportType == 'unknown') return null;
      return 'Please enter the pet name.';
    }

    if (name.length < 2 || name.length > 30) {
      return 'Name must be 2–30 characters.';
    }

    if (!RegExp(r"^[a-zA-Z][a-zA-Z .'-]*$").hasMatch(name)) {
      return 'Enter a valid pet name.';
    }

    return null;
  }


String? _validateBreed(String? value) {
  final breed = value?.trim() ?? '';

  if (breed.isEmpty) {
    return 'Please enter the pet breed.';
  }

  if (breed.length < 2 || breed.length > 40) {
    return 'Breed must be 2–40 characters.';
  }

  if (!RegExp(r"^[a-zA-Z][a-zA-Z .'-]*$").hasMatch(breed)) {
    return 'Breed must contain letters only.';
  }

  return null;
}


  String? _validateColour(String? value) {
    final colour = value?.trim() ?? '';

    if (colour.isEmpty) {
      return 'Enter the colour or type Unknown.';
    }

    if (colour.length < 2 || colour.length > 30) {
      return 'Colour must be 2–30 characters.';
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

  Future<void> _selectLastSeenLocation() async {
    final location = await Navigator.push<LatLng>(
      context,
      MaterialPageRoute(
        builder: (_) => const MapScreen(selectLocation: true),
      ),
    );

    if (!mounted || location == null) return;

    setState(() {
      _selectedLocation = location;
      _locationError = false;
      _locationController.text =
          '${location.latitude.toStringAsFixed(6)}, '
          '${location.longitude.toStringAsFixed(6)}';
    });
  }

  DateTime? _parseDate(String value) {
    final parts = value.split('/');
    if (parts.length != 3) return null;

    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);

    if (day == null || month == null || year == null) {
      return null;
    }

    if (year < 2020 || month < 1 || month > 12) {
      return null;
    }

    final date = DateTime(year, month, day);

    if (date.year != year ||
        date.month != month ||
        date.day != day) {
      return null;
    }

    return date;
  }

  Future<void> _selectDate() async {
    DateTime initialDate = DateTime.now();

    final existingDate = _parseDate(_dateController.text.trim());
    if (existingDate != null &&
        !existingDate.isAfter(DateTime.now())) {
      initialDate = existingDate;
    }

    final date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (date != null && mounted) {
      setState(() {
        _dateController.text =
            '${date.day}/${date.month}/${date.year}';
      });
    }
  }

  Future<void> _submitReport() async {
    if (_isSaving) return;

    FocusScope.of(context).unfocus();

    final report = widget.existingReport;
    final reportId = report?['id']?.toString();

    if (_isEditing &&
        (reportId == null || reportId.isEmpty)) {
      _showMessage('Could not find the report to update.');
      return;
    }

    final validForm = _formKey.currentState?.validate() ?? false;

    final dateText = _dateController.text.trim();
    final selectedDate =
        dateText.isEmpty ? null : _parseDate(dateText);

    final validDate = dateText.isEmpty ||
        (selectedDate != null &&
            !selectedDate.isAfter(DateTime.now()));

    setState(() {
      _locationError = _selectedLocation == null;
    });

    if (!validForm) return;

    if (_selectedLocation == null) {
      _showMessage('Please select the last-seen location on the map.');
      return;
    }

    if (!validDate) {
      _showMessage('Please select a valid date that is not in the future.');
      return;
    }

    setState(() => _isSaving = true);

    try {
      final petName = _nameController.text.trim().isEmpty
          ? 'Unknown Pet'
          : _nameController.text.trim();

      final breed = _breedController.text.trim();
      final colour = _colourController.text.trim();
      final description = _descriptionController.text.trim();

      if (_isEditing) {
        await _petService.updateLostPetReport(
          reportId: reportId!,
          petName: petName,
          breed: breed,
          colour: colour,
          description: description,
          latitude: _selectedLocation!.latitude,
          longitude: _selectedLocation!.longitude,
          dateLost: dateText.isEmpty ? null : dateText,
        );
      } else {
        await _petService.saveLostPetLocation(
          petName: petName,
          breed: breed,
          colour: colour,
          description: description,
          latitude: _selectedLocation!.latitude,
          longitude: _selectedLocation!.longitude,
          registeredPetId:
              _reportType == 'registered' ? _selectedPetId : null,
          reportCategory: _reportType,
          dateLost: dateText.isEmpty ? null : dateText,
        );
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEditing
                ? 'Lost pet report updated successfully!'
                : 'Lost pet report saved successfully!',
          ),
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      debugPrint('Error saving lost pet report: $e');
      _showMessage(
        _isEditing
            ? 'Could not update the report. Please try again.'
            : 'Could not save the report. Please try again.',
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _breedController.dispose();
    _colourController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          _isEditing ? 'Edit Lost Pet Report' : 'Report Lost Pet',
          style: const TextStyle(fontWeight: FontWeight.bold),
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Icon(
                        _isEditing
                            ? Icons.edit_outlined
                            : Icons.campaign_outlined,
                        size: 55,
                        color: primaryBlue,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _isEditing
                            ? 'Edit Lost Pet Details'
                            : 'Report a Lost Pet',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _isEditing
                            ? 'Update the information for this lost pet.'
                            : 'Share the pet details and last-seen location to help the community.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.black54),
                      ),
                      const SizedBox(height: 30),

                      if (!_isEditing) ...[
                        _sectionTitle('Type of Report'),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: lightBlue,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: borderBlue),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _reportType,
                              isExpanded: true,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              items: const [
                                DropdownMenuItem(
                                  value: 'registered',
                                  child: Text('My Registered Pet'),
                                ),
                                DropdownMenuItem(
                                  value: 'unknown',
                                  child: Text(
                                    'Unknown / Unregistered Pet',
                                  ),
                                ),
                              ],
                              onChanged: _isSaving
                                  ? null
                                  : (value) {
                                      if (value == null) return;

                                      setState(() {
                                        _reportType = value;

                                        if (value == 'registered') {
                                          _fillFromSelectedPet();
                                        } else {
                                          _nameController.clear();
                                          _breedController.clear();
                                          _colourController.clear();
                                          _descriptionController.clear();
                                        }

                                        _formKey.currentState?.reset();
                                      });
                                    },
                            ),
                          ),
                        ),

                        if (_reportType == 'registered') ...[
                          const SizedBox(height: 18),
                          _sectionTitle('Select Registered Pet'),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: lightBlue,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: borderBlue),
                            ),
                            child: _isLoadingPets
                                ? const Padding(
                                    padding: EdgeInsets.all(12),
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                : _pets.isEmpty
                                    ? const Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 14,
                                        ),
                                        child: Text(
                                          'No registered pets found. You can report an unknown pet instead.',
                                        ),
                                      )
                                    : DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          value: _pets.any(
                                            (pet) =>
                                                pet['id']?.toString() ==
                                                _selectedPetId,
                                          )
                                              ? _selectedPetId
                                              : null,
                                          isExpanded: true,
                                          items: _pets.map((pet) {
                                            final id =
                                                pet['id'].toString();
                                            final name =
                                                pet['petname']?.toString() ??
                                                    'Unnamed Pet';

                                            return DropdownMenuItem<String>(
                                              value: id,
                                              child: Text(name),
                                            );
                                          }).toList(),
                                          onChanged: _isSaving
                                              ? null
                                              : (value) {
                                                  if (value == null) return;

                                                  setState(() {
                                                    _selectedPetId = value;
                                                    _fillFromSelectedPet();
                                                  });
                                                },
                                        ),
                                      ),
                          ),
                        ],
                      ],

                      const SizedBox(height: 18),
                      _sectionTitle('Pet Name'),
                      _textField(
                        controller: _nameController,
                        hint: 'Pet name',
                        icon: Icons.pets,
                        validator: _validatePetName,
                        maxLength: 30,
                      ),

                      const SizedBox(height: 18),
                      _sectionTitle('Breed'),
                      _textField(
                        controller: _breedController,
                        hint: 'Enter breed or Unknown',
                        icon: Icons.pets_outlined,
                        validator: _validateBreed,
                        maxLength: 40,
                      ),

                      const SizedBox(height: 18),
                      _sectionTitle('Colour'),
                      _textField(
                        controller: _colourController,
                        hint: 'Enter colour or Unknown',
                        icon: Icons.palette_outlined,
                        validator: _validateColour,
                        maxLength: 30,
                      ),

                      const SizedBox(height: 18),
                      _sectionTitle('Description'),
                      _textField(
                        controller: _descriptionController,
                        hint: 'Other details to identify the pet',
                        icon: Icons.description_outlined,
                        maxLines: 3,
                        validator: _validateDescription,
                        maxLength: 200,
                      ),

                      const SizedBox(height: 18),
                      _sectionTitle('Last Seen Location'),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: _isSaving
                              ? null
                              : _selectLastSeenLocation,
                          icon: const Icon(
                            Icons.map_outlined,
                            color: primaryBlue,
                          ),
                          label: const Text('Select Location on Map'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: primaryBlue,
                            side: BorderSide(
                              color: _locationError
                                  ? Colors.red
                                  : borderBlue,
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _locationController,
                        readOnly: true,
                        decoration: _inputDecoration(
                          'No location selected',
                          Icons.location_on_outlined,
                        ).copyWith(
                          errorText: _locationError
                              ? 'Please select a location on the map.'
                              : null,
                        ),
                      ),

                      const SizedBox(height: 18),
                      _sectionTitle('Date Lost'),
                      TextField(
                        controller: _dateController,
                        readOnly: true,
                        onTap: _isSaving ? null : _selectDate,
                        decoration: _inputDecoration(
                          'Select date (optional)',
                          Icons.calendar_month_outlined,
                        ),
                      ),

                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: _isSaving ||
                                  (!_isEditing &&
                                      (_isLoadingPets ||
                                          (_reportType == 'registered' &&
                                              (_pets.isEmpty ||
                                                  _selectedPetId == null))))
                              ? null
                              : _submitReport,
                          icon: _isSaving
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Icon(
                                  _isEditing
                                      ? Icons.save_outlined
                                      : Icons.warning_amber_rounded,
                                ),
                          label: Text(
                            _isSaving
                                ? 'Saving Report...'
                                : _isEditing
                                    ? 'Update Report'
                                    : 'Mark as Lost',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: lightBlue,
                            foregroundColor: Colors.black87,
                            disabledBackgroundColor: lightBlue,
                            elevation: 0,
                            side: const BorderSide(color: borderBlue),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const _BarkBottomBar(currentIndex: 0),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 4, bottom: 7),
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    int maxLines = 1,
    int? maxLength,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      maxLines: maxLines,
      maxLength: maxLength,
      enabled: !_isSaving,
      decoration: _inputDecoration(hint, icon),
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: primaryBlue),
      filled: true,
      fillColor: lightBlue,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: borderBlue),
      ),
    );
  }
}



class _BarkBottomBar extends StatelessWidget {
  final int currentIndex;

  const _BarkBottomBar({required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF4169E1);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
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
          if (index == currentIndex) return;

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
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const MapScreen(),
                ),
              );
              break;

            case 2:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const BluetoothScannerScreen(),
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
      ),
    );
  }
}
