import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:solar_tracker/helping_widgets/custom_text_field.dart';
import 'package:solar_tracker/helping_widgets/custom_elevated_button.dart';
import 'package:solar_tracker/constants.dart';
import 'package:solar_tracker/helping_widgets/custom_toast.dart';

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
  final Logger _logger = Logger();

  String _selectedTrackerControl = 'Off'; // Default selected value
  final List<String> _trackerControlOptions = ['Off', 'On'];

  @override
  void initState() {
    super.initState();
    _fetchAzimuthMotorSettings();
  }

  Future<void> _fetchAzimuthMotorSettings() async {
    try {
      final response =
          await http.get(Uri.parse('http://174.89.157.173:5000/azimuthmotor'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _stallSpeedController.text = (data['AzStallSpeed'] ?? '').toString();
          _reverseMotorController.text =
              (data['AzReverseMotor'] ?? '').toString();
          _accellTimeController.text = (data['AzAccellTime'] ?? '').toString();
          _motorRatioController.text = (data['AzMotorRatio'] ?? '').toString();
          _driveRatioController.text = (data['AzDriveRatio'] ?? '').toString();
          _encoderPPRController.text = (data['AzEncodePPR'] ?? '').toString();
          _degreeToScaleController.text =
              (data['AzDegreetoScale'] ?? '').toString();
          _deadBandController.text = (data['AzDeadBand'] ?? '').toString();
          _selectedTrackerControl = 'Off';
        });
      } else {
        _logger
            .e('Failed to load azimuth motor settings: ${response.statusCode}');
        CustomToast.showToast('Failed to load azimuth motor settings');
        throw Exception('Failed to load azimuth motor settings');
      }
    } catch (e) {
      _logger.e('Error fetching azimuth motor settings: $e');
      CustomToast.showToast('Error fetching azimuth motor settings');
    }
  }

  @override
  void dispose() {
    _stallSpeedController.dispose();
    _reverseMotorController.dispose();
    _accellTimeController.dispose();
    _motorRatioController.dispose();
    _driveRatioController.dispose();
    _encoderPPRController.dispose();
    _degreeToScaleController.dispose();
    _deadBandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimary,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Azimuth Motor Settings'),
        backgroundColor: kSecondary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                controller: _stallSpeedController,
                labelText: 'Stall Speed',
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _reverseMotorController,
                labelText: 'Reverse Motor',
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _accellTimeController,
                labelText: 'Accell Time',
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _motorRatioController,
                labelText: 'Motor Ratio',
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _driveRatioController,
                labelText: 'Drive Ratio',
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _encoderPPRController,
                labelText: 'Encoder PPR',
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _degreeToScaleController,
                labelText: 'Degree to Scale',
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _deadBandController,
                labelText: 'Dead Band',
              ),
              const SizedBox(height: 20),
              const Center(
                  child: Text('Tracker Control',
                      style: TextStyle(color: Colors.white, fontSize: 18))),
              const SizedBox(height: 10),
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 0.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.white),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      dropdownColor: Colors.grey[800],
                      value: _selectedTrackerControl,
                      icon:
                          const Icon(Icons.arrow_drop_down, color: Colors.grey),
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
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomElevatedButton(
                    text: 'Save Changes',
                    onPressed: () {
                      // Implement save functionality here
                      CustomToast.showToast('Changes saved successfully');
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
