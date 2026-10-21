
import 'package:cloud_firestore/cloud_firestore.dart';

class PetService {
  final CollectionReference<Map<String, dynamic>> petCollection =
      FirebaseFirestore.instance.collection('pet');

  // Save a test pet (kept for Firestore testing)
  Future<void> savePet(String petName) async {
    await petCollection.add({
      'petname': petName,
      'description': 'Test pet for Firestore',
      'is lost': true,
      'latitude': 7.2083,
      'longitude': 79.8358,
    });
  }

  // Retrieve pet names (kept for Firestore testing)
  Future<List<String>> getPetNames() async {
    final snapshot = await petCollection.get();

    return snapshot.docs
        .map((doc) => doc.data()['petname'] as String)
        .toList();
  }

  // Save the actual pet profile
  Future<void> savePetProfile({
    required String petName,
    required String breed,
    required String description,
  }) async {
    await petCollection.doc('my_pet_profile').set({
      'petname': petName,
      'breed': breed,
      'description': description,
    });
  }

  // Load the saved pet profile
  Future<Map<String, dynamic>?> getPetProfile() async {
    final document =
        await petCollection.doc('my_pet_profile').get();

    if (!document.exists) {
      return null;
    }

    return document.data();
  }
}
