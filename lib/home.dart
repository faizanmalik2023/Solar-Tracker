import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'bluetooth_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        actions:  [
        Padding(
          padding: EdgeInsets.only(right: 8.0),
          child: GestureDetector(onTap:(){
            Navigator.push(context, MaterialPageRoute(builder: (context) => ConnectBluetoothTrackerPage()));
          },child: Icon(Icons.bluetooth, size: 30,)),
        ),
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: Icon(Icons.settings, size: 30,),
          ),


        ],
      ),
      body: const Center(
        child: Text('Welcome to the Solar Tracker!'),
      ),
    );
  }
}
