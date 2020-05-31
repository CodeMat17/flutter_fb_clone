import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Text(
        'facebook',
        style: TextStyle(
          color: Colors.blue,
          fontSize: 22.0,
          letterSpacing: 3.0,
          fontWeight: FontWeight.bold,
        ),
      )),
    );
  }
}
