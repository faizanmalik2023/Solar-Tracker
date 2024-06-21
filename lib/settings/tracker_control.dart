import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:solar_tracker/helping_widgets/custom_text_field.dart';
import 'package:solar_tracker/helping_widgets/custom_elevated_button.dart';
import 'package:solar_tracker/constants.dart';
import 'package:solar_tracker/helping_widgets/custom_toast.dart';

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
  final Logger _logger = Logger();

  Future<void> _fetchTrackerControls() async {
    try {
      final response = await http
          .get(Uri.parse('http://174.89.157.173:5000/trackercontrol'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _trackerState.text = (data['TrackerState'] ?? '').toString();
          _trackerNight.text = (data['TrackerNight'] ?? '').toString();
          _trackerWind.text = (data['TrackerWind'] ?? '').toString();
          _trackerElevation.text = (data['Elevation'] ?? '').toString();
          _trackerDelay.text = (data['Trackdelay'] ?? '').toString();
        });
      } else {
        _logger.e('Failed to load tracker controls: ${response.statusCode}');
        CustomToast.showToast('Failed to load tracker controls');
        throw Exception('Failed to load tracker controls');
      }
    } catch (e) {
      _logger.e('Error fetching tracker controls: $e');
      CustomToast.showToast('Error fetching tracker controls');
    }
  }

  Future<void> _saveTrackerControls() async {
    try {
      final response = await http.post(
        Uri.parse('http://174.89.157.173:5000/settrackercontrol'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'TrackerState': _trackerState.text,
          'TrackerWind': _trackerWind.text,
          'TrackerNight': _trackerNight.text,
          'Trackdelay': _trackerDelay.text,
          'Elevation': _trackerElevation.text,
        }),
      );
      print(response);

      if (response.statusCode == 200) {
        CustomToast.showToast('Changes saved successfully');
      } else {
        _logger.e('Failed to save tracker controls: ${response.statusCode}');
        CustomToast.showToast('Failed to save tracker controls');
        throw Exception('Failed to save tracker controls');
      }
    } catch (e) {
      _logger.e('Error saving tracker controls: $e');
      CustomToast.showToast('Error saving tracker controls');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchTrackerControls();
  }

  @override
  void dispose() {
    _trackerState.dispose();
    _trackerNight.dispose();
    _trackerWind.dispose();
    _trackerElevation.dispose();
    _trackerDelay.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimary,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Tracker Controls'),
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
                controller: _trackerState,
                labelText: 'Tracker State',
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _trackerNight,
                labelText: 'Tracker Night',
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _trackerWind,
                labelText: 'Tracker Wind',
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _trackerElevation,
                labelText: 'Tracker Elevation',
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _trackerDelay,
                labelText: 'Tracker Delay',
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomElevatedButton(
                    text: 'Save Changes',
                    onPressed: _saveTrackerControls,
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
