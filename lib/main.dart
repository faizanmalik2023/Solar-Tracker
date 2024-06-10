import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:solar_tracker/utilities/firebase_options.dart';
import 'package:solar_tracker/Auth/sign_in.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
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
      debugShowCheckedModeBanner: false,
    );
  }
}
