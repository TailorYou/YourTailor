import 'package:flutter/material.dart';
import 'package:yourtailor/page/admin/account/admin_info.dart';
import 'package:yourtailor/page/admin/admin_login/admin_login.dart';
import 'package:yourtailor/page/admin/appointments/admin_appoinment_menu.dart';
import 'package:yourtailor/page/admin/appointments/admins_edit/admin_payment_record.dart';
import 'package:yourtailor/page/admin/services&timeSlot/admin_service_menu.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
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
                  builder: (context) => const AdminInfoPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today, color: Colors.black),
            title: const Text('Appoinments Record', style: TextStyle(fontSize: 18, color: Colors.black)),
            trailing: const Icon(Icons.chevron_right, color: Colors.black),
            // Uncomment and update this when AppointmentApp is implemented
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AdminMainAppointmentScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit, color: Colors.black),
            title: const Text('Update Service', style: TextStyle(fontSize: 18, color: Colors.black)),
            trailing: const Icon(Icons.chevron_right, color: Colors.black),
            onTap: () {
              // Example: Replace 'userInfo' with the actual data required or pass null if not available.
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdminMainServiceScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.payment, color: Colors.black),
            title: const Text('Payment Record', style: TextStyle(fontSize: 18, color: Colors.black)),
            trailing: const Icon(Icons.chevron_right, color: Colors.black),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PaymentRecordScreen(),
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
                      builder: (context) => const AdminLoginScreen(),
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
