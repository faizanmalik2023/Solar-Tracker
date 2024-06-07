import 'package:flutter/material.dart';
import 'package:solar_tracker/Settings/azimuth_motor_settings.dart';
import 'package:solar_tracker/Settings/azimuth_settings.dart';
import 'package:solar_tracker/Settings/general_page.dart';
import 'package:solar_tracker/Settings/tracker_control.dart';
import 'package:solar_tracker/Settings/tracker_location.dart';
import 'package:solar_tracker/Settings/zenith_motor_settings.dart';
import 'package:solar_tracker/Settings/zenith_settings.dart';

class TrackerSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black38,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 10.0,left: 10),
            child: Text(
              'Tracker Settings',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.w600
              ),
            ),
          ),
          const Divider(
            color: Colors.blueAccent,
            thickness: 1,
          ),

          Expanded(
            child: ListView(
              children: [
                _buildListTile(context, 'Tracker Control', const TrackerControl()),
                _buildListTile(context, 'Azimuth Settings', const AzimuthSettings()),
                _buildListTile(context, 'Azimuth Motor', AzimuthMotorSettingsPage()),
                _buildListTile(context, 'Zenith Settings', const ZenithSettings()),
                _buildListTile(context, 'Zenith Motor', const ZenithMotorSettings()),
                _buildListTile(context, 'Location', const TrackerLocation()),
                _buildListTile(context, 'General', const GeneralPage()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Padding _buildListTile(BuildContext context, String title, Widget page) {
    return Padding(
      padding: const EdgeInsets.only(left: 13.0, right: 13, bottom: 15),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey[900]
        ),
        child: ListTile(
          title: Text(
            title,
            style: const TextStyle(color: Colors.white),
          ),
          trailing: const Icon(Icons.chevron_right, color: Colors.white,size:30,),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => page),
            );
          },
        ),
      ),
    );
  }
}
