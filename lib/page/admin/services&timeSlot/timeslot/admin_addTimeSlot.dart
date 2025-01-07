import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class UpdateTimeScreen extends StatefulWidget {
  const UpdateTimeScreen({super.key});

  @override
  _UpdateTimeScreenState createState() => _UpdateTimeScreenState();
}

class _UpdateTimeScreenState extends State<UpdateTimeScreen> {
  final _formKey = GlobalKey<FormState>();
  final CollectionReference _appointmentsCollection =
      FirebaseFirestore.instance.collection('appointments');
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _dateController.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _timeController.text = picked.format(context);
      });
    }
  }

  Future<void> addTimeSlot(String appointmentDate, String appointmentTime) async {
    try {
      await _appointmentsCollection.add({
        'appointmentDate': appointmentDate,
        'appointmentTime': appointmentTime,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Time slot added successfully!')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add time slot: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Update Time',
          style: GoogleFonts.judson(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        backgroundColor: const Color(0xFFDFC5B0),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.black,
            height: 1.0,
          ),
        ),
      ),
      body: Container(
        color: const Color(0xFFDFC5B0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Center(
                child: Text(
                  'YourTailor',
                  style: GoogleFonts.italiana(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2DDCE),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: TextFormField(
                              controller: _dateController,
                              readOnly: true,
                              decoration: const InputDecoration(
                                labelText: "Appointment Date",
                                border: OutlineInputBorder(),
                                hintText: "Tap to select a date",
                              ),
                              onTap: () => _selectDate(context),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please choose a date';
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: TextFormField(
                              controller: _timeController,
                              readOnly: true,
                              decoration: const InputDecoration(
                                labelText: "Appointment Time",
                                border: OutlineInputBorder(),
                                hintText: "Tap to select a time",
                              ),
                              onTap: () => _selectTime(context),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please choose a time';
                                }
                                return null;
                              },
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                addTimeSlot(
                                  _dateController.text,
                                  _timeController.text,
                                );
                                _dateController.clear();
                                _timeController.clear();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4A4A4A),
                            ),
                            child: Text(
                              'Add Time Slot',
                              style: GoogleFonts.judson(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
