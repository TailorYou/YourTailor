import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:yourtailor/page/admin/admin_login/admin_login.dart';
import 'firebase_options.dart';
import 'page/user/login-signup/user_login.dart';
//import 'admin_login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeFirebase();
  runApp(const YourTailorApp());
}

Future<void> initializeFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions, // Replace with your actual options
  );
}

class YourTailorApp extends StatelessWidget {
  const YourTailorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YourTailor',
      theme: ThemeData(
        primaryColor: Colors.brown,
        hintColor: const Color(0xFFDFC5B0),
      ),
      home: const AuthenticationScreen(),
    );
    
  }
}

class AuthenticationScreen extends StatelessWidget {
  const AuthenticationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDFC5B0),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'YourTailor',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.brown[800],
              ),
            ),
            const SizedBox(height: 40),
            // Admin Button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AdminLoginScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.brown,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: const Text('Admin'),
            ),
            const SizedBox(height: 20),
            // Customer Button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UserLoginScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.brown,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: const Text('Customer'),
            ),
          ],
        ),
      ),
    );
  }
}
