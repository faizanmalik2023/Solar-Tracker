import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:solar_tracker/helping_widgets/textfield_widget.dart';

class ZenithSettings extends StatefulWidget {
  const ZenithSettings({super.key});

  @override
  State<ZenithSettings> createState() => _ZenithSettingsState();
}

class _ZenithSettingsState extends State<ZenithSettings> {
  final TextEditingController _zenithNegLimit = TextEditingController();
  final TextEditingController _zenithOffset = TextEditingController();
  final TextEditingController _zenithPark = TextEditingController();
  final TextEditingController _zenithPosLimit = TextEditingController();

  Future<void> _fetchZenithSettings() async {
    final response =
        await http.get(Uri.parse('http://174.89.157.173:5000/zenithsettings'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _zenithNegLimit.text = data['ZeNegLimit'] ?? '';
        _zenithOffset.text = data['ZeOffset'] ?? '';
        _zenithPark.text = data['ZePark'] ?? '';
        _zenithPosLimit.text = data['ZePosLimit'] ?? '';
      });
    } else {
      // Handle the error
      throw Exception('Failed to load azimuth settings');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchZenithSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Zenith settings', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.grey[900],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTextField('Negative Limit', _zenithNegLimit),
              buildTextField('Offset', _zenithOffset),
              buildTextField('Park', _zenithPark),
              buildTextField('Soft Limit', _zenithPosLimit),
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
