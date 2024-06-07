import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:solar_tracker/tracker_settings.dart';
import 'bluetooth_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String sunAzimuth = '';
  String sunZenith = '';
  String temperature = '';
  String trackerAzimuth = '';
  String trackerZenith = '';
  String wind = '';
  String _selectedTrackerControl = 'Option 1'; // Default selected value
  final List<String> _trackerControlOptions = ['Option 1', 'Option 2', 'Option 3'];
  Timer? _timer;
  int _timerValue = 0; // Global variable to store the timer value

  @override
  void initState() {
    super.initState();
    _fetchTrackerPosition();
  }

  void _startTimer() {
    _timerValue = 0;
    _timer?.cancel(); // Cancel any existing timer
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _timerValue++;
      });
      print(_timerValue);
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    // setState(() {
    //   _timerValue = 0; // Reset the timer value if needed
    // });
    print(_timerValue);
  }


  Future<void> _fetchTrackerPosition() async {
    final response = await http.get(Uri.parse('http://174.89.157.173:5000/trackerposition'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        sunAzimuth = double.parse(data['SunAzimuth']).toStringAsFixed(2);
        sunZenith = double.parse(data['SunZenith']).toStringAsFixed(2);
        temperature = double.parse(data['Temperature']).toStringAsFixed(2);
        trackerAzimuth = double.parse(data['TrackerAzimuth']).toStringAsFixed(2);
        trackerZenith = double.parse(data['TrackerZenith']).toStringAsFixed(2);
        wind = double.parse(data['Wind']).toStringAsFixed(2);
      });
    } else {
      // Handle the error
      throw Exception('Failed to load tracker position');
    }
  }

  List<FlSpot> _generateDataPoints(String value) {
    // Generate some example data points. You should replace this with your actual data.
    double parsedValue = double.tryParse(value) ?? 0.0;
    return List.generate(10, (index) => FlSpot(index.toDouble(), parsedValue + index.toDouble()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        foregroundColor: Colors.white,
        title: const Text('Tracker Page'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => ConnectBluetoothTrackerPage()));
              },
              child: const Icon(Icons.bluetooth, size: 30),
            ),
          ),
           Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => TrackerSettingsPage()));
              },
              child: const Icon(Icons.settings, size: 30),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.black,
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Text('Temperature (C): $temperature °C', style: TextStyle(color: Colors.white, fontSize: 18)),
              const SizedBox(height: 10),
              Text('Wind: $wind Km/h', style: TextStyle(color: Colors.white, fontSize: 18)),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Tracker Control',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 2.0),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        dropdownColor: Colors.grey[900],
                        value: _selectedTrackerControl,
                        icon: Icon(Icons.arrow_drop_down, color: Colors.grey),
                        style: TextStyle(color: Colors.white, fontSize: 16),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedTrackerControl = newValue!;
                          });
                        },
                        items: _trackerControlOptions.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text('Tracker Azimuth: $trackerAzimuth', style: TextStyle(color: Colors.white)),
              Text('Tracker Zenith: $trackerZenith', style: TextStyle(color: Colors.white)),
              const SizedBox(height: 10),
              _buildGraphSection('Sun Zenith', sunZenith, 'Zenith', 'Time'),
              _buildGraphSection('Sun Azimuth', sunAzimuth, 'Azimuth', 'Time'),
              Text('Sun Azimuth: $sunAzimuth', style: TextStyle(color: Colors.white, fontSize: 16)),
              Text('Sun Zenith: $sunZenith', style: TextStyle(color: Colors.white, fontSize: 16)),

              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _startTimer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[800],
                      foregroundColor: Colors.white,
                      minimumSize: Size(100, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                    child: Text('Start'),
                  ),
                SizedBox(width: 10,),
              ElevatedButton(
                onPressed: _stopTimer,
                //onPressed: _signIn,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[800],
                  foregroundColor: Colors.white,
                  minimumSize: Size(100, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
                child: Text('Stop'),
              ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGraphSection(String title, String zenithValue, String yAxisLabel, String xAxisLabel) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        Container(
          height: 200,
          padding: EdgeInsets.all(16.0),
          child: LineChart(
            LineChartData(
              gridData: FlGridData(show: true),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true),
                  axisNameWidget: Text(yAxisLabel, style: TextStyle(color: Colors.white)),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true),
                  axisNameWidget: Text(xAxisLabel, style: TextStyle(color: Colors.white)),
                ),
              ),
              borderData: FlBorderData(show: true),
              lineBarsData: [
                LineChartBarData(
                  spots: _generateDataPoints(zenithValue),
                  isCurved: true,
                  gradient: LinearGradient(
                    colors: [Colors.blue, Colors.purple],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  barWidth: 4,
                  isStrokeCapRound: true,
                  dotData: FlDotData(show: false),
                ),
                LineChartBarData(
                  spots: _generateDataPoints(trackerZenith),
                  isCurved: true,
                  gradient: LinearGradient(
                    colors: [Colors.green, Colors.yellow],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  barWidth: 4,
                  isStrokeCapRound: true,
                  dotData: FlDotData(show: false),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
