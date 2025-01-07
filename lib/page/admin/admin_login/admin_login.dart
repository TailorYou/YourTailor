import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yourtailor/page/admin/admin_dashboard.dart';


class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  _AdminLoginScreenState createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future<void> _populateDatabase() async {
  final admins = [
    {
      'username': 'admin1',
      'email': 'admin1@gmail.com',
      'password': '123456',
      'address': '123 Main Street, Springfield',
      'dob': '1985-06-15',
      'phone': '123-456-7890',
    },
    {
      'username': 'admin2',
      'email': 'admin2@gmail.com',
      'password': '123456',
      'address': '456 Elm Street, Shelbyville',
      'dob': '1990-08-20',
      'phone': '987-654-3210',
    },
  ];

  for (var admin in admins) {
    try {
      // Check if user already exists in Firebase Auth
      final user = await FirebaseAuth.instance.fetchSignInMethodsForEmail(admin['email']!);
      if (user.isEmpty) {
        // Create user if not already in Firebase Auth
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: admin['email']!,
          password: admin['password']!,
        );
      }

      // Add user details to Firestore
      await _firestore.collection('admin_users').doc(admin['username']).set({
        'username': admin['username'],
        'email': admin['email'],
        'address': admin['address'],
        'dob': admin['dob'],
        'phone': admin['phone'],
      });
    } catch (e) {
      print('Error creating or updating admin ${admin['username']}: $e');
    }
  }
}



  @override
  void initState() {
    super.initState();
    _populateDatabase();
  }

Future<void> _login() async {
  if (_formKey.currentState!.validate()) {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      // Sign in using Firebase Authentication
      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Fetch additional user data from Firestore
      final userDoc = await _firestore
          .collection('admin_users')
          .where('email', isEqualTo: email)
          .get();

      if (userDoc.docs.isNotEmpty) {
        final userData = userDoc.docs.first.data();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Welcome back, ${userData['username']}!')),
        );

        // Navigate to AdminPage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AdminDashboard()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User data not found in Firestore.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error during login: $e')),
      );
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDFC5B0),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'YourTailor',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Times New Roman',
                ),
              ),
              const SizedBox(height: 50),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: const Icon(Icons.email),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Enter your email' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Enter your password' : null,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: const Text('Sign In', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
