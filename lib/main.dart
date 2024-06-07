import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:solar_tracker/Settings/azimuth_motor_settings.dart';
import 'package:solar_tracker/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solar_tracker/tracker_settings.dart';
//import 'azimuth_motor_settings_page.dart';
import 'Auth/sign_in.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Solar Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SignInPage(),
    );
  }
}
