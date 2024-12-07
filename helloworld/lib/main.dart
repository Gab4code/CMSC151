import 'package:flutter/material.dart';
import 'screens/landing.dart'; // Assuming you saved the Landing widget code in a file named landing.dart

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false, // Hides the debug banner
      home: Scaffold(
        body: Landing(),
      ),
    );
  }
}
