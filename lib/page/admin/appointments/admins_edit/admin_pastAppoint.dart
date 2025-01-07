import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminPastAppointmentsScreen extends StatefulWidget {
  @override
  _AdminPastAppointmentsScreenState createState() =>
      _AdminPastAppointmentsScreenState();
}

class _AdminPastAppointmentsScreenState
    extends State<AdminPastAppointmentsScreen> {
  final CollectionReference _bookAppointmentsCollection =
      FirebaseFirestore.instance.collection('bookappoint');
  final CollectionReference _pastAppointmentsCollection =
      FirebaseFirestore.instance.collection('pastappoint');
  final CollectionReference _adminPastAppointmentsCollection =
      FirebaseFirestore.instance.collection('adminpastappoint');
  

  List<Map<String, dynamic>> appointments = [];

  @override
  void initState() {
    super.initState();
    _fetchAdminLatestPastAppointments();
  }

  // Fetch and process appointments
  Future<void> _fetchAndProcessAppointments() async {
    try {
      QuerySnapshot snapshot = await _bookAppointmentsCollection.get();
      List<Map<String, dynamic>> allAppointments = snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'username': doc['username'] ?? '',
          'email': doc['email'] ?? '',
          'serviceName': doc['serviceName'] ?? '',
          'appointmentDate': doc['appointmentDate'] ?? '',
          'appointmentTime': doc['appointmentTime'] ?? '',
        };
      }).toList();

      DateTime currentDate = DateTime.now();

      for (var appointment in allAppointments) {
        DateTime appointmentDate = DateTime.parse(appointment['appointmentDate']);

        if (appointmentDate.isBefore(currentDate)) {
          // Push to pastappoint and remove from bookappoint
          await _pastAppointmentsCollection.add({
            'username': appointment['username'],
            'email': appointment['email'],
            'serviceName': appointment['serviceName'],
            'appointmentDate': appointment['appointmentDate'],
            'appointmentTime': appointment['appointmentTime'],
          });

          await _bookAppointmentsCollection.doc(appointment['id']).delete();
        }
      }

      // Refresh the list of remaining appointments
      _fetchBookedAppointments();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error processing appointments: $error')),
      );
    }
  }

  // Fetch remaining appointments
  Future<void> _fetchBookedAppointments() async {
  try {
    QuerySnapshot snapshot = await _pastAppointmentsCollection.get();
    setState(() {
      appointments = snapshot.docs.map((doc) {
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
      SnackBar(content: Text('Error fetching past appointments: $error')),
    );
  }
}

Future<void> _fetchPastAppointments() async {
  try {
    QuerySnapshot snapshot = await _pastAppointmentsCollection.get();
    setState(() {
      appointments = snapshot.docs.map((doc) {
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
      SnackBar(content: Text('Error fetching past appointments: $error')),
    );
  }
}


  Future<void> moveToPastAppointments(Map<String, dynamic> appointment) async {
    try {
      // Add the appointment to `pastappoint[]`
      await FirebaseFirestore.instance.collection('pastappoint').add(appointment);

      // Delete the appointment from `bookappoint[]`
      await FirebaseFirestore.instance
          .collection('bookappoint')
          .doc(appointment['id']) // Ensure the ID is passed correctly
          .delete();

      print('Appointment moved to pastappoint[] and deleted from bookappoint[].');
    } catch (error) {
      print('Error moving appointment: $error');
    }
  }

  Future<void> processAppointments() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('bookappoint')
          .get();

      for (var doc in snapshot.docs) {
        final appointment = doc.data() as Map<String, dynamic>;
        final appointmentDate = DateTime.parse(appointment['appointmentDate']);
        if (appointmentDate.isBefore(DateTime.now())) {
          // Add the ID to the appointment map for deletion
          appointment['id'] = doc.id;

          // Move the appointment to `pastappoint[]`
          await moveToPastAppointments(appointment);
        }
      }
    } catch (error) {
      print('Error processing appointments: $error');
    }
  }

  Future<void> _fetchAdminLatestPastAppointments() async {
  try {
    // Fetch past appointments from the main collection
    QuerySnapshot originalSnapshot = await _pastAppointmentsCollection.get();

    for (var doc in originalSnapshot.docs) {
      DocumentSnapshot existingDoc =
          await _adminPastAppointmentsCollection.doc(doc.id).get();

      if (!existingDoc.exists) {
        await _adminPastAppointmentsCollection.doc(doc.id).set(doc.data()!);
        print('Copied to adminpastappoint: ${doc.data()}');
      } else {
        print('Already exists in adminpastappoint: ${doc.id}');
      }
    }

    // Fetch data from the admin-specific past appointments collection
    QuerySnapshot snapshot = await _adminPastAppointmentsCollection.get();

    // Log fetched data
    print('Fetched adminpastappoint documents: ${snapshot.docs.length}');

    setState(() {
      appointments = snapshot.docs.map((doc) {
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
      SnackBar(content: Text('Error fetching past appointments: $error')),
    );
    print('Error fetching adminpastappoint: $error');
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Past Appointments',
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
                                "User: ${appointment['username']}\n"
                                "Email: ${appointment['email']}\n"
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
