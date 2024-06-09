import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:solar_tracker/helping_widgets/textfield_widget.dart';

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
  Future<void> _fetchAzimuthSettings() async {
    final response =
        await http.get(Uri.parse('http://174.89.157.173:5000/azimuthsettings'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _azimuthNegLimit.text = data['AzNegLimit'] ?? '';
        _azimuthOffset.text = data['AzOffset'] ?? '';
        _azimuthPark.text = data['AzPark'] ?? '';
        _azimuthPosLimit.text = data['AzPosLimit'] ?? '';
      });
    } else {
      // Handle the error
      throw Exception('Failed to load azimuth settings');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchAzimuthSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Azimuth settings', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.grey[900],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTextField('Negative Limit', _azimuthNegLimit),
              buildTextField('Azimuth Offset', _azimuthOffset),
              buildTextField('Park Position', _azimuthPark),
              buildTextField('Positive Limit', _azimuthPosLimit),
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
