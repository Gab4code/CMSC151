import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helloworld/auth.dart';
import 'package:helloworld/screens/loginPage.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Variable to control visibility of password
  bool _isPasswordObscured = true;
  bool _isConfirmPasswordObscured = true;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        // Makes the entire page scrollable
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Padding around the screen
          child: Column(
            children: [
              const SizedBox(
                  height: 10), // Adds space between the image and the header
              Text(
                'Register', // Header text
                style: GoogleFonts.poppins(
                    fontSize: 32, // Adjust size as needed
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF004AAD)),
              ),
              const SizedBox(
                  height:
                      10), // Adds space between the header and the subheader
              Text(
                'Create Your Account', // Subheader text
                style: GoogleFonts.poppins(
                  fontSize: 16, // Adjust size as needed
                  color: Colors.grey, // Color of the subheader text
                ),
              ),
              const SizedBox(
                  height:
                      10), // Adds space between the header and the subheader
              Text(
                'Please Fill in Your Details', // Subheader text
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
                          color: const Color(0xFF004AAD)),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                  height: 8), // Adds space between label and text field
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0), // Adds padding on the sides
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white, // Background color for the container
                    borderRadius: BorderRadius.circular(8), // Rounded corners
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black
                            .withOpacity(0.1), // Shadow color with opacity
                        spreadRadius: 2, // Spread radius for the shadow
                        blurRadius: 5, // Blur radius for the shadow
                        offset: const Offset(0,
                            4), // Shadow offset, position relative to the text field
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: emailController,
                    keyboardType: TextInputType
                        .emailAddress, // Specifies input type as email
                    decoration: const InputDecoration(
                      hintText: 'Please enter your Email Here',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                  height: 20), // Space between email and password fields

              // Username TextField
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Username',
                      style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF004AAD)),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                  height: 8), // Adds space between label and text field
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0), // Adds padding on the sides
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white, // Background color for the container
                    borderRadius: BorderRadius.circular(8), // Rounded corners
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black
                            .withOpacity(0.1), // Shadow color with opacity
                        spreadRadius: 2, // Spread radius for the shadow
                        blurRadius: 5, // Blur radius for the shadow
                        offset: const Offset(0,
                            4), // Shadow offset, position relative to the text field
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: usernameController,
                    decoration: const InputDecoration(
                      hintText: 'Please enter your Username Here',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
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
                        color: const Color(0xFF004AAD),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                  height: 8), // Adds space between label and text field
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0), // Adds padding on the sides
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white, // Background color for the container
                    borderRadius: BorderRadius.circular(8), // Rounded corners
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black
                            .withOpacity(0.1), // Shadow color with opacity
                        spreadRadius: 2, // Spread radius for the shadow
                        blurRadius: 5, // Blur radius for the shadow
                        offset: const Offset(0,
                            4), // Shadow offset, position relative to the text field
                      ),
                    ],
                  ),
                  child: TextField(
                    obscureText:
                        _isPasswordObscured, // Controls password visibility
                    controller: passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      hintText: 'Please enter your Password Here',
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: const OutlineInputBorder(
                          borderSide:
                              BorderSide.none), // Removes default border
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16), // Padding inside the text field
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordObscured
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordObscured =
                                !_isPasswordObscured; // Toggle visibility
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Password TextField
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Confirm Password',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF004AAD),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                  height: 8), // Adds space between label and text field
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0), // Adds padding on the sides
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white, // Background color for the container
                    borderRadius: BorderRadius.circular(8), // Rounded corners
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black
                            .withOpacity(0.1), // Shadow color with opacity
                        spreadRadius: 2, // Spread radius for the shadow
                        blurRadius: 5, // Blur radius for the shadow
                        offset: const Offset(0,
                            4), // Shadow offset, position relative to the text field
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: confirmPasswordController,
                    obscureText:
                        _isConfirmPasswordObscured, // Controls password visibility
                    decoration: InputDecoration(
                      hintText: 'Please Re-enter your Password',
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: const OutlineInputBorder(
                          borderSide:
                              BorderSide.none), // Removes default border
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16), // Padding inside the text field
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isConfirmPasswordObscured
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _isConfirmPasswordObscured =
                                !_isConfirmPasswordObscured; // Toggle visibility
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30), // Adds space before the login button

              //LOGIN BUTTON
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF004AAD),
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                  textStyle: const TextStyle(fontSize: 18),
                  minimumSize: const Size(150, 50),
                ),
                child: Text(
                  'Login',
                  style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
              ),

              //Register BUTTON
              ElevatedButton(
                onPressed: () async {
                  if (passwordController.text !=
                      confirmPasswordController.text) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Passwords do not match!'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  await AuthService.signUp(
                    email: emailController.text,
                    password: passwordController.text,
                    context: context,
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                  textStyle: const TextStyle(fontSize: 18),
                  minimumSize: const Size(150, 50),
                ),
                child: Text(
                  'Register',
                  style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF004AAD)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
