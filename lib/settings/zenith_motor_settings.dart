import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:solar_tracker/helping_widgets/custom_text_field.dart';
import 'package:solar_tracker/helping_widgets/custom_elevated_button.dart';
import 'package:solar_tracker/constants.dart';
import 'package:solar_tracker/helping_widgets/custom_toast.dart';

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
  final Logger _logger = Logger();

  String _selectedTrackerControl = 'Off'; // Default selected value
  final List<String> _trackerControlOptions = ['Off', 'On'];

  @override
  void initState() {
    super.initState();
    _fetchZenithMotorSettings();
  }

  Future<void> _fetchZenithMotorSettings() async {
    try {
      final response =
      await http.get(Uri.parse('http://184.147.14.104:5000/zenithmotor'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _zeMotorRatio.text = (data['ZeMotorRatio'] ?? '').toString();
          _zeAccellTime.text = (data['ZeAccellTime'] ?? '').toString();
          _zeDriveRatio.text = (data['ZeDriveRatio'] ?? '').toString();
          _zeEncoderPPR.text = (data['ZeEncodePPR'] ?? '').toString();
          _zeDegreeToScale.text = (data['ZeDegreetoScale'] ?? '').toString();
          _zeStallSpeed.text = (data['ZeStallSpeed'] ?? '').toString();
          _zeReverseMotor.text = (data['ZeReverseMotor'] ?? '').toString();
          _zeDeadBand.text = (data['ZeDeadBand'] ?? '').toString();
          _selectedTrackerControl = (data['TrackerControl'] ?? 'Off').toString();
        });
      } else {
        _logger
            .e('Failed to load zenith motor settings: ${response.statusCode}');
        CustomToast.showToast('Failed to load zenith motor settings');
        throw Exception('Failed to load zenith motor settings');
      }
    } catch (e) {
      _logger.e('Error fetching zenith motor settings: $e');
      CustomToast.showToast('Error fetching zenith motor settings');
    }
  }

  Future<void> _saveZenithMotorSettings() async {
    try {
      final response = await http.post(
        Uri.parse('http://184.147.14.104:5000/setzenithmotor'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'ZeMotorRatio': _zeMotorRatio.text,
          'ZeAccellTime': _zeAccellTime.text,
          'ZeDriveRatio': _zeDriveRatio.text,
          'ZeEncodePPR': _zeEncoderPPR.text,
          'ZeDegreetoScale': _zeDegreeToScale.text,
          'ZeStallSpeed': _zeStallSpeed.text,
          'ZeReverseMotor': _zeReverseMotor.text,
          'ZeDeadBand': _zeDeadBand.text,
          'TrackerControl': _selectedTrackerControl,
        }),
      );

      if (response.statusCode == 200) {
        CustomToast.showToast('Changes saved successfully');
      } else {
        _logger.e('Failed to save zenith motor settings: ${response.statusCode}');
        CustomToast.showToast('Failed to save zenith motor settings');
        throw Exception('Failed to save zenith motor settings');
      }
    } catch (e) {
      _logger.e('Error saving zenith motor settings: $e');
      CustomToast.showToast('Error saving zenith motor settings');
    }
  }

  @override
  void dispose() {
    _zeMotorRatio.dispose();
    _zeAccellTime.dispose();
    _zeDriveRatio.dispose();
    _zeEncoderPPR.dispose();
    _zeDegreeToScale.dispose();
    _zeStallSpeed.dispose();
    _zeReverseMotor.dispose();
    _zeDeadBand.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimary,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Zenith Motor Settings'),
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
                controller: _zeMotorRatio,
                labelText: 'Motor Ratio',
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _zeAccellTime,
                labelText: 'Accell Time',
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _zeDriveRatio,
                labelText: 'Drive Ratio',
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _zeEncoderPPR,
                labelText: 'PPR',
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _zeDegreeToScale,
                labelText: 'Degree to Scale',
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _zeStallSpeed,
                labelText: 'Stall Speed',
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _zeReverseMotor,
                labelText: 'Reverse Motor',
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _zeDeadBand,
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
                    horizontal: 12.0,
                  ),
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
              const SizedBox(height: 10),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomElevatedButton(
                      text: 'Save Changes',
                      onPressed: _saveZenithMotorSettings,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
