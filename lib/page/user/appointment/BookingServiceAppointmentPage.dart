import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yourtailor/page/user/draft/DisplayServices.dart';
import 'package:yourtailor/page/user/draft/selectService.dart';
import 'package:yourtailor/page/user/draft/selectServiceList.dart';
import 'package:yourtailor/page/user/user_dashboard.dart';

class BookAppointment extends StatefulWidget {
  const BookAppointment({super.key});

  @override
  _BookAppointmentState createState() => _BookAppointmentState();
}

class _BookAppointmentState extends State<BookAppointment> {
  Map<String, dynamic>? selectedService;
  Map<String, dynamic>? selectedAppointment;
  String? userEmail;
  String? username;

  final CollectionReference _appointmentsCollection = FirebaseFirestore.instance.collection('appointments');
  final CollectionReference _bookappointCollection = FirebaseFirestore.instance.collection('bookappoint');

  List<Map<String, dynamic>> services = [];
  List<Map<String, dynamic>> appointments = [];

  @override
  void initState() {
    super.initState();
    selectedService = SelectService.getSelectedService(selectedService);
    _fetchServices(); // Fetch services using DisplayService
    _fetchAppointments(); // Fetch appointments
    _fetchUserData();
// Fetch the user's email
  }

  // Fetch services using DisplayService
  void _fetchServices() async {
    DisplayService displayService = DisplayService();
    try {
      List<Map<String, dynamic>> fetchedServices = await displayService.fetchServices();
      setState(() {
        services = fetchedServices;
      });
    } catch (error) {
      print("Error fetching services: $error");
    }
  }

  // Fetch appointments from Firestore
  void _fetchAppointments() async {
    try {
      QuerySnapshot querySnapshot = await _appointmentsCollection.get();
      List<Map<String, dynamic>> fetchedAppointments = querySnapshot.docs.map((doc) {
        return {
          'id': doc.id, // Firestore document ID
          'appointmentDate': doc['appointmentDate'] ?? "0000-00-00",
          'appointmentTime': doc['appointmentTime'] ?? "00:00",
        };
      }).toList();

      setState(() {
        appointments = fetchedAppointments;
      });
    } catch (error) {
      print("Error fetching appointments: $error");
    }
  }

  // Fetch the user's email from Firebase Authentication
  void _fetchUserData() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userEmail = user.email;
      });

      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        setState(() {
          username = userDoc['username'] ?? 'Guest';
        });
      } catch (error) {
        print("Error fetching user data: $error");
      }
    }
  }

  // Function to save the booking to Firestore
  void _saveBooking() async {
    if (selectedService == null || selectedAppointment == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a service and appointment time.')),
      );
      return;
    }

    // Show alert dialog before confirming the booking
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Booking'),
          content: Text(
            'Confirm to book the service: ${selectedService!['serviceName']}\n'
            'Appointment Date: ${selectedAppointment!['appointmentDate']} - '
            '${selectedAppointment!['appointmentTime']}',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  // Get the current timestamp
                  String bookingTime = DateTime.now().toIso8601String();

                  // Save the booking data to Firestore
                  await _bookappointCollection.add({
                    'username': username,
                    'email': userEmail,
                    'serviceName': selectedService!['serviceName'],
                    'appointmentDate': selectedAppointment!['appointmentDate'],
                    'appointmentTime': selectedAppointment!['appointmentTime'],
                    'bookingTime': bookingTime,
                  });

                  // Remove the selected appointment from Firestore
                  if (selectedAppointment!['id'] != null) {
                    await _appointmentsCollection.doc(selectedAppointment!['id']).delete();
                  }

                  setState(() {
                    appointments.remove(selectedAppointment);
                    selectedAppointment = null; // Reset the selected appointment
                  });

                  // Show a success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Booking confirmed successfully!')),
                  );

                  // Navigate to UserDashboard after booking confirmation
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const UserDashboard()),
                  );
                } catch (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $error')),
                  );
                }
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFDFC5B0),
        title: const Text('Service Booking'),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: const Color(0xFFDFC5B0),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/jarum.png',
                          width: 50,
                          height: 50,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          "YourTailor",
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Welcome to the booking page!",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFD2B29C),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'How to Book:\n'
                  '1. Choose your service and select an appointment date.\n'
                  '2. You can send your garment to our place (if you use your own material).\n'
                  '3. You will need to come at the selected time slot.',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFD2B29C),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Services",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    if (services.isEmpty)
                      const Center(child: CircularProgressIndicator())
                    else
                      ...services.map((service) => ListTile(
                            title: Text(service['serviceName'] ?? 'Unknown'),
                            trailing: const Icon(Icons.arrow_forward_ios),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SelectServiceList(service: service),
                                ),
                              );
                            },
                          )),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Available Time Slots",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 2,
                ),
                itemCount: appointments.length,
                itemBuilder: (context, index) {
                  var appointment = appointments[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5,
                    color: Colors.green,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          selectedAppointment = appointment;
                        });
                      },
                      child: Center(
                        child: Text(
                          "${appointment['appointmentDate']} - ${appointment['appointmentTime']}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const UserDashboard()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 190, 143, 127),
                    ),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: _saveBooking,
                    child: const Text('Confirm Booking'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
