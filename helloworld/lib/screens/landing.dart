import 'package:flutter/material.dart';
import 'package:helloworld/screens/loginPage.dart';

class Landing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set the background color
      body: GestureDetector(
        onTap: () {
          // Navigate to the LoginPage when the screen is tapped
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        },
        child: Center(
          child: Image.asset(
            'images/Twerk.PNG',
            width: 400, // Adjust the width of the image
            height: 400, // Adjust the height of the image
            fit: BoxFit.contain, // Ensures the image fits within the given dimensions
          ),
        ),
      ),
    );
  }
}