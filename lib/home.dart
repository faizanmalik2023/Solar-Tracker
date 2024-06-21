import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:solar_tracker/helping_widgets/custom_dropdown_button.dart';
import 'package:solar_tracker/helping_widgets/custom_elevated_button.dart';
import 'package:solar_tracker/helping_widgets/custom_toast.dart';
import 'package:solar_tracker/utilities/connect_bluetooth_page.dart';
import 'package:solar_tracker/utilities/tracker_settings.dart';
import 'package:solar_tracker/constants.dart';
import 'package:logger/logger.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

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
  String _selectedTrackerControl = 'Option 1';
  final List<String> _trackerControlOptions = [
    'Option 1',
    'Option 2',
    'Option 3'
  ];
  Timer? _timer;
  final Logger _logger = Logger();

  @override
  void initState() {
    super.initState();
    _fetchTrackerPosition(); 
    _startAutoRefresh();
  }

  void _startAutoRefresh() {
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _fetchTrackerPosition();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _fetchTrackerPosition() async {
    try {
      final response = await http.get(Uri.parse('http://184.147.14.104:5000/trackerposition'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          sunAzimuth = data['SunAzimuth'].toString();
          sunZenith = data['SunZenith'].toString();
          temperature = data['Temperature'].toString();
          trackerAzimuth = data['TrackerAzimuth'].toString();
          trackerZenith = data['TrackerZenith'].toString();
          wind = data['Wind'].toString();
        });
      } else {
        _logger.e('Failed to load tracker position, Status code: ${response.statusCode}');
        CustomToast.showToast('Failed to load tracker position');
        throw Exception('Failed to load tracker position');
      }
    } catch (e) {
      _logger.e('Error fetching tracker position: $e');
      CustomToast.showToast('Error fetching tracker position');
    }
  }

  List<FlSpot> _generateDataPoints(String value) {
    double parsedValue = double.tryParse(value) ?? 0.0;
    return List.generate(10, (index) => FlSpot(index.toDouble(), parsedValue + index.toDouble()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimary,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kSecondary,
        foregroundColor: Colors.white,
        surfaceTintColor: kSecondary,
        title: const Text(
          'Tracker Page',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<ConnectBluetoothPage>(
                    builder: (context) => const ConnectBluetoothPage(),
                  ),
                );
              },
              icon: const Icon(Icons.bluetooth, size: 30),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute<TrackerSettingsPage>(
                        builder: (context) => const TrackerSettingsPage()));
              },
              icon: const Icon(Icons.settings, size: 30),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          color: kPrimary,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Text(
                'Temperature (C): $temperature °C',
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
              const SizedBox(height: 10),
              Text(
                'Wind: $wind Km/h',
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Tracker Control',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  CustomDropdownButton(
                    selectedValue: _selectedTrackerControl,
                    options: _trackerControlOptions,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedTrackerControl = newValue!;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'Tracker Azimuth: $trackerAzimuth',
                style: const TextStyle(color: Colors.white),
              ),
              Text(
                'Tracker Zenith: $trackerZenith',
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: _buildGraphSection('Sun Zenith', sunZenith, 'Zenith', 'Time'),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: _buildGraphSection('Sun Azimuth', sunAzimuth, 'Azimuth', 'Time'),
              ),
              Text(
                'Sun Azimuth: $sunAzimuth',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              Text(
                'Sun Zenith: $sunZenith',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    // CustomElevatedButton(
                    //   text: 'Start',
                    //   onPressed: _startTimer,
                    // ),
                    // CustomElevatedButton(
                    //   text: 'Stop',
                    //   onPressed: _stopTimer,
                    // ),
                  ],
                ),
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
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.225,
          child: LineChart(
            LineChartData(
              gridData: const FlGridData(show: true),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toInt().toString(),
                        style: const TextStyle(color: Colors.white),
                      );
                    },
                  ),
                  axisNameWidget: Text(
                    yAxisLabel,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toInt().toString(),
                        style: const TextStyle(color: Colors.white),
                      );
                    },
                  ),
                  axisNameWidget: Text(
                    xAxisLabel,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
              borderData: FlBorderData(
                show: true,
                border: Border.all(color: Colors.white, width: 2),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: _generateDataPoints(zenithValue),
                  isCurved: true,
                  color: const Color(0xFFe6d800),
                  barWidth: 4,
                  isStrokeCapRound: true,
                  dotData: const FlDotData(show: false),
                ),
                LineChartBarData(
                  spots: _generateDataPoints(trackerZenith),
                  isCurved: true,
                  color: const Color(0xFFe60049),
                  barWidth: 4,
                  isStrokeCapRound: true,
                  dotData: const FlDotData(show: false),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
