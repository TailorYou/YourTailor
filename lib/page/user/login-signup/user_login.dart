import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yourtailor/page/user/login-signup/user_signup.dart';
import 'package:yourtailor/page/user/user_dashboard.dart';
// Replace with your dashboard or homepage

// Replace with your sign-up page path

class UserLoginScreen extends StatefulWidget {
  const UserLoginScreen({super.key});

  @override
  _UserLoginScreenState createState() => _UserLoginScreenState();
}

class _UserLoginScreenState extends State<UserLoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Authenticate with Firebase
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        String userId = userCredential.user!.uid;

        // Retrieve user details from Firestore
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(userId).get();

        if (userDoc.exists) {
          final userData = userDoc.data() as Map<String, dynamic>;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Welcome ${userData['username']}'),
            ),
          );

          // Navigate to the user dashboard
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) =>  const UserDashboard()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User data not found!')),
          );
        }
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.message}')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
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
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: const Icon(Icons.email_outlined),
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
                        prefixIcon: const Icon(Icons.lock_outline),
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
                onPressed: _isLoading ? null : _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Sign In', style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  // Navigate to the Sign-Up screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const UserSignUpScreen()),
                  );
                },
                child: const Text(
                  "Don't have an account? Sign Up",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
