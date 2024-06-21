import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logger/logger.dart';

import 'package:solar_tracker/helping_widgets/custom_elevated_button.dart';
import 'package:solar_tracker/constants.dart';
import 'package:solar_tracker/helping_widgets/custom_text_field.dart';
import 'package:solar_tracker/helping_widgets/custom_toast.dart';

class AzimuthSettings extends StatefulWidget {
  const AzimuthSettings({super.key});

  @override
  State<AzimuthSettings> createState() => _AzimuthSettingsState();
}

class _AzimuthSettingsState extends State<AzimuthSettings> {
  final TextEditingController _azimuthNegLimit = TextEditingController();
  final TextEditingController _azimuthOffset = TextEditingController();
  final TextEditingController _azimuthPark = TextEditingController();
  final TextEditingController _azimuthPosLimit = TextEditingController();
  final Logger _logger = Logger();

  Future<void> _fetchAzimuthSettings() async {
    try {
      final response = await http
          .get(Uri.parse('http://174.89.157.173:5000/azimuthsettings'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _azimuthNegLimit.text = (data['AzNegLimit'] ?? '').toString();
          _azimuthOffset.text = (data['AzOffset'] ?? '').toString();
          _azimuthPark.text = (data['AzPark'] ?? '').toString();
          _azimuthPosLimit.text = (data['AzPosLimit'] ?? '').toString();
        });
      } else {
        _logger.e('Failed to load azimuth settings: ${response.statusCode}');
        CustomToast.showToast('Failed to load azimuth settings');
        throw Exception('Failed to load azimuth settings');
      }
    } catch (e) {
      _logger.e('Error fetching azimuth settings: $e');
      CustomToast.showToast('Error fetching azimuth settings');
    }
  }

  Future<void> _saveAzimuthSettings() async {
    try {
      final response = await http.post(
        Uri.parse('http://174.89.157.173:5000/setazimuthsettings'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'AzOffset': _azimuthOffset.text,
          'AzPark': _azimuthPark.text,
          'AzPosLimit': _azimuthPosLimit.text,
          'AzNegLimit': _azimuthNegLimit.text,
        }),
      );

      if (response.statusCode == 200) {
        CustomToast.showToast('Changes saved successfully');
      } else {
        _logger.e('Failed to save azimuth settings: ${response.statusCode}');
        CustomToast.showToast('Failed to save azimuth settings');
        throw Exception('Failed to save azimuth settings');
      }
    } catch (e) {
      _logger.e('Error saving azimuth settings: $e');
      CustomToast.showToast('Error saving azimuth settings');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchAzimuthSettings();
  }

  @override
  void dispose() {
    _azimuthNegLimit.dispose();
    _azimuthOffset.dispose();
    _azimuthPark.dispose();
    _azimuthPosLimit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimary,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Azimuth Settings'),
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
                controller: _azimuthNegLimit,
                labelText: 'Negative Limit',
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _azimuthOffset,
                labelText: 'Azimuth Offset',
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _azimuthPark,
                labelText: 'Park Position',
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _azimuthPosLimit,
                labelText: 'Positive Limit',
              ),
              const SizedBox(height: 40),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomElevatedButton(
                      text: 'Save Changes',
                      onPressed: _saveAzimuthSettings,
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
