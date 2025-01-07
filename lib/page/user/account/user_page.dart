import 'package:flutter/material.dart';
import 'package:yourtailor/page/user/account/user_info_page.dart';
import 'package:yourtailor/page/user/appointment/BookingServiceAppointmentPage.dart';
import 'package:yourtailor/page/user/appointment/user_appointment/user_appointment_record_menu.dart';
import 'package:yourtailor/page/user/login-signup/user_login.dart';


class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
        backgroundColor: const Color(0xFFDFC5B0),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFDFC5B0),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(height: 1, thickness: 1, color: Colors.black),
          const SizedBox(height: 20),
          ListTile(
            leading: const Icon(Icons.person, color: Colors.black),
            title: const Text('My Profile', style: TextStyle(fontSize: 18, color: Colors.black)),
            trailing: const Icon(Icons.chevron_right, color: Colors.black),
            onTap: () {
              // Example: Replace 'userInfo' with the actual data required or pass null if not available.
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UserInfoPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today, color: Colors.black),
            title: const Text('My Appointments', style: TextStyle(fontSize: 18, color: Colors.black)),
            trailing: const Icon(Icons.chevron_right, color: Colors.black),
            // Uncomment and update this when AppointmentApp is implemented
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserAppointmentMainMenuScreen()
                ),
              );
            },
          ),
         // Uncomment and update this when UpdateServiceScreen is implemented
          ListTile(
            leading: const Icon(Icons.shopping_bag, color: Colors.black),
            title: const Text('Book Service!', style: TextStyle(fontSize: 18, color: Colors.black)),
            trailing: const Icon(Icons.chevron_right, color: Colors.black),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BookAppointment()
                ),
              );
            },
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  // Button background color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UserLoginScreen(),
                    ),
                  );
                },
                child: const Text('Log out', style: TextStyle(color: Color.fromARGB(255, 5, 5, 5))),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
