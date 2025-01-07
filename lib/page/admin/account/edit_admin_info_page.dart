import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditAdminInfoPage extends StatefulWidget {
  const EditAdminInfoPage({super.key});

  @override
  _EditAdminInfoPageState createState() => _EditAdminInfoPageState();
}

class _EditAdminInfoPageState extends State<EditAdminInfoPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchAdminInfo();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _fetchAdminInfo() async {
    final user = _auth.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No admin is currently logged in.')),
      );
      return;
    }

    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection('admin_users')
          .where('email', isEqualTo: user.email)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final data = snapshot.docs.first.data();

        setState(() {
          _nameController.text = data['username'] ?? '';
          _emailController.text = data['email'] ?? '';
          _phoneController.text = data['phone'] ?? '';
          _dobController.text = data['dob'] ?? '';
          _addressController.text = data['address'] ?? '';
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Admin data not found.')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching admin info: $error')),
      );
    }
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final user = _auth.currentUser;

    if (user != null) {
      try {
        final QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
            .collection('admin_users')
            .where('email', isEqualTo: user.email)
            .get();

        if (snapshot.docs.isNotEmpty) {
          final docId = snapshot.docs.first.id;

          await _firestore.collection('admin_users').doc(docId).set({
            'username': _nameController.text.trim(),
            'email': _emailController.text.trim(),
            'phone': _phoneController.text.trim(),
            'dob': _dobController.text.trim(),
            'address': _addressController.text.trim(),
          }, SetOptions(merge: true));

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Admin info updated successfully!')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Admin data not found.')),
          );
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update admin info: $error')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No admin is currently logged in.')),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String validatorMessage,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
      ),
      validator: (value) => value!.isEmpty ? validatorMessage : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Admin Info'),
        backgroundColor: const Color(0xFFDFC5B0),
      ),
      backgroundColor: const Color(0xFFDFC5B0),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildTextField(
                        controller: _nameController,
                        labelText: 'Name',
                        validatorMessage: 'Name cannot be empty',
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        controller: _emailController,
                        labelText: 'Email',
                        validatorMessage: 'Email cannot be empty',
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        controller: _phoneController,
                        labelText: 'Phone',
                        validatorMessage: 'Phone cannot be empty',
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        controller: _dobController,
                        labelText: 'Date of Birth',
                        validatorMessage: 'Date of Birth cannot be empty',
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        controller: _addressController,
                        labelText: 'Address',
                        validatorMessage: 'Address cannot be empty',
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: _isLoading ? null : _saveChanges,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 15),
                        ),
                        child: const Text('Save Changes'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
