import 'package:flutter/material.dart';

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
                _buildListTile(context, 'Tracker Control', TrackerControlPage()),
                _buildListTile(context, 'Azimuth Settings', AzimuthSettingsPage()),
                _buildListTile(context, 'Azimuth Motor', AzimuthMotorPage()),
                _buildListTile(context, 'Zenith Settings', ZenithSettingsPage()),
                _buildListTile(context, 'Zenith Motor', ZenithMotorPage()),
                _buildListTile(context, 'Location', LocationPage()),
                _buildListTile(context, 'General', GeneralPage()),
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

class TrackerControlPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tracker Control')),
      body: Center(child: Text('Tracker Control Page')),
    );
  }
}

class AzimuthSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Azimuth Settings')),
      body: Center(child: Text('Azimuth Settings Page')),
    );
  }
}

class AzimuthMotorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Azimuth Motor')),
      body: Center(child: Text('Azimuth Motor Page')),
    );
  }
}

class ZenithSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Zenith Settings')),
      body: Center(child: Text('Zenith Settings Page')),
    );
  }
}

class ZenithMotorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Zenith Motor')),
      body: Center(child: Text('Zenith Motor Page')),
    );
  }
}

class LocationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Location')),
      body: Center(child: Text('Location Page')),
    );
  }
}

class GeneralPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('General')),
      body: Center(child: Text('General Page')),
    );
  }
}
