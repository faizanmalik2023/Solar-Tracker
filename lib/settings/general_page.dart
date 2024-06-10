import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:solar_tracker/constants.dart';
import 'package:solar_tracker/helping_widgets/custom_elevated_button.dart';
import 'package:solar_tracker/helping_widgets/custom_toast.dart';

class GeneralPage extends StatefulWidget {
  const GeneralPage({super.key});

  @override
  State<GeneralPage> createState() => _GeneralPageState();
}

class _GeneralPageState extends State<GeneralPage> {
  final Logger _logger = Logger();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimary,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: kSecondary,
        foregroundColor: Colors.white,
        title: const Text(
          'General Page',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  CustomElevatedButton(
                    text: 'Show Toast',
                    onPressed: () {
                      CustomToast.showToast('This is a custom toast message');
                      _logger.i('Toast button clicked');
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
