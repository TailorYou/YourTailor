import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminTimeSlotScreen extends StatefulWidget {
  const AdminTimeSlotScreen({super.key});

  @override
  _AdminTimeSlotScreenState createState() => _AdminTimeSlotScreenState();
}

class _AdminTimeSlotScreenState extends State<AdminTimeSlotScreen> {
  final CollectionReference _appointmentsCollection =
      FirebaseFirestore.instance.collection('appointments');

  List<Map<String, dynamic>> appointments = [];

  @override
  void initState() {
    super.initState();
    _fetchAppointments();
  }

  // Fetch appointments from Firestore
  Future<void> _fetchAppointments() async {
    try {
      QuerySnapshot snapshot = await _appointmentsCollection.get();
      setState(() {
        appointments = snapshot.docs.map((doc) {
          return {
            'id': doc.id,
            'appointmentDate': doc['appointmentDate'] ?? '',
            'appointmentTime': doc['appointmentTime'] ?? '',
          };
        }).toList();
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching appointments: $error')),
      );
    }
  }

  // Delete a time slot
  Future<void> _deleteTimeSlot(int index) async {
    final appointmentId = appointments[index]['id'];
    try {
      await _appointmentsCollection.doc(appointmentId).delete();
      setState(() {
        appointments.removeAt(index);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Time slot deleted successfully!')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete time slot: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Appointments Time Slots',
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
              Text(
                'Time Slots',
                style: GoogleFonts.italiana(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: appointments.isEmpty
                    ? const Center(
                        child: Text(
                          'No time slots available',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      )
                    : ListView.builder(
                        itemCount: appointments.length,
                        itemBuilder: (context, index) {
                          final appointment = appointments[index];
                          return Card(
                            color: const Color(0xFFF2DDCE),
                            margin: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              title: Text(
                                "Date: ${appointment['appointmentDate']}\nTime: ${appointment['appointmentTime']}",
                                style: const TextStyle(fontSize: 14),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete,
                                    color: Colors.redAccent),
                                onPressed: () => _deleteTimeSlot(index),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
