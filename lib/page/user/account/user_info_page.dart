import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yourtailor/page/user/account/user_edit_info.dart';


class UserInfoPage extends StatefulWidget {
  const UserInfoPage({super.key});

  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Map<String, String> userInfo = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  Future<void> _fetchUserInfo() async {
    try {
      final User? user = _auth.currentUser;
      if (user != null) {
        final DocumentSnapshot<Map<String, dynamic>> userDoc =
            await _firestore.collection('users').doc(user.uid).get();

        if (userDoc.exists) {
          setState(() {
            userInfo = {
              'Username': userDoc.data()?['username'] ?? 'N/A',
              'Email': userDoc.data()?['email'] ?? 'N/A',
              'Phone': userDoc.data()?['phone'] ?? 'N/A',
              'Address': userDoc.data()?['address'] ?? 'N/A',
              'Date of Birth': userDoc.data()?['dob'] ?? 'N/A',
            };
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User data not found')),
          );
        }
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching user data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Info'),
        backgroundColor: const Color(0xFFDFC5B0),
        actions: [
          IconButton(
          icon: const Icon(Icons.edit, color: Colors.black87),
          onPressed: () {
            Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const EditUserInfoPage()),
                  );
          },
        ),
    ]
      ),
      backgroundColor: const Color(0xFFDFC5B0),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : userInfo.isEmpty
              ? const Center(child: Text('No user data available'))
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
