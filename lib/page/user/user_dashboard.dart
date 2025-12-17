import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yourtailor/page/user/account/user_info_page.dart';
import 'package:yourtailor/page/user/account/user_page.dart';
import 'package:yourtailor/page/user/appointment/BookingServiceAppointmentPage.dart';
import 'package:yourtailor/page/user/appointment/user_appointment/user_appointment_record_menu.dart';
import 'FAQs/FAQs_screen.dart';


class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  _UserDashboardState createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
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
        MaterialPageRoute(builder: (context) => const BookAppointment()),
      );
    } else if (index == 2) {
      // Navigate to Account
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const UserInfoPage()),
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
                MaterialPageRoute(builder: (context) => const UserPage()),
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
                          MaterialPageRoute(builder: (context) => const BookAppointment()),
                        ),
                      ),
                      _buildServiceButton(
                        context,
                        Icons.assignment,
                        'Appointment Record',
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const UserAppointmentMainMenuScreen()),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Services',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('services').snapshots(),
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
                          return ServiceCard(
                            serviceName: serviceData['serviceName'] ?? 'Unknown',
                            servicePrice: serviceData['servicePrice'] ?? '0',
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
          BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Book Now'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Account'),
        ],
        currentIndex: _defaultIndex,
        selectedItemColor: Colors.black87,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor:Colors.white,
        onPressed: () {
          Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FaqsScreen()),
                );
        },
        child: const Icon(
          Icons.help,
          color: Colors.black,
          size: 42,
        ),
      ),


    );
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
}

class ServiceCard extends StatelessWidget {
  final String serviceName;
  final String servicePrice;

  const ServiceCard({
    super.key,
    required this.serviceName,
    required this.servicePrice,
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
              serviceName,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text('Price: $servicePrice'),
          ],
        ),
      ),
    );
  }
}
