import 'package:flutter/material.dart';
import 'package:helloworld/screens/loggedScreens/employeeScreen.dart';
import 'package:helloworld/screens/loggedScreens/employerScreen.dart';

class SelectionScreen extends StatefulWidget {
  const SelectionScreen({super.key});

  @override
  State<SelectionScreen> createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen> {
  bool _isEmployer =
      false; // Tracks whether to show Employee or Employer screen

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _isEmployer ? "Employer" : "Employee",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 10), // Adds spacing between text and switch
              Switch(
                value: _isEmployer,
                onChanged: (value) {
                  setState(() {
                    _isEmployer = value; // Toggle the state
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 20), // Space between switch and body
          Expanded(
            child: Center(
              child: _isEmployer
                  ? EmployerBody() // Show EmployerScreen when switch is ON
                  : EmployeeBody(), // Show EmployeeBody when switch is OFF
            ),
          ),
        ],
      ),
    );
  }
}

class EmployeeBody extends StatelessWidget {
  const EmployeeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const EmployeeScreen();
  }
}

class EmployerBody extends StatelessWidget {
  const EmployerBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const EmployerScreen();
  }
}
