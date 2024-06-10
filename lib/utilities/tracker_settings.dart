import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:solar_tracker/Settings/azimuth_motor_settings.dart';
import 'package:solar_tracker/Settings/azimuth_settings.dart';
import 'package:solar_tracker/Settings/general_page.dart';
import 'package:solar_tracker/Settings/tracker_control.dart';
import 'package:solar_tracker/Settings/tracker_location.dart';
import 'package:solar_tracker/Settings/zenith_motor_settings.dart';
import 'package:solar_tracker/Settings/zenith_settings.dart';
import 'package:solar_tracker/constants.dart';
import 'package:solar_tracker/Auth/sign_in.dart';
import 'package:solar_tracker/helping_widgets/custom_toast.dart';
import 'package:logger/logger.dart';

class TrackerSettingsPage extends StatelessWidget {
  const TrackerSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimary,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Tracker Settings'),
        backgroundColor: kSecondary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                _buildListTile(
                  context,
                  'Tracker Control',
                  const TrackerControl(),
                ),
                _buildListTile(
                  context,
                  'Azimuth Settings',
                  const AzimuthSettings(),
                ),
                _buildListTile(
                  context,
                  'Azimuth Motor',
                  const AzimuthMotorSettingsPage(),
                ),
                _buildListTile(
                    context, 'Zenith Settings', const ZenithSettings()),
                _buildListTile(
                  context,
                  'Zenith Motor',
                  const ZenithMotorSettings(),
                ),
                _buildListTile(
                  context,
                  'Location Settings',
                  const TrackerLocation(),
                ),
                _buildListTile(
                  context,
                  'General Settings',
                  const GeneralPage(),
                ),
                _buildLogoutTile(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(BuildContext context, String title, Widget page) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute<Widget>(builder: (context) => page),
            );
          },
          splashColor: Colors.white.withOpacity(0.2),
          highlightColor: Colors.white.withOpacity(0.1),
          child: Ink(
            decoration: BoxDecoration(
              color: kSecondary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              title: Text(
                title,
                style: const TextStyle(color: Colors.white),
              ),
              trailing: const Icon(
                Icons.chevron_right,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutTile(BuildContext context) {
    final Logger _logger = Logger();
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () async {
            try {
              await FirebaseAuth.instance.signOut();
              CustomToast.showToast('Logged out successfully');
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute<SignInPage>(
                    builder: (context) => const SignInPage()),
                (Route<dynamic> route) => false,
              );
            } catch (e) {
              _logger.e('Logout failed: $e');
              CustomToast.showToast('Logout failed');
            }
          },
          splashColor: Colors.red.withOpacity(0.2),
          highlightColor: Colors.red.withOpacity(0.1),
          child: Ink(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.red),
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              title: Text(
                'Logout',
                style: const TextStyle(color: Colors.red),
              ),
              trailing: const Icon(
                Icons.logout,
                color: Colors.red,
                size: 30,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
