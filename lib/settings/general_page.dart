import 'package:flutter/material.dart';
class GeneralPage extends StatefulWidget {
  const GeneralPage({super.key});

  @override
  State<GeneralPage> createState() => _GeneralPageState();
}

class _GeneralPageState extends State<GeneralPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        foregroundColor: Colors.white,
        title: const Text(
          'General Page',style: TextStyle(
          color: Colors.white
        ),
        ),
      ),
    );
  }
}
