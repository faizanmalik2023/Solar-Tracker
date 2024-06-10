import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:solar_tracker/helping_widgets/custom_elevated_button.dart';
import 'package:solar_tracker/constants.dart';
import 'package:solar_tracker/helping_widgets/custom_text_field.dart';
import 'package:solar_tracker/helping_widgets/custom_toast.dart';

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
  final Logger _logger = Logger();

  @override
  void initState() {
    super.initState();
    _fetchTrackerLocation();
  }

  Future<void> _fetchTrackerLocation() async {
    try {
      final response = await http
          .get(Uri.parse('http://174.89.157.173:5000/trackerlocation'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _trackerLat.text = (data['Lat'] ?? '').toString();
          _trackerLong.text = (data['Long'] ?? '').toString();
          _timeZone.text = (data['TimeZone'] ?? '').toString();
          _trackerElevation.text = (data['Elevation'] ?? '').toString();
          _trackerDelay.text = (data['Trackdelay'] ?? '').toString();
        });
      } else {
        _logger.e('Failed to load tracker location: ${response.statusCode}');
        CustomToast.showToast('Failed to load tracker location');
        throw Exception('Failed to load tracker location');
      }
    } catch (e) {
      _logger.e('Error fetching tracker location: $e');
      CustomToast.showToast('Error fetching tracker location');
    }
  }

  @override
  void dispose() {
    _trackerLat.dispose();
    _trackerLong.dispose();
    _timeZone.dispose();
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
        title: const Text('Tracker Location'),
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
                controller: _trackerLat,
                labelText: 'Latitude',
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _trackerLong,
                labelText: 'Longitude',
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _timeZone,
                labelText: 'Time Zone',
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _trackerElevation,
                labelText: 'Elevation',
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _trackerDelay,
                labelText: 'Tracker Delay',
              ),
              const SizedBox(height: 40),
              Center(
                child: Row(
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
