import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solar_tracker/providers/bluetooth_provider.dart';

class ConnectBluetoothTrackerPage extends ConsumerWidget {
  const ConnectBluetoothTrackerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bluetoothState = ref.watch(bluetoothProvider);
    final bluetoothNotifier = ref.read(bluetoothProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Connect Bluetooth Tracker'),
        backgroundColor: Colors.grey[900],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Enable Bluetooth',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                Switch(
                  value: bluetoothState.bluetoothEnabled,
                  onChanged: (value) {
                    bluetoothNotifier.toggleBluetooth(context, value);
                  },
                  activeColor: Colors.deepPurple,
                ),
              ],
            ),
            const Divider(color: Colors.white),
            if (bluetoothState.isLoading)
              Center(child: CircularProgressIndicator())
            else
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '[${bluetoothState.connectedDevices.length} List Items]',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const Text(
                      'Connected Devices',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: bluetoothState.connectedDevices.length,
                        itemBuilder: (context, index) {
                          final device = bluetoothState.connectedDevices[index];
                          return Card(
                            color: Colors.teal,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(8.0),
                                onTap: () {
                                  bluetoothNotifier
                                      .disconnectFromDevice(device);
                                },
                                child: ListTile(
                                  title: Text(
                                    device.platformName,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  subtitle: Text(
                                    device.remoteId.toString(),
                                    style:
                                        const TextStyle(color: Colors.white70),
                                  ),
                                  trailing: const Icon(
                                    Icons.signal_cellular_alt,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Text(
                      '[${bluetoothState.scanResults.length} List Items]',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const Text(
                      'Available Devices',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: bluetoothState.scanResults.length,
                        itemBuilder: (context, index) {
                          final device =
                              bluetoothState.scanResults[index].device;
                          return Card(
                            color: Colors.teal,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(8.0),
                                onTap: () {
                                  bluetoothNotifier.connectToDevice(device);
                                },
                                child: ListTile(
                                  title: Text(
                                    device.platformName,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  subtitle: Text(
                                    device.remoteId.toString(),
                                    style:
                                        const TextStyle(color: Colors.white70),
                                  ),
                                  trailing: const Icon(
                                    Icons.signal_cellular_alt,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      backgroundColor: Colors.black,
    );
  }
}
