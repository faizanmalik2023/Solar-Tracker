import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:solar_tracker/helping_widgets/custom_text_field.dart';
import 'package:solar_tracker/helping_widgets/custom_elevated_button.dart';
import 'package:solar_tracker/constants.dart';
import 'package:solar_tracker/helping_widgets/custom_toast.dart';

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
  final Logger _logger = Logger();

  Future<void> _fetchZenithSettings() async {
    try {
      final response = await http
          .get(Uri.parse('http://174.89.157.173:5000/zenithsettings'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _zenithNegLimit.text = (data['ZeNegLimit'] ?? '').toString();
          _zenithOffset.text = (data['ZeOffset'] ?? '').toString();
          _zenithPark.text = (data['ZePark'] ?? '').toString();
          _zenithPosLimit.text = (data['ZePosLimit'] ?? '').toString();
        });
      } else {
        _logger.e('Failed to load zenith settings: ${response.statusCode}');
        CustomToast.showToast('Failed to load zenith settings');
        throw Exception('Failed to load zenith settings');
      }
    } catch (e) {
      _logger.e('Error fetching zenith settings: $e');
      CustomToast.showToast('Error fetching zenith settings');
    }
  }

  Future<void> _saveZenithSettings() async {
    try {
      final response = await http.post(
        Uri.parse('http://174.89.157.173:5000/setzenithsettings'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{

          'ZeOffset': _zenithOffset.text,
          'ZePark': _zenithPark.text,
          'ZePosLimit': _zenithPosLimit.text,
          'ZeNegLimit': _zenithNegLimit.text,
        }),
      );

      if (response.statusCode == 200) {
        CustomToast.showToast('Changes saved successfully');
      } else {
        _logger.e('Failed to save zenith settings: ${response.statusCode}');
        CustomToast.showToast('Failed to save zenith settings');
        throw Exception('Failed to save zenith settings');
      }
    } catch (e) {
      _logger.e('Error saving zenith settings: $e');
      CustomToast.showToast('Error saving zenith settings');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchZenithSettings();
  }

  @override
  void dispose() {
    _zenithNegLimit.dispose();
    _zenithOffset.dispose();
    _zenithPark.dispose();
    _zenithPosLimit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimary,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Zenith Settings'),
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
                controller: _zenithNegLimit,
                labelText: 'Negative Limit',
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _zenithOffset,
                labelText: 'Offset',
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _zenithPark,
                labelText: 'Park',
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _zenithPosLimit,
                labelText: 'Soft Limit',
              ),
              const SizedBox(height: 40),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomElevatedButton(
                      text: 'Save Changes',
                      onPressed: _saveZenithSettings,
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
