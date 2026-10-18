
import 'package:cloud_firestore/cloud_firestore.dart';

class PetService {
  final CollectionReference<Map<String, dynamic>> petCollection =
      FirebaseFirestore.instance.collection('pet');

  // Save a test pet
  Future<void> savePet(String petName) async {
    await petCollection.add({
      'petname': petName,
      'description': 'Test pet for Firestore',
      'is lost': true,
      'latitude': 7.2083,
      'longitude': 79.8358,
    });
  }

  // Retrieve pet names
  Future<List<String>> getPetNames() async {
    final snapshot = await petCollection.get();

    return snapshot.docs
        .map((doc) => doc.data()['petname'] as String)
        .toList();
  }
}
