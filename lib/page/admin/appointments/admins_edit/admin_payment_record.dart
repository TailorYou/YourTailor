import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PaymentRecordScreen extends StatefulWidget {
  @override
  _PaymentRecordScreenState createState() => _PaymentRecordScreenState();
}

class _PaymentRecordScreenState extends State<PaymentRecordScreen> {
  final CollectionReference _paymentRecordCollection =
      FirebaseFirestore.instance.collection('paymentrecord');

  // Hardcoded payment records
  final List<Map<String, dynamic>> _hardcodedPaymentRecords = [
    {
      'name': 'Ameera',
      'address': 'Kota Samarahan',
      'appointmentDate': '2 Jan 2025',
      'product': 'Skirt',
      'totalPrice': 'RM 65',
    },
    {
      'name': 'Ayu Natasya',
      'address': 'Kota Samarahan',
      'appointmentDate': '13 Dec 2024',
      'product': 'Baju Kurung',
      'totalPrice': 'RM 50',
    },
    {
      'name': 'Mohd Naufal',
      'address': 'Kuching',
      'appointmentDate': '16 Dec 2024',
      'product': 'Baju Melayu Lelaki',
      'totalPrice': 'RM 40',
    },
    {
      'name': 'Nur Farisya',
      'address': 'Kuching',
      'appointmentDate': '28 Dec 2024',
      'product': 'Baju Kurung (Alter)',
      'totalPrice': 'RM 15',
    },
  ];

  @override
  void initState() {
    super.initState();
    _checkAndPushPaymentRecords();
  }

  // Check if the collection is already populated
  Future<void> _checkAndPushPaymentRecords() async {
    try {
      QuerySnapshot snapshot = await _paymentRecordCollection.get();

      // If the collection is empty, push the hardcoded data
      if (snapshot.docs.isEmpty) {
        for (var record in _hardcodedPaymentRecords) {
          await _paymentRecordCollection.add(record);
        }
        print('Payment records added successfully.');
      } else {
        print('Payment records already exist. Skipping data insertion.');
      }
    } catch (error) {
      print('Error checking or adding payment records: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Payment Record',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFDFC5B0),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: const Color(0xFFDFC5B0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<QuerySnapshot>(
            future: _paymentRecordCollection.get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error loading payment records'));
              }
              if (snapshot.data!.docs.isEmpty) {
                return Center(child: Text('No payment records available'));
              }

              final paymentRecords = snapshot.data!.docs.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return {
                  'name': data['name'] ?? '',
                  'address': data['address'] ?? '',
                  'appointmentDate': data['appointmentDate'] ?? '',
                  'product': data['product'] ?? '',
                  'totalPrice': data['totalPrice'] ?? '',
                };
              }).toList();

              return ListView.builder(
                itemCount: paymentRecords.length,
                itemBuilder: (context, index) {
                  final record = paymentRecords[index];
                  return Card(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    margin: const EdgeInsets.symmetric(
                        vertical: 8, horizontal: 5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "Name      : ${record['name']}\n"
                        "Address   : ${record['address']}\n"
                        "Appointment date : ${record['appointmentDate']}\n"
                        "Product   : ${record['product']}\n"
                        "Total Price : ${record['totalPrice']}",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
