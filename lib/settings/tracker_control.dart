import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:solar_tracker/helping_widgets/textfield_widget.dart';

class TrackerControl extends StatefulWidget {
  const TrackerControl({super.key});

  @override
  State<TrackerControl> createState() => _TrackerControlState();
}

class _TrackerControlState extends State<TrackerControl> {
  final TextEditingController _trackerState = TextEditingController();
  final TextEditingController _trackerNight = TextEditingController();
  final TextEditingController _trackerWind = TextEditingController();
  final TextEditingController _trackerElevation = TextEditingController();
  final TextEditingController _trackerDelay = TextEditingController();

  Future<void> _fetchTrackerControls() async {
    final response =
        await http.get(Uri.parse('http://174.89.157.173:5000/trackercontrol'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _trackerState.text = (data['TrackerState'] ?? '').toString();
        ;
        _trackerNight.text = (data['TrackerNight'] ?? '').toString();
        ;
        _trackerWind.text = (data['TrackerWind'] ?? '').toString();
        ;
        _trackerElevation.text = (data['Elevation'] ?? '').toString();
        ;
        _trackerDelay.text = (data['Trackdelay'] ?? '').toString();
        ;
      });
    } else {
      // Handle the error
      throw Exception('Failed to load azimuth settings');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchTrackerControls();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Tracker Controls',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.grey[900],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTextField('Tracker State', _trackerState),
              buildTextField('Tracker Night', _trackerNight),
              buildTextField('Tracker Wind', _trackerWind),
              buildTextField('Tracker Elevation', _trackerElevation),
              buildTextField('Tracker Delay', _trackerDelay),
              const SizedBox(height: 40),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Implement save functionality here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[800],
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: const Text(
                    'Save Changes',
                    style: TextStyle(color: Colors.white),
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
