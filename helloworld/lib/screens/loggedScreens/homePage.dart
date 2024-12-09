import 'package:flutter/material.dart';
import 'package:helloworld/screens/loggedScreens/findPage.dart';
import 'package:helloworld/screens/loggedScreens/profilePage.dart';
import 'package:helloworld/screens/loggedScreens/selectionScreen.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // Tracks the selected tab index

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update the selected tab
    });
  }

  final List<Widget> _screens = [
    const FindPage(),
    const SelectionScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Twerk",
          style: GoogleFonts.poppins(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF004AAD)),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person), // Person icon
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()));
              // Add your logic here
              print("Person icon tapped!");
            },
          ),
          IconButton(
            icon: const Icon(Icons.tune), // Tune icon
            onPressed: () {
              // Add your logic here
              print("Tune icon tapped!");
            },
          ),
        ],
      ),
      //Dynamically change Body
      body: _screens[_selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex, // Set the currently selected index
        onTap: _onItemTapped, // Handle tap events
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.thumb_up), // Like icon
            label: "Like",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work), // Work icon
            label: "Work",
          ),
        ],
      ),
    );
  }
}
