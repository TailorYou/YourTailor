import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yourtailor/page/admin/account/admin_info.dart';
import 'package:yourtailor/page/admin/account/admin_page.dart';
import 'package:yourtailor/page/admin/appointments/admin_appoinment_menu.dart';
import 'package:yourtailor/page/admin/services&timeSlot/admin_service_menu.dart';
import 'package:yourtailor/page/admin/services&timeSlot/services/admin_addService.dart';


class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final int _defaultIndex = 0;

  // Flag to prevent multiple navigation
  bool _isNavigating = false;

  void _onItemTapped(int index) async {
    if (_isNavigating) return; // Prevent multiple clicks during navigation

    setState(() {
      _isNavigating = true;
    });

    if (index == 1) {
      // Navigate to Add Service
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AddServiceScreen()),
      );
    } else if (index == 2) {
      // Navigate to Account
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AdminInfoPage()),
      );
    }

    // Ensure the navigation bar always resets to the Home tab
    setState(() {
      _isNavigating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFDFC5B0),
        elevation: 0,
        title: const Row(
          children: [
            Icon(Icons.design_services, color: Colors.black87),
            SizedBox(width: 10),
            Text(
              'YourTailor',
              style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black87),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AdminPage()),
              ); // Handle actions
            },
          ),
        ],
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
                  const Text(
                    'Welcome back!',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildServiceButton(
                        context,
                        Icons.event,
                        'Service Booking',
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AdminMainServiceScreen()),
                        ),
                      ),
                      _buildServiceButton(
                        context,
                        Icons.assignment,
                        'Appointment Record',
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AdminMainAppointmentScreen()),
                        ),
                      ),
                    ],
                  ),
                  const Text(
                    'Your Upcoming Appointments!',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('bookappoint').snapshots(),
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
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: services.length,
                        itemBuilder: (context, index) {
                          final serviceData = services[index].data() as Map<String, dynamic>;
                          return AppointmentCard(
                            appointmentDate: serviceData['appointmentDate'] ?? 'Unknown Date',
                            appointmentTime: serviceData['appointmentTime'] ?? 'Unknown Time',
                            serviceName: serviceData['serviceName'] ?? 'Unknown Service',
                            username: serviceData['username'] ?? 'Unknown User',
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
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: 'Add Service'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Account'),
        ],
        currentIndex: _defaultIndex,
        selectedItemColor: Colors.black87,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}

class AppointmentCard extends StatelessWidget {
  final String appointmentDate;
  final String appointmentTime;
  final String serviceName;
  final String username;

  const AppointmentCard({
    super.key,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.serviceName,
    required this.username,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              appointmentDate,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text('Time: $appointmentTime'),
            Text('Customer Name: $username'),
            Text('Services: $serviceName'),
          ],
        ),
      ),
    );
  }
}

  Widget _buildServiceButton(BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            minimumSize: const Size(50, 50),
          ),
          child: Icon(icon, color: Colors.black87, size: 24),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 10)),
      ],
    );
  }
