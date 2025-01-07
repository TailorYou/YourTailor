import 'package:flutter/material.dart';
import 'package:yourtailor/page/user/appointment/BookingServiceAppointmentPage.dart';
import 'package:yourtailor/page/user/draft/selectService.dart';

class SelectServiceList extends StatelessWidget {
  final Map<String, dynamic> service;

  const SelectServiceList({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 139, 101, 94), // Dark brown color
        title: Text(service['serviceName']),
      ),
      body: Container(
        color: const Color(0xFFE8C8BA), // Light beige background color
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              service['serviceName'],
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('Price: RM${service['servicePrice']}',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('Info: ${service['serviceInfo']}',
                style: const TextStyle(fontSize: 16)),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                // Store selected service and navigate to BookAppointment screen
                SelectService.selectService(service);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BookAppointment()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD2B29C),
              ),
              child: const Text('Book This Service'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Navigate back without storing the service
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BookAppointment()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 190, 143, 127),
              ),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }
}
