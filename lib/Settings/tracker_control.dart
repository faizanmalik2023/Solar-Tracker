import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Helping Widgets/textfield_widget.dart';

class TrackerControl extends StatefulWidget {
  const TrackerControl({super.key});

  @override
  State<TrackerControl> createState() => _TrackerControlState();
}

class _TrackerControlState extends State<TrackerControl> {
  final TextEditingController _trackerState = TextEditingController();
  final TextEditingController _trackerNight = TextEditingController();
  final TextEditingController _trackerWind= TextEditingController();
  final TextEditingController _trackerElevation= TextEditingController();
  final TextEditingController _trackerDelay= TextEditingController();

  Future<void> _fetchTrackerControls() async {
    final response = await http.get(Uri.parse('http://174.89.157.173:5000/trackercontrol'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _trackerState.text = data['TrackerState'] ?? '';
        _trackerNight.text = data['TrackerNight'] ?? '';
        _trackerWind.text = data['TrackerWind'] ?? '';
        _trackerElevation.text = data['Elevation'] ?? '';
        _trackerDelay.text = data['Trackdelay'] ?? '';
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
        title: Text('Tracker Controls', style: TextStyle(color: Colors.white)),
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
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                  child: Text('Save Changes', style: TextStyle(color: Colors.white),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
