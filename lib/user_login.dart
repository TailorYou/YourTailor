import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:yourtailor/page/user/login-signup/user_signup.dart';
import 'package:yourtailor/page/user/user_dashboard.dart';



class UserLoginScreen extends StatefulWidget {
  const UserLoginScreen({super.key});

  @override
  State<UserLoginScreen> createState() => _UserLoginScreenState();
}

class _UserLoginScreenState extends State<UserLoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance; // Firebase Auth instance
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  // Function for user sign-in
  Future<void> _loginUser() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login Successful!')),
      );
      // Navigate to the Customer Dashboard or Home Screen here
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const UserDashboard()),
      );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Sign In'),
        backgroundColor: Colors.brown,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome Back, Customer!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.brown[800],
              ),
            ),
            const SizedBox(height: 30),
            // Email TextField
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            // Password TextField
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            // Sign In Button
            ElevatedButton(
              onPressed: _isLoading ? null : _loginUser,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.brown,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : const Text('Sign In'),
            ),
            // Sign Up Navigation
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UserSignUpScreen()),
                );
              },
              child: const Text('Don\'t have an account? Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
