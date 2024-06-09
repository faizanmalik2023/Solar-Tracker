import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:solar_tracker/firebase_options.dart';
import 'Auth/sign_in.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
