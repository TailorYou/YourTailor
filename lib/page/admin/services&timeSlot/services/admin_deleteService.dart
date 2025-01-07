import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EditServiceScreen extends StatefulWidget {
  const EditServiceScreen({super.key});

  @override
  _EditServiceScreenState createState() => _EditServiceScreenState();
}

class _EditServiceScreenState extends State<EditServiceScreen> {
  final CollectionReference _servicesCollection =
      FirebaseFirestore.instance.collection('services');

  // Function to delete a service
  Future<void> _deleteService(String docId) async {
    try {
      await _servicesCollection.doc(docId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Service deleted successfully!')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting service: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFDFC5B0),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Delete Service',
          style: GoogleFonts.judson(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.black,
            height: 1.0,
          ),
        ),
      ),
      body: Container(
        color: const Color(0xFFDFC5B0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: Text(
                'YourTailor',
                style: GoogleFonts.italiana(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _servicesCollection.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return const Center(child: Text('Error loading services'));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No services available'));
                  }

                  final services = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: services.length,
                    itemBuilder: (context, index) {
                      final serviceData = services[index].data() as Map<String, dynamic>;
                      final serviceName = serviceData['serviceName'] ?? 'Unknown';
                      final servicePrice = serviceData['servicePrice'] ?? '0';
                      final docId = services[index].id;

                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF2DDCE),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: ListTile(
                          title: Text(
                            serviceName,
                            style: GoogleFonts.exo(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                          subtitle: Text(
                            'Price: RM $servicePrice',
                            style: GoogleFonts.exo(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.black),
                            onPressed: () {
                              _deleteService(docId);
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
