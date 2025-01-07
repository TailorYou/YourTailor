import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminDeletePastAppoint extends StatefulWidget {
  const AdminDeletePastAppoint({super.key});

  @override
  _AdminDeletePastAppointState createState() => _AdminDeletePastAppointState();
}

class _AdminDeletePastAppointState extends State<AdminDeletePastAppoint> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Delete Past Appointments',
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            width: double.infinity,
            height: constraints.maxHeight,
            decoration: const BoxDecoration(
              color: Color(0xFFDFC5B0),
            ),
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    'Your Past Appointments!',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('adminpastappoint').snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return const Center(child: Text('Error loading appointments'));
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(child: Text('No appointments available'));
                      }
                      final appointments = snapshot.data!.docs;
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: appointments.length,
                        itemBuilder: (context, index) {
                          final appointmentDoc = appointments[index];
                          final appointmentData = appointmentDoc.data() as Map<String, dynamic>;
                          return AppointmentCard(
                            appointmentDate: appointmentData['appointmentDate'] ?? 'Unknown Date',
                            appointmentTime: appointmentData['appointmentTime'] ?? 'Unknown Time',
                            serviceName: appointmentData['serviceName'] ?? 'Unknown Service',
                            username: appointmentData['username'] ?? 'Unknown User',
                            onDelete: () async {
                              await _deleteAppointment(appointmentDoc.id);
                            },
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _deleteAppointment(String docId) async {
    try {
      await FirebaseFirestore.instance.collection('adminpastappoint').doc(docId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Appointment deleted successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete appointment: $e')),
      );
    }
  }
}

class AppointmentCard extends StatelessWidget {
  final String appointmentDate;
  final String appointmentTime;
  final String serviceName;
  final String username;
  final VoidCallback onDelete;

  const AppointmentCard({
    super.key,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.serviceName,
    required this.username,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Date: $appointmentDate',
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text('Time: $appointmentTime'),
                  Text('Customer Name: $username'),
                  Text('Service: $serviceName'),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
