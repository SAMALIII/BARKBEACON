
import 'package:flutter/material.dart';
import '../services/pet_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Existing colors (still used by inputs and bottom nav)
  static const Color primaryBlue = Color(0xFF4169E1);
  static const Color lightBlue = Color(0xFFEAF4FF);

  // New palette
  static const Color navy = Color(0xFF142B52);
  static const Color electricBlue = Color(0xFF2563EB);
  static const Color softBackground = Color(0xFFE8F0FF);
  static const Color amber = Color(0xFFF59E0B);

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
      body: CustomPaint(
        painter: _PawPatternPainter(color: navy.withOpacity(0.06)),
        child: SafeArea(
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
                          // ---- New avatar ----
                          Container(
                            width: 130,
                            height: 130,
                            padding: const EdgeInsets.all(32),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: softBackground,
                              border: Border.all(
                                color: electricBlue,
                                width: 3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: electricBlue.withOpacity(0.18),
                                  blurRadius: 16,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: CustomPaint(
                              painter: _PawPainter(color: navy),
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
                                                color: Colors.white,
                                              ),
                                            )
                                          : const Text('Save Pet'),
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

                            // ---- New pet tiles + add tile ----
                            ..._pets.map(_petTile),
                            _addPetTile(),
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
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Pet tile
  // ---------------------------------------------------------------------------
  Widget _petTile(Map<String, dynamic> pet) {
    final name = pet['petname']?.toString().trim() ?? '';
    final breed = pet['breed']?.toString().trim() ?? '';
    final description = pet['description']?.toString().trim() ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: softBackground, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: navy.withOpacity(0.08),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: softBackground,
                  ),
                  child: const Icon(
                    Icons.pets,
                    color: electricBlue,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name.isNotEmpty ? name : 'Unnamed Pet',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: navy,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: softBackground,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          breed.isNotEmpty ? breed : 'Breed not provided',
                          style: const TextStyle(
                            color: electricBlue,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Edit',
                  onPressed:
                      _isSaving ? null : () => _startEditingPet(pet),
                  icon: const Icon(Icons.edit_outlined, color: navy),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Divider(height: 1, color: Colors.grey.shade200),
            const SizedBox(height: 12),
            const Text(
              'ABOUT',
              style: TextStyle(
                color: amber,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description.isNotEmpty
                  ? description
                  : 'No description provided',
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // "Add another pet" tile
  // ---------------------------------------------------------------------------
  Widget _addPetTile() {
    final disabled = _isSaving;

    return Opacity(
      opacity: disabled ? 0.5 : 1,
      child: CustomPaint(
        painter: const _DashedBorderPainter(
          color: electricBlue,
          radius: 16,
        ),
        child: Material(
          color: softBackground.withOpacity(0.5),
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: disabled ? null : _startAddingPet,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 20,
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: electricBlue,
                    ),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Add another pet',
                          style: TextStyle(
                            color: navy,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Register a new companion',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: navy),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Styles
  // ---------------------------------------------------------------------------
  ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: navy,
      foregroundColor: Colors.white,
      disabledBackgroundColor: navy.withOpacity(0.4),
      disabledForegroundColor: Colors.white70,
      elevation: 0,
      textStyle: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.3,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
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

// -----------------------------------------------------------------------------
// Custom painters (outside the State class)
// -----------------------------------------------------------------------------
class _PawPainter extends CustomPainter {
  final Color color;
  const _PawPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final w = size.width;
    final h = size.height;

    void toe(double cx, double cy, double tw, double th, double angle) {
      canvas.save();
      canvas.translate(cx * w, cy * h);
      canvas.rotate(angle);
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset.zero,
          width: tw * w,
          height: th * h,
        ),
        paint,
      );
      canvas.restore();
    }

    // Four toes
    toe(0.14, 0.45, 0.20, 0.30, -0.50);
    toe(0.36, 0.17, 0.21, 0.32, -0.12);
    toe(0.64, 0.17, 0.21, 0.32, 0.12);
    toe(0.86, 0.45, 0.20, 0.30, 0.50);

    // Main pad
    final pad = Path()
      ..moveTo(0.50 * w, 0.42 * h)
      ..cubicTo(0.62 * w, 0.42 * h, 0.70 * w, 0.55 * h, 0.80 * w, 0.66 * h)
      ..cubicTo(0.90 * w, 0.77 * h, 0.86 * w, 0.92 * h, 0.70 * w, 0.93 * h)
      ..cubicTo(0.60 * w, 0.94 * h, 0.55 * w, 0.88 * h, 0.50 * w, 0.88 * h)
      ..cubicTo(0.45 * w, 0.88 * h, 0.40 * w, 0.94 * h, 0.30 * w, 0.93 * h)
      ..cubicTo(0.14 * w, 0.92 * h, 0.10 * w, 0.77 * h, 0.20 * w, 0.66 * h)
      ..cubicTo(0.30 * w, 0.55 * h, 0.38 * w, 0.42 * h, 0.50 * w, 0.42 * h)
      ..close();
    canvas.drawPath(pad, paint);
  }

  @override
  bool shouldRepaint(covariant _PawPainter oldDelegate) =>
      oldDelegate.color != color;
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double radius;
  const _DashedBorderPainter({required this.color, required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Offset.zero & size,
          Radius.circular(radius),
        ),
      );

    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        canvas.drawPath(metric.extractPath(distance, distance + 6), paint);
        distance += 10;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.radius != radius;
}

// Subtle repeating paw-print background
class _PawPatternPainter extends CustomPainter {
  final Color color;
  const _PawPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    const double spacing = 96;
    const double pawSize = 28;
    final paw = _PawPainter(color: color);

    int row = 0;
    for (double y = 24; y < size.height + spacing; y += spacing, row++) {
      final xShift = row.isEven ? 0.0 : spacing / 2;
      int col = 0;
      for (double x = xShift + 20;
          x < size.width + spacing;
          x += spacing, col++) {
        final angle = (((row * 3 + col * 5) % 7) - 3) * 0.18;
        canvas.save();
        canvas.translate(x, y);
        canvas.rotate(angle);
        canvas.translate(-pawSize / 2, -pawSize / 2);
        paw.paint(canvas, const Size(pawSize, pawSize));
        canvas.restore();
      }
    }
  }

  @override
  bool shouldRepaint(covariant _PawPatternPainter oldDelegate) =>
      oldDelegate.color != color;
}
