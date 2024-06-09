import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:solar_tracker/helping_widgets/textfield_widget.dart';

class TrackerLocation extends StatefulWidget {
  const TrackerLocation({super.key});

  @override
  State<TrackerLocation> createState() => _TrackerLocationState();
}

class _TrackerLocationState extends State<TrackerLocation> {
  final TextEditingController _trackerLat = TextEditingController();
  final TextEditingController _trackerLong = TextEditingController();
  final TextEditingController _timeZone = TextEditingController();
  final TextEditingController _trackerElevation = TextEditingController();
  final TextEditingController _trackerDelay = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchAzimuthMotorSettings();
  }

  Future<void> _fetchAzimuthMotorSettings() async {
    final response =
        await http.get(Uri.parse('http://174.89.157.173:5000/trackerlocation'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _trackerLat.text = data['Lat'] ?? '';
        _trackerLong.text = data['Long'] ?? '';
        _timeZone.text = data['TimeZone'] ?? '';
        _trackerElevation.text = data['Elevation'] ?? '';
        _trackerDelay.text = data['Trackdelay'] ?? '';
      });
    } else {
      // Handle the error
      throw Exception('Failed to load azimuth motor settings');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Azimuth Motor settings',
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
              buildTextField('Latitude', _trackerLat),
              buildTextField('Longitude', _trackerLong),
              buildTextField('Time Zone', _timeZone),
              buildTextField('Elevation', _trackerElevation),
              buildTextField('Tracker Delay', _trackerDelay),
              const SizedBox(height: 20),
              const SizedBox(height: 40),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Implement save functionality here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[800],
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
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
