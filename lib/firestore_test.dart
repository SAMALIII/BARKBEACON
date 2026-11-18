
import 'package:flutter/material.dart';
import 'services/pet_service.dart';

class FirestoreTestPage extends StatefulWidget {
  const FirestoreTestPage({super.key});

  @override
  State<FirestoreTestPage> createState() => _FirestoreTestPageState();
}

class _FirestoreTestPageState extends State<FirestoreTestPage> {
  final PetService petService = PetService();

  List<String> petNames = [];
  String message = 'Press a button to test Firestore.';
  bool loading = false;

  Future<void> loadPets() async {
    setState(() {
      loading = true;
      message = 'Loading pets...';
    });

    try {
      final names = await petService.getPetNames();

      if (!mounted) return;
      setState(() {
        petNames = names;
        message = 'Pets loaded successfully.';
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        message = 'Could not load pets: $e';
      });
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  Future<void> saveTestPet() async {
    setState(() {
      loading = true;
      message = 'Saving test pet...';
    });

    try {
      await petService.savePet('BarkBeacon Test Pet');

      if (!mounted) return;
      setState(() {
        message = 'Test pet saved! Press Load Pets to retrieve it.';
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        message = 'Could not save pet: $e';
      });
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Firestore Test')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(message),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: loading ? null : loadPets,
              child: const Text('Load Pets'),
            ),
            ElevatedButton(
              onPressed: loading ? null : saveTestPet,
              child: const Text('Save Test Pet'),
            ),
            const SizedBox(height: 16),
            const Text(
              'Pet names:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: petNames.length,
                itemBuilder: (context, index) {
                  return ListTile(title: Text(petNames[index]));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
