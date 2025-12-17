import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UpdateTimeScreen extends StatefulWidget {
  const UpdateTimeScreen({super.key});

  @override
  _UpdateTimeScreenState createState() => _UpdateTimeScreenState();
}

class _UpdateTimeScreenState extends State<UpdateTimeScreen> {
  final CollectionReference _appointmentsCollection =
      FirebaseFirestore.instance.collection('appointments');

  final TextEditingController _dateController = TextEditingController();

  // Preset time slots
  final List<String> presetSlots = [
    "09:00 AM",
    "10:00 AM",
    "11:00 AM",
    "12:00 PM",
    "01:00 PM",
    "02:00 PM",
    "03:00 PM",
    "04:00 PM",
    "05:00 PM",
    "06:00 PM",
    "07:00 PM",
  ];

  // Toggle state map
  Map<String, bool> selectedSlots = {};

  @override
  void initState() {
    super.initState();
    // Initialize all slots as OFF
    for (var slot in presetSlots) {
      selectedSlots[slot] = false;
    }
  }

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

  Future<void> saveSelectedTimeSlots() async {
    String selectedDate = _dateController.text.trim();

    if (selectedDate.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a date first.")),
      );
      return;
    }

    final chosenSlots =
        selectedSlots.entries.where((e) => e.value == true).map((e) => e.key);

    if (chosenSlots.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No time slot selected.")),
      );
      return;
    }

    try {
      for (var slot in chosenSlots) {
        await _appointmentsCollection.add({
          'appointmentDate': selectedDate,
          'appointmentTime': slot,
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Time slots saved successfully!")),
      );

      Navigator.pop(context);

      // Reset toggles
      setState(() {
        selectedSlots.updateAll((key, value) => false);
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to save: $error")),
      );
    }
  }

  void toggleAll(bool value) {
    setState(() {
      selectedSlots.updateAll((key, oldValue) => value);
    });
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
          onPressed: () => Navigator.pop(context),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.black, height: 1),
        ),
      ),
      body: Container(
        color: const Color(0xFFDFC5B0),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              "YourTailor",
              style: GoogleFonts.italiana(
                fontSize: 40, 
                fontWeight: FontWeight.bold
              )
            ),

            const SizedBox(height: 20),

            // DATE FIELD
            TextFormField(
              controller: _dateController,
              readOnly: true,
              decoration: const InputDecoration(
                  labelText: "Appointment Date",
                  border: OutlineInputBorder(),
                  hintText: "Tap to select date"),
              onTap: () => _selectDate(context),
            ),

            const SizedBox(height: 20),

            // TIME TOGGLES FIELD - ONLY SHOW AFTER DATE SELECTED
            if (_dateController.text.isNotEmpty) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () => toggleAll(true),
                    child: const Text("Enable All On"),
                  ),
                  ElevatedButton(
                    onPressed: () => toggleAll(false),
                    child: const Text("Enable All Off"),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Expanded(
                child: ListView.builder(
                  itemCount: presetSlots.length,
                  itemBuilder: (context, index) {
                    String slot = presetSlots[index];
                    bool isSelected = selectedSlots[slot] ?? false;

                    return SwitchListTile(
                      title: Text(slot,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500)),
                      value: isSelected,
                      onChanged: (value) {
                        setState(() {
                          selectedSlots[slot] = value;
                        });
                      },
                    );
                  },
                ),
              ),
            ],

            const SizedBox(height: 20),

            // SAVE BUTTON
            ElevatedButton(
              onPressed: saveSelectedTimeSlots,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A4A4A),
                padding:
                  const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              ),
              child: Text(
                "Add Time Slots",
                style: GoogleFonts.judson(
                  fontSize: 18, 
                  color: Colors.white
                )
              ),
            ),
          ],
        ),
      ),
    );
  }
}
