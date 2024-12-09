import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class CreateJobScreen extends StatefulWidget {
  const CreateJobScreen({super.key});

  @override
  State<CreateJobScreen> createState() => _CreateJobScreenState();
}
final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final user = FirebaseAuth.instance.currentUser;


final TextEditingController JobNameController = TextEditingController();
final TextEditingController JobDescController = TextEditingController();

void createNewJob(BuildContext context) async {
  
    final userId = user?.uid;

    // Add job to Firestore
    await _firestore.collection('Users')
        .doc(userId)
        .collection('Employer')
        .doc("Active")
        .set({
      'JobName': JobNameController.text,
      'JobDesc': JobDescController.text,
      'JobStatus': "Available",
    });



    // Show success message
    
}



class _CreateJobScreenState extends State<CreateJobScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Text(
                  'Create Job', // Header text
                  style: GoogleFonts.poppins(
                      fontSize: 32, // Adjust size as needed
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF004AAD)),
                ),
                const SizedBox(
                    height:
                        10), // Adds space between the header and the subheader
                Text(
                  'Create New Job', // Subheader text
                  style: GoogleFonts.poppins(
                    fontSize: 16, // Adjust size as needed
                    color: Colors.grey, // Color of the subheader text
                  ),
                ),
        
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Job Name:',
                        style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF004AAD)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8), // Adds space between label and text field
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
                      controller: JobNameController,
                      keyboardType: TextInputType
                          .emailAddress, // Specifies input type as email
                      decoration: const InputDecoration(
                        hintText: 'Please the Job Name Here',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
                        border: OutlineInputBorder(borderSide: BorderSide.none),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      ),
                    ),
                  ),
                ),
        
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Job Description:',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF004AAD),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8), // Adds space between label and text field
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
                          offset: const Offset(0, 4), // Shadow offset
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: JobDescController,
                      keyboardType: TextInputType.multiline, // Allows multiline input
                      maxLines: 6, // Allows up to 6 lines of input
                      decoration: const InputDecoration(
                        hintText: 'Please enter the Job Description here',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
                        border: OutlineInputBorder(borderSide: BorderSide.none),
                        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Confirmation"),
                            content: const Text("Are you sure you want to create a new job?"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(); // Dismiss the dialog
                                },
                                child: const Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(); // Dismiss the dialog
                                  createNewJob(context); // Call the job creation function
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Job created successfully!'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                },
                                child: const Text("Confirm"),
                              ),
                            ],
                          );
                        },
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
                    'Create New job',
                    style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                    ),
                  ),
                ),
        
            ],
          ),
        ),
      ),
    );
  }
}