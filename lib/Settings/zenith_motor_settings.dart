import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../Helping Widgets/textfield_widget.dart';

class ZenithMotorSettings extends StatefulWidget {
  const ZenithMotorSettings({super.key});

  @override
  State<ZenithMotorSettings> createState() => _ZenithMotorSettingsState();
}

class _ZenithMotorSettingsState extends State<ZenithMotorSettings> {
  final TextEditingController _zeMotorRatio = TextEditingController();
  final TextEditingController _zeAccellTime = TextEditingController();
  final TextEditingController _zeDriveRatio = TextEditingController();
  final TextEditingController _zeEncoderPPR = TextEditingController();
  final TextEditingController _zeDegreeToScale = TextEditingController();
  final TextEditingController _zeStallSpeed = TextEditingController();
  final TextEditingController _zeReverseMotor = TextEditingController();
  final TextEditingController _zeDeadBand = TextEditingController();

  String _selectedTrackerControl = 'Off'; // Default selected value
  final List<String> _trackerControlOptions = ['Off', 'On'];

  @override
  void initState() {
    super.initState();
    _fetchZenithMotorSettings();
  }

  Future<void> _fetchZenithMotorSettings() async {
    final response = await http.get(Uri.parse('http://174.89.157.173:5000/zenithmotor'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _zeMotorRatio.text = data['ZeMotorRatio'] ?? '';
        _zeAccellTime.text = data['ZeAccellTime'] ?? '';
        _zeDriveRatio.text = data['ZeDriveRatio'] ?? '';
        _zeEncoderPPR.text = data['ZeEncodePPR'] ?? '';
        _zeDegreeToScale.text = data['ZeDegreetoScale'] ?? '';
        _zeStallSpeed.text = data['ZeStallSpeed'] ?? '';
        _zeReverseMotor.text = data['ZeReverseMotor'] ?? '';
        _zeDeadBand.text = data['ZeDeadBand'] ?? '';
        _selectedTrackerControl =  'Off';
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
        title: Text('Azimuth Motor Settings', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.grey[900],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTextField('Motor Ratio', _zeMotorRatio),
              buildTextField('Accell Time', _zeAccellTime),
              buildTextField('Drive Ratio', _zeDriveRatio),
              buildTextField('PPR', _zeEncoderPPR),
              buildTextField('Degree to Scale', _zeDegreeToScale),
              buildTextField('Stall Speed', _zeStallSpeed),
              buildTextField('Reverse Motor', _zeReverseMotor),
              buildTextField('Dead Band', _zeDeadBand),
              const SizedBox(height: 20),
              Center(child: Text('Tracker Control', style: TextStyle(color: Colors.white, fontSize: 18))),
              const SizedBox(height: 10),
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 3.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.white),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      dropdownColor: Colors.grey[800],
                      value: _selectedTrackerControl,
                      icon: Icon(Icons.arrow_drop_down, color: Colors.grey),
                      style: TextStyle(color: Colors.white),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedTrackerControl = newValue!;
                        });
                      },
                      items: _trackerControlOptions.map<DropdownMenuItem<String>>((String value) {
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
