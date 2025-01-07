import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:yourtailor/page/admin/account/edit_admin_info_page.dart';

class AdminInfoPage extends StatefulWidget {
  const AdminInfoPage({super.key});

  @override
  _AdminInfoPageState createState() => _AdminInfoPageState();
}

class _AdminInfoPageState extends State<AdminInfoPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Map<String, String> userInfo = {};
  bool isLoading = true;
  bool isAdmin = false;

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  Future<void> _fetchUserInfo() async {
  try {
    final User? user = _auth.currentUser;
    if (user != null) {
      print('Logged in user email: ${user.email}'); // Debug log
      
      // Query Firestore for admin data using email
      final QuerySnapshot<Map<String, dynamic>> adminSnapshot = await _firestore
          .collection('admin_users')
          .where('email', isEqualTo: user.email)
          .get();

      print('Admin query result count: ${adminSnapshot.docs.length}'); // Debug log
      
      if (adminSnapshot.docs.isNotEmpty) {
        final adminData = adminSnapshot.docs.first.data();
        print('Admin data fetched: $adminData'); // Debug log
        setState(() {
          userInfo = {
            'Username': adminData['username'] ?? 'N/A',
            'Email': adminData['email'] ?? 'N/A',
            'Phone': adminData['phone'] ?? 'N/A',
            'Address': adminData['address'] ?? 'N/A',
            'Date of Birth': adminData['dob'] ?? 'N/A',
          };
          isAdmin = true;
          isLoading = false;
        });
      } else {
        setState(() {
          isAdmin = false;
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Admin data not found.')),
        );
      }
    } else {
      print('No user is currently logged in.'); // Debug log
      setState(() {
        isLoading = false;
      });
    }
  } catch (e) {
    print('Error fetching admin data: $e'); // Debug log
    setState(() {
      isLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error fetching admin data: $e')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isAdmin ? 'Admin Info' : 'User Info'),
        backgroundColor: const Color(0xFFDFC5B0),
        actions: [
          IconButton(
          icon: const Icon(Icons.edit, color: Colors.black87),
          onPressed: () {
            Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const EditAdminInfoPage()),
                  );
          },
        ),
    ]
      ),
      backgroundColor: const Color(0xFFDFC5B0),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : userInfo.isEmpty
              ? const Center(child: Text('No data available'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView(
                    children: userInfo.entries
                        .map(
                          (entry) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.4),
                                    spreadRadius: 2,
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${entry.key}: ',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      entry.value,
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
    );
  }
}
