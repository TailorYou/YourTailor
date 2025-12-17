import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FaqsScreen extends StatefulWidget {
  const FaqsScreen({super.key});

  @override
  State<FaqsScreen> createState() => FaqsScreenState();
}

class FaqsScreenState extends State<FaqsScreen> {

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
          'FAQs',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          Expanded(  // Important: Use Expanded for scrollable content
            child: SingleChildScrollView(  // Wrap here for scrolling cards only
              child: Center(
                child: Column(
                  children: [ 
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                        _faqCard(
                          '1. What services do you offer?',
                          'We provide custom tailoring, alterations, and repairs for all types of clothing.',
                        ),
                        _faqCard(
                          '2. Do you offer same-day services?',
                          'Yes, same-day service is available for minor alterations, depending on availability.',
                        ),
                        _faqCard(
                          '3. How long does it take to complete a custom outfit?',
                          'It usually takes 1–3 weeks, depending on the complexity of the design.',
                        ),
                        _faqCard(
                          '4. What fabrics do you work with?',
                          'We work with most fabrics, including silk, cotton, wool, and synthetic materials.',
                        ),
                        _faqCard(
                          '5. Can I bring my own fabric?',
                          'Yes, customers may provide their own fabric for clothing.',
                        ),
                        _faqCard(
                          '6. How can I contact you?',
                          'You can contact us via phone, email, or through our social media platforms.',
                        ),
                        _faqCard(
                          '7. Where is your store located?',
                          'Our store is located in Asajaya.',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
               ),
               
              ),
            ),
          ),
        ],
      ),
    );
  }

} 

Widget _faqCard(String question, String answer) {
  return Container(
    width: 350, // Fixed width
    child: Card(
      color: const Color(0xFFFDF0E3),
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              answer,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    ),
  );
}