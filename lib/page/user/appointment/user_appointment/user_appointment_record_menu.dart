import 'package:flutter/material.dart';
import 'package:yourtailor/page/user/appointment/user_appointment/edit_appointment/user_cancel_appointment.dart';
import 'package:yourtailor/page/user/appointment/user_appointment/edit_appointment/user_delete_PastAppoint.dart';
import 'package:yourtailor/page/user/appointment/user_appointment/edit_appointment/user_pastAppoint.dart';
import 'package:yourtailor/page/user/appointment/user_appointment/edit_appointment/user_upcomingAppoint.dart';




class UserAppointmentMainMenuScreen extends StatelessWidget {
  const UserAppointmentMainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDFC5B0),
      appBar: AppBar(
        backgroundColor: const Color(0xFFDFC5B0),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Appointment Record',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          Center(
            child: Column(
              children: [
                Image.asset(
                  'assets/jarum.png',///hii qeela
                  width: MediaQuery.of(context).size.width * 0.3, // 80% of the screen width
                  height: MediaQuery.of(context).size.height * 0.2, // 40% of the screen height
                  fit: BoxFit.contain, // Scales while preserving aspect ratio
                  ),
                const Text(
                  'YourTailor',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 20),
                // Buttons List
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDF0E3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      _buildMenuItem(context, 'View Upcoming Appointments',
                           UserUpcomingAppointmentsScreen()),
                      _buildDivider(),
                      _buildMenuItem(context, 'Cancel Appointments', 
                           CancelAppointmentScreen()),
                      _buildDivider(),
                      _buildMenuItem(
                          context, 'Past Appointments', 
                          UserPastAppointmentsScreen()),
                          _buildDivider(),
                      _buildMenuItem(
                          context, 'Delete Past Appointments', 
                          UserDeletePastAppointmentsScreen()),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, String title, Widget page) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.black),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.grey[300],
    );
  }
}

