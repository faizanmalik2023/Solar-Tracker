import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:solar_tracker/helping_widgets/textfield_widget.dart';

class AzimuthMotorSettingsPage extends StatefulWidget {
  const AzimuthMotorSettingsPage({super.key});

  @override
  _AzimuthMotorSettingsPageState createState() =>
      _AzimuthMotorSettingsPageState();
}

class _AzimuthMotorSettingsPageState extends State<AzimuthMotorSettingsPage> {
  final TextEditingController _stallSpeedController = TextEditingController();
  final TextEditingController _reverseMotorController = TextEditingController();
  final TextEditingController _accellTimeController = TextEditingController();
  final TextEditingController _motorRatioController = TextEditingController();
  final TextEditingController _driveRatioController = TextEditingController();
  final TextEditingController _encoderPPRController = TextEditingController();
  final TextEditingController _degreeToScaleController =
      TextEditingController();
  final TextEditingController _deadBandController = TextEditingController();

  String _selectedTrackerControl = 'Off'; // Default selected value
  final List<String> _trackerControlOptions = ['Off', 'On'];

  @override
  void initState() {
    super.initState();
    _fetchAzimuthMotorSettings();
  }

  Future<void> _fetchAzimuthMotorSettings() async {
    final response =
        await http.get(Uri.parse('http://174.89.157.173:5000/azimuthmotor'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _stallSpeedController.text = data['AzStallSpeed'] ?? '';
        _reverseMotorController.text = data['AzReverseMotor'] ?? '';
        _accellTimeController.text = data['AzAccellTime'] ?? '';
        _motorRatioController.text = data['AzMotorRatio'] ?? '';
        _driveRatioController.text = data['AzDriveRatio'] ?? '';
        _encoderPPRController.text = data['AzEncodePPR'] ?? '';
        _degreeToScaleController.text = data['AzDegreetoScale'] ?? '';
        _deadBandController.text = data['AzDeadBand'] ?? '';
        _selectedTrackerControl = 'Off';
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
              buildTextField('Stall Speed', _stallSpeedController),
              buildTextField('Reverse Motor', _reverseMotorController),
              buildTextField('Accell Time', _accellTimeController),
              buildTextField('Motor Ratio', _motorRatioController),
              buildTextField('Drive Ratio', _driveRatioController),
              buildTextField('Encoder PPR', _encoderPPRController),
              buildTextField('Degree to Scale', _degreeToScaleController),
              buildTextField('Dead Band', _deadBandController),
              const SizedBox(height: 20),
              const Center(
                  child: Text('Tracker Control',
                      style: TextStyle(color: Colors.white, fontSize: 18))),
              const SizedBox(height: 10),
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 3.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.white),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      dropdownColor: Colors.grey[800],
                      value: _selectedTrackerControl,
                      icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
                      style: const TextStyle(color: Colors.white),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedTrackerControl = newValue!;
                        });
                      },
                      items: _trackerControlOptions
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
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
