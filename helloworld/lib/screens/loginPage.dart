import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helloworld/screens/loggedScreens/homePage.dart';
import 'package:helloworld/screens/registerPage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Variable to control visibility of password
  bool _isPasswordObscured = true;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  SingleChildScrollView( // Makes the entire page scrollable
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Padding around the screen
          child:Column(
        children: [
          Center(
            child: Image.asset(
              'images/Twerk.PNG', // Display the image at the top of the login page
              width: 200, // Adjust size as needed
              height: 200,
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(height: 10), // Adds space between the image and the header
          Text(
            'Login', // Header text
            style: GoogleFonts.poppins(
              fontSize: 32, // Adjust size as needed
              fontWeight: FontWeight.bold,
              color: Color(0xFF004AAD)
            ),
          ),
          SizedBox(height: 10), // Adds space between the header and the subheader
          Text(
            'Sign-in to Continue', // Subheader text
            style: GoogleFonts.poppins(
              fontSize: 16, // Adjust size as needed
              color: Colors.grey, // Color of the subheader text
            ),
          ),
          // Email TextField
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Email', 
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF004AAD)
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8), // Adds space between label and text field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0), // Adds padding on the sides
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white, // Background color for the container
                  borderRadius: BorderRadius.circular(8), // Rounded corners
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1), // Shadow color with opacity
                      spreadRadius: 2, // Spread radius for the shadow
                      blurRadius: 5, // Blur radius for the shadow
                      offset: Offset(0, 4), // Shadow offset, position relative to the text field
                    ),
                  ],
                ),
                child: TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress, // Specifies input type as email
                  decoration: InputDecoration(
                    hintText: 'Enter your Email Here',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                    contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20), // Space between email and password fields

            // Password TextField
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Password', 
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF004AAD),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8), // Adds space between label and text field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0), // Adds padding on the sides
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white, // Background color for the container
                  borderRadius: BorderRadius.circular(8), // Rounded corners
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1), // Shadow color with opacity
                      spreadRadius: 2, // Spread radius for the shadow
                      blurRadius: 5, // Blur radius for the shadow
                      offset: Offset(0, 4), // Shadow offset, position relative to the text field
                    ),
                  ],
                ),
                 child: TextField(
                    controller: passwordController,
                    obscureText: _isPasswordObscured, // Controls password visibility
                    decoration: InputDecoration(
                      hintText: 'Enter your Password Here',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(borderSide: BorderSide.none), // Removes default border
                      contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16), // Padding inside the text field
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordObscured ? Icons.visibility_off : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordObscured = !_isPasswordObscured; // Toggle visibility
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ),
            SizedBox(height: 30), // Adds space before the login button

            //LOGIN BUTTON
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
                // Handle login action here
                String email = emailController.text;
                String password = passwordController.text;
                print('Entered email: $email');
                print('Entered password: $password');
              },
              child: Text(
                'Login',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF004AAD)
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                textStyle: TextStyle(fontSize: 18),
                minimumSize: Size(150, 50),
              ),
            ),


            //Register BUTTON
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterPage()),
                );
              },
              child: Text(
                'Register',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF004AAD),
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                textStyle: TextStyle(fontSize: 18),
                minimumSize: Size(150, 50),
              ),
            ),
        ],
      ),
        ),
    ),
    );
  }
}
