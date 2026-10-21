import 'package:flutter/material.dart';

class ReportLostScreen extends StatefulWidget {
  const ReportLostScreen({super.key});

  @override
  State<ReportLostScreen> createState() => _ReportLostScreenState();
}

class _ReportLostScreenState extends State<ReportLostScreen> {
  static const Color primaryBlue = Color(0xFF4169E1);
  static const Color lightBlue = Color(0xFFEAF4FF);

  final TextEditingController _locationController =
      TextEditingController();

  final TextEditingController _dateController =
      TextEditingController();

  String selectedPet = 'Milo';

  @override
  void dispose() {
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
        title: const Text(
          'Report Lost Pet',
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 15,
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.campaign_outlined,
                      size: 55,
                      color: primaryBlue,
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      'Mark Your Pet as Lost',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'This will notify the community and help others keep an eye out.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black54,
                      ),
                    ),

                    const SizedBox(height: 30),

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
                        border: Border.all(
                          color: const Color(0xFF8CB4E8),
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedPet,
                          isExpanded: true,
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'Milo',
                              child: Text('Milo'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                selectedPet = value;
                              });
                            }
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    _sectionTitle('Last Seen Location'),

                    TextField(
                      controller: _locationController,
                      decoration: _inputDecoration(
                        'Enter location (optional)',
                        Icons.location_on_outlined,
                      ),
                    ),

                    const SizedBox(height: 18),

                    _sectionTitle('Date Lost'),

                    TextField(
                      controller: _dateController,
                      readOnly: true,
                      decoration: _inputDecoration(
                        'Select date (optional)',
                        Icons.calendar_month_outlined,
                      ),
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now(),
                        );

                        if (date != null) {
                          _dateController.text =
                              '${date.day}/${date.month}/${date.year}';
                        }
                      },
                    ),

                    const SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            SnackBar(
                              content: Text(
                                '$selectedPet has been marked as lost in this prototype.',
                              ),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.warning_amber_rounded,
                        ),
                        label: const Text(
                          'Mark as Lost',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
                      ),
                    ),
                  ],
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
        padding: const EdgeInsets.only(
          left: 4,
          bottom: 7,
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(
    String hint,
    IconData icon,
  ) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(
        icon,
        color: primaryBlue,
      ),
      filled: true,
      fillColor: lightBlue,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(
          color: Color(0xFF8CB4E8),
        ),
      ),
    );
  }
}

class _BarkBottomBar extends StatelessWidget {
  final int currentIndex;

  const _BarkBottomBar({
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
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