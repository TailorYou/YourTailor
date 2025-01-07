import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserPastAppointmentsScreen extends StatefulWidget {
  @override
  _UserPastAppointmentsScreenState createState() =>
      _UserPastAppointmentsScreenState();
}

class _UserPastAppointmentsScreenState
    extends State<UserPastAppointmentsScreen> {
  final CollectionReference _pastAppointmentsCollection =
      FirebaseFirestore.instance.collection('pastappoint');
 final CollectionReference _userPastAppointmentsCollection =
      FirebaseFirestore.instance.collection('userpastappoint');
  final User? _currentUser = FirebaseAuth.instance.currentUser;

  List<Map<String, dynamic>> appointments = [];

  @override
  void initState() {
    super.initState();
    _fetchUserLatestPastAppointments();
  }

  Future<void> _fetchUserPastAppointments() async {
    if (_currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User not authenticated.')),
      );
      return;
    }

    try {
      QuerySnapshot snapshot = await _pastAppointmentsCollection
          .where('email', isEqualTo: _currentUser!.email)
          .get();

      setState(() {
        appointments = snapshot.docs.map((doc) {
          return {
            'id': doc.id,
            'serviceName': doc['serviceName'] ?? '',
            'appointmentDate': doc['appointmentDate'] ?? '',
            'appointmentTime': doc['appointmentTime'] ?? '',
          };
        }).toList();
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching past appointments: $error')),
      );
    }
  }
  
 Future<void> _fetchUserLatestPastAppointments() async {
    if (_currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User not authenticated.')),
      );
      return;
    }

    try {
      // Copy data from pastappoint[] to userpastappoint[] if not already copied
      QuerySnapshot originalSnapshot = await _pastAppointmentsCollection
          .where('email', isEqualTo: _currentUser!.email)
          .get();

      for (var doc in originalSnapshot.docs) {
        DocumentSnapshot existingDoc =
            await _userPastAppointmentsCollection.doc(doc.id).get();

        if (!existingDoc.exists) {
          await _userPastAppointmentsCollection.doc(doc.id).set(doc.data()!);
        }
      }

      // Fetch data from userpastappoint[]
      QuerySnapshot snapshot = await _userPastAppointmentsCollection
          .where('email', isEqualTo: _currentUser!.email)
          .get();

      setState(() {
        appointments = snapshot.docs.map((doc) {
          return {
            'id': doc.id,
            'serviceName': doc['serviceName'] ?? '',
            'appointmentDate': doc['appointmentDate'] ?? '',
            'appointmentTime': doc['appointmentTime'] ?? '',
          };
        }).toList();
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching past appointments: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Past Appointments',
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
                          'No past appointments available',
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
