import 'package:cloud_firestore/cloud_firestore.dart';

class DisplayService {
  final CollectionReference _servicesCollection = FirebaseFirestore.instance.collection('services');

  Future<List<Map<String, dynamic>>> fetchServices() async {
    List<Map<String, dynamic>> services = [];
    try {
      // Fetch all documents from the 'services' collection
      QuerySnapshot querySnapshot = await _servicesCollection.get();

      // Loop through each document and extract data
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        services.add({
          'serviceName': data['serviceName'] ?? 'Unknown',
          'servicePrice': data['servicePrice']?.toString() ?? '0.0',
          'serviceInfo': data['serviceInfo'] ?? 'No info available',
        });
      }
    } catch (error) {
      print('Error fetching services: $error');
    }
    return services;
  }
}
