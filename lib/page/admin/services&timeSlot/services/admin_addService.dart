import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddServiceScreen extends StatefulWidget {
  const AddServiceScreen({super.key});

  @override
  _AddServiceScreen createState() => _AddServiceScreen();
}

class _AddServiceScreen extends State<AddServiceScreen> {
  final _formKey = GlobalKey<FormState>();
  String? serviceName;
  String? servicePrice;
  String? description;

  Future<void> _showConfirmationDialog() async {
    final isConfirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Confirm Add Service',
          style: GoogleFonts.roboto(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure you want to add this service?',
          style: GoogleFonts.roboto(),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, false); // Dismiss dialog and return false
            },
            child: Text('Cancel', style: GoogleFonts.roboto(color: Colors.red)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, true); // Dismiss dialog and return true
            },
            child: Text('Confirm', style: GoogleFonts.roboto(color: Colors.green)),
          ),
        ],
      ),
    );

    if (isConfirmed == true) {
      _addService();
    }
  }

  void _addService() async {
    // Ensure the form is validated before proceeding
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        // Add service details to Firestore
        final CollectionReference services = FirebaseFirestore.instance.collection('services');

        await services.add({
          'serviceName': serviceName,
          'servicePrice': servicePrice,
          'serviceInfo': description,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Service added successfully!')),
        );

        // Navigate back to the previous screen
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add service: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Service',
          style: GoogleFonts.judson(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        backgroundColor: const Color(0xFFDFC5B0),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
                child: SingleChildScrollView(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2DDCE),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Service Name',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Judson',
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                TextFormField(
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a service name';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    serviceName = value;
                                  },
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Service Price',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Judson',
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                TextFormField(
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a service price';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    servicePrice = value;
                                  },
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Description',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Judson',
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                TextFormField(
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a description';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    description = value;
                                  },
                                  maxLines: 3,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 16.0),
                            child: ElevatedButton(
                              onPressed: _showConfirmationDialog,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF4A4A4A),
                              ),
                              child: Text(
                                'Add Service',
                                style: GoogleFonts.judson(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
