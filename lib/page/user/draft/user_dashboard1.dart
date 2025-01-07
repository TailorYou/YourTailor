// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:service_booking_cloudfirestore/page/user/login-signup/user_login.dart';
// import 'BookAppointment.dart';
// // For Add services & Time slots purpose only
// //import 'package:service_booking_cloudfirestore/admin/addservice.dart';
// //import 'package:service_booking_cloudfirestore/admin/deleteservice.dart';
// //import 'package:service_booking_cloudfirestore/admin/updatetimeslot.dart';

// class UserDashboard extends StatelessWidget {
//   const UserDashboard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final FirebaseAuth _auth = FirebaseAuth.instance;
    
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('User Dashboard'),
//         actions: [
//             // Logout icon button
//             IconButton(
//               icon: Icon(Icons.exit_to_app),
//               onPressed: () async {
//                 try {
//                   await _auth.signOut();
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => UserLoginScreen()
//                     ),
//                   );
//                 } catch (e) {
//                   print(e);
//                 }
//               },
//             ),
//           ],
//       ),
//       body: Center(
//         child: Column(
//           mainAxisSize: MainAxisSize.min, // Align content to the center
//           children: [
//             // Just for Admin Use (Add Service):
//             /*
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => AddService()
//                   ),
//                 );
//               },
//               style: ElevatedButton.styleFrom(
//                 foregroundColor: Colors.white,
//                 backgroundColor: Colors.brown,
//                 padding: const EdgeInsets.symmetric(
//                     horizontal: 40, vertical: 15),
//               ),
//               child: const Text('Admin Add Service'),
//             ),
//             const SizedBox(height: 30),
//             // Just for Admin Use (Delete Service):
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => DeleteService()
//                   ),
//                 );
//               },
//               style: ElevatedButton.styleFrom(
//                 foregroundColor: Colors.white,
//                 backgroundColor: Colors.brown,
//                 padding: const EdgeInsets.symmetric(
//                     horizontal: 40, vertical: 15),
//               ),
//               child: const Text('Admin Delete Service'),
//             ),
//             const SizedBox(height: 30),
//             // Just for Admin Use (Update Time Slot):
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => UpdateTimeSlot()
//                   ),
//                 );
//               },
//               style: ElevatedButton.styleFrom(
//                 foregroundColor: Colors.white,
//                 backgroundColor: Colors.brown,
//                 padding: const EdgeInsets.symmetric(
//                     horizontal: 40, vertical: 15),
//               ),
//               child: const Text('Admin Update Time Slot'),
//             ),
//             const SizedBox(height: 30),*/
//             // Service Booking Button
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => BookAppointment()
//                   ),
//                 );
//               },
//               style: ElevatedButton.styleFrom(
//                 foregroundColor: Colors.white,
//                 backgroundColor: Colors.brown,
//                 padding: const EdgeInsets.symmetric(
//                     horizontal: 40, vertical: 15),
//               ),
//               child: const Text('Service Booking'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
