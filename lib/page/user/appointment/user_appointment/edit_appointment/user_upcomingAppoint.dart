import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserUpcomingAppointmentsScreen extends StatefulWidget {
  @override
  _UserUpcomingAppointmentsScreenState createState() =>
      _UserUpcomingAppointmentsScreenState();
}

class _UserUpcomingAppointmentsScreenState
    extends State<UserUpcomingAppointmentsScreen> {
  final CollectionReference _bookAppointmentsCollection =
      FirebaseFirestore.instance.collection('bookappoint');
  final User? _currentUser = FirebaseAuth.instance.currentUser;

  List<Map<String, dynamic>> appointments = [];

  @override
  void initState() {
    super.initState();
    _fetchUserUpcomingAppointments();
  }

  Future<void> _fetchUserUpcomingAppointments() async {
    if (_currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User not authenticated.')),
      );
      return;
    }

    try {
      QuerySnapshot snapshot = await _bookAppointmentsCollection
          .where('email', isEqualTo: _currentUser!.email)
          .get();

      DateTime currentDate = DateTime.now();
      setState(() {
        appointments = snapshot.docs.map((doc) {
          final appointmentDate = DateTime.parse(doc['appointmentDate']);
          if (appointmentDate.isAfter(currentDate)) {
            return {
              'id': doc.id,
              'serviceName': doc['serviceName'] ?? '',
              'appointmentDate': doc['appointmentDate'] ?? '',
              'appointmentTime': doc['appointmentTime'] ?? '',
            };
          } else {
            return null;
          }
        }).where((appointment) => appointment != null).cast<Map<String, dynamic>>().toList();
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching upcoming appointments: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Upcoming Appointments',
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
          preferredSize: Size.fromHeight(1.0),
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
              SizedBox(height: 20),
              Expanded(
                child: appointments.isEmpty
                    ? Center(
                        child: Text(
                          'No upcoming appointments available',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      )
                    : ListView.builder(
                        itemCount: appointments.length,
                        itemBuilder: (context, index) {
                          final appointment = appointments[index];
                          return Card(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            margin: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              title: Text(
                                "Service: ${appointment['serviceName']}\n"
                                "Date: ${appointment['appointmentDate']}\n"
                                "Time: ${appointment['appointmentTime']}",
                                style: const TextStyle(fontSize: 14),
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
