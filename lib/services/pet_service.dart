
import 'package:cloud_firestore/cloud_firestore.dart';

class PetService {
  final CollectionReference<Map<String, dynamic>> petCollection =
      FirebaseFirestore.instance.collection('pet');

  Future<void> savePet(String petName) async {
    await petCollection.add({
      'petname': petName,
      'description': 'Test pet for Firestore',
      'is lost': true,
      'latitude': 7.2083,
      'longitude': 79.8358,
    });
  }

  Future<List<String>> getPetNames() async {
    final snapshot = await petCollection.get();

    return snapshot.docs
        .where((doc) => doc.data().containsKey('petname'))
        .map((doc) => doc.data()['petname'].toString())
        .toList();
  }

  Future<String> addPetProfile({
    required String petName,
    required String breed,
    required String description,
  }) async {
    final document = await petCollection.add({
      'petname': petName,
      'breed': breed,
      'description': description,
      'recordType': 'pet_profile',
      'createdAt': FieldValue.serverTimestamp(),
    });

    return document.id;
  }

  Future<void> updatePetProfile({
    required String petId,
    required String petName,
    required String breed,
    required String description,
  }) async {
    await petCollection.doc(petId).update({
      'petname': petName,
      'breed': breed,
      'description': description,
    });
  }

  Future<List<Map<String, dynamic>>> getPetProfiles() async {
    final snapshot = await petCollection
        .where('recordType', isEqualTo: 'pet_profile')
        .get();

    return snapshot.docs.map((doc) {
      return {'id': doc.id, ...doc.data()};
    }).toList();
  }

  Future<Map<String, dynamic>?> getPetProfile() async {
    final document = await petCollection.doc('my_pet_profile').get();

    if (!document.exists) return null;

    return document.data();
  }

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

  // Create a new lost-pet report.
  Future<String> saveLostPetLocation({
    required String petName,
    required String description,
    required double latitude,
    required double longitude,
    String breed = 'Unknown',
    String colour = 'Unknown',
    String? registeredPetId,
    String reportCategory = 'registered',
    String? dateLost,
  }) async {
    final document = await petCollection.add({
      'petname': petName,
      'breed': breed,
      'colour': colour,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'reportType': 'lost_pet',
      'reportCategory': reportCategory,
      'registeredPetId': registeredPetId,
      'dateLost': dateLost,
      'status': 'lost',
      'is lost': true,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    return document.id;
  }

  // Retrieve reports, including older reports without a status.
  // Found reports are excluded from active map markers.
  Future<List<Map<String, dynamic>>> getLostPetLocations() async {
    final snapshot = await petCollection
        .where('reportType', isEqualTo: 'lost_pet')
        .get();

    return snapshot.docs
        .where((doc) {
          final data = doc.data();
          final status = data['status'];

          return status != 'found' && data['is lost'] != false;
        })
        .map((doc) => {'id': doc.id, ...doc.data()})
        .toList();
  }

  // Edit an existing report without creating a duplicate.
  Future<void> updateLostPetReport({
    required String reportId,
    required String petName,
    required String breed,
    required String colour,
    required String description,
    required double latitude,
    required double longitude,
    String? dateLost,
  }) async {
    await petCollection.doc(reportId).update({
      'petname': petName,
      'breed': breed,
      'colour': colour,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'dateLost': dateLost,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Mark an existing report as found; retain its history in Firebase.
  Future<void> markLostPetAsFound(String reportId) async {
    await petCollection.doc(reportId).update({
      'status': 'found',
      'is lost': false,
      'foundAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}
