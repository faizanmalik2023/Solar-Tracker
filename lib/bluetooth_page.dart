import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'dart:async';
import 'dart:io' show Platform;

class ConnectBluetoothTrackerPage extends StatefulWidget {
  @override
  _ConnectBluetoothTrackerPageState createState() => _ConnectBluetoothTrackerPageState();
}

class _ConnectBluetoothTrackerPageState extends State<ConnectBluetoothTrackerPage> {
  //FlutterBluePlus flutterBlue = FlutterBluePlus.adapterName;
  bool _bluetoothEnabled = false;
  List<BluetoothDevice> connectedDevices = [];
  List<ScanResult> scanResults = [];
  StreamSubscription<BluetoothAdapterState>? _adapterStateSubscription;
  StreamSubscription<List<ScanResult>>? _scanResultsSubscription;

  @override
  void initState() {
    super.initState();
    _initBluetooth();
  }

  @override
  void dispose() {
    _adapterStateSubscription?.cancel();
    _scanResultsSubscription?.cancel();
    super.dispose();
  }

  void _initBluetooth() async {
    // Check if Bluetooth is supported
    if (await FlutterBluePlus.isSupported == false) {
      print("Bluetooth not supported by this device");
      return;
    }

    // Handle Bluetooth on & off
    _adapterStateSubscription = FlutterBluePlus.adapterState.listen((BluetoothAdapterState state) {
      setState(() {
        _bluetoothEnabled = (state == BluetoothAdapterState.on);
      });
      if (state == BluetoothAdapterState.on) {
        _startScan();
      } else {
        _stopScan();
      }
    });

    // Get connected devices
    // FlutterBluePlus.connectedDevices.asStream().listen((devices) {
    //   setState(() {
    //     connectedDevices = devices;
    //   });
    // });
    setState(() {
      connectedDevices=FlutterBluePlus.connectedDevices;
    });

    // Listen to scan results
    _scanResultsSubscription = FlutterBluePlus.scanResults.listen((results) {
      setState(() {
        scanResults = results;
      });
    });
  }

  void _toggleBluetooth(bool value) async {
    if (Platform.isAndroid) {
      if (value) {
        await FlutterBluePlus.turnOn();
      } else {
        await FlutterBluePlus.;
      }
    }
    setState(() {
      _bluetoothEnabled = value;
    });
  }

  void _startScan() {
    FlutterBluePlus.startScan(timeout: Duration(seconds: 4));
  }

  void _stopScan() {
    FlutterBluePlus.stopScan();
    setState(() {
      scanResults.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Connect Bluetooth Tracker'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Enable Bluetooth',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                Switch(
                  value: _bluetoothEnabled,
                  onChanged: _toggleBluetooth,
                  activeColor: Colors.deepPurple,
                ),
              ],
            ),
            Divider(color: Colors.white),
            Text(
              '[${connectedDevices.length} List Items]',
              style: TextStyle(color: Colors.grey),
            ),
            Text(
              'Connected Devices',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Finding...',
              style: TextStyle(color: Colors.grey),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: connectedDevices.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.teal,
                    child: ListTile(
                      title: Text(
                        connectedDevices[index].name,
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        connectedDevices[index].id.toString(),
                        style: TextStyle(color: Colors.white70),
                      ),
                      trailing: Icon(
                        Icons.signal_cellular_alt,
                        color: Colors.white,
                      ),
                      onTap: () {
                        // Handle device tap
                      },
                    ),
                  );
                },
              ),
            ),
            Text(
              '[${scanResults.length} List Items]',
              style: TextStyle(color: Colors.grey),
            ),
            Text(
              'Devices',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Scanning...',
              style: TextStyle(color: Colors.grey),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: scanResults.length,
                itemBuilder: (context, index) {
                  final device = scanResults[index].device;
                  return Card(
                    color: Colors.teal,
                    child: ListTile(
                      title: Text(
                        device.name,
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        device.id.toString(),
                        style: TextStyle(color: Colors.white70),
                      ),
                      trailing: Icon(
                        Icons.signal_cellular_alt,
                        color: Colors.white,
                      ),
                      onTap: () {
                        // Handle device tap
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.black,
    );
  }
}
