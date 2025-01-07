import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CancelAppointmentScreen extends StatefulWidget {
  @override
  _CancelAppointmentScreenState createState() =>
      _CancelAppointmentScreenState();
}

class _CancelAppointmentScreenState extends State<CancelAppointmentScreen> {
  final CollectionReference _bookAppointmentsCollection =
      FirebaseFirestore.instance.collection('bookappoint');

  List<Map<String, dynamic>> userAppointments = [];
  late String userEmail;

  @override
  void initState() {
    super.initState();
    _getUserEmail();
  }

  // Get the current user's email
  Future<void> _getUserEmail() async {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      setState(() {
        userEmail = user.email!;
      });

      // Fetch appointments after getting the email
      _fetchUserAppointments();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No user is currently logged in.')),
      );
    }
  }

  // Fetch appointments for the logged-in user
  Future<void> _fetchUserAppointments() async {
    try {
      QuerySnapshot snapshot = await _bookAppointmentsCollection
          .where('email', isEqualTo: userEmail)
          .get();

      setState(() {
        userAppointments = snapshot.docs.map((doc) {
          return {
            'id': doc.id,
            'username': doc['username'] ?? '',
            'email': doc['email'] ?? '',
            'serviceName': doc['serviceName'] ?? '',
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

  // Cancel an appointment
  Future<void> _cancelAppointment(Map<String, dynamic> appointment) async {
    try {
      await FirebaseFirestore.instance
          .collection('bookappoint')
          .doc(appointment['id'])
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Appointment for ${appointment['serviceName']} on ${appointment['appointmentDate']} canceled successfully.'),
        ),
      );

      _fetchUserAppointments(); // Refresh the list
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error canceling appointment: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cancel Appointment',
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
              Text(
                'Your Appointments',
                style: GoogleFonts.italiana(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: userAppointments.isEmpty
                    ? Center(
                        child: Text(
                          'No appointments found',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      )
                    : ListView.builder(
                        itemCount: userAppointments.length,
                        itemBuilder: (context, index) {
                          final appointment = userAppointments[index];
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
                              trailing: IconButton(
                                icon: Icon(Icons.cancel, color: Colors.red),
                                onPressed: () {
                                  _cancelAppointment(appointment);
                                },
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
