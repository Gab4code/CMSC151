import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EmployeeScreen extends StatefulWidget {
  const EmployeeScreen({super.key});

  @override
  State<EmployeeScreen> createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  String jobDesc = "";
  String jobName = "";
  String jobStatus = "";

  final user = FirebaseAuth.instance.currentUser;

  List<Map<String, dynamic>> applicationJobNames = []; // To store jobName and employerId

  Future<void> fetchJobData() async {
    final userId = user?.uid;

    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .collection('Employee')
          .doc('Active')
          .get();

      if (documentSnapshot.exists) {
        final data = documentSnapshot.data() as Map<String, dynamic>;
        setState(() {
          jobDesc = (data['JobDesc'] != null && data['JobDesc'].trim().isNotEmpty)
              ? data['JobDesc']
              : "No Available Data";

          jobName = (data['JobName'] != null && data['JobName'].trim().isNotEmpty)
              ? data['JobName']
              : "No Current Active Job";

          jobStatus = (data['JobStatus'] != null && data['JobStatus'].trim().isNotEmpty)
              ? data['JobStatus']
              : "No Available Data";
        });
      } else {
        print("Document does not exist! \n No Current Active Jobs");
      }
    } catch (e) {
      print("Error fetching document: $e");
    }
  }

  Future<void> fetchApplications() async {
    final userId = user?.uid;

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .collection('Employee')
          .doc('Active')
          .collection('Applications')
          .get();

       List<Map<String, dynamic>> fetchedApplications = querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return {
        'jobName': data['jobName'] ?? 'Unnamed Job',
        'employerId': data['employerId'] ?? 'No EmployerID Job', // Assuming the document ID is the employerId
      };
    }).toList();

      setState(() {
        applicationJobNames = fetchedApplications;
      });
    } catch (e) {
      print("Error fetching applications: $e");
    }
  }

  Future<void> _removeApplication(String employerId) async {
    final userId = user?.uid;
    try {
      // Delete the document from Firestore
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .collection('Employee')
          .doc('Active')
          .collection('Applications')
          .doc(employerId)
          .delete();

      await FirebaseFirestore.instance
          .collection('Users')
          .doc(employerId)
          .collection('Employer')
          .doc('Active')
          .collection('Applicants')
          .doc(userId)
          .delete();

      //remove current Active Job aswell
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .collection('Employee')
          .doc("Active")
          .set({
        'JobName': '',
        'JobDesc': '',
        'JobStatus': '',
      });

      // Update the UI by removing the application from the local list
      setState(() {
        applicationJobNames.removeWhere((application) => application['employerId'] == employerId);
      });

      print("Application removed successfully.");
    } catch (e) {
      print("Error removing application: $e");
    }
  }

  void _confirmAndRemoveApplication(String employerId) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Confirm Deletion"),
            content: const Text("Are you sure you want to remove this application?"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  _removeApplication(employerId); // Call the remove function
                },
                child: const Text("Remove", style: TextStyle(color: Colors.red)),
              ),
            ],
          );
        },
      );
    }

    Future<void> _finishJob(String? employerId) async {
        final userId = user?.uid;
        try {
          // Update the JobStatus to 'Finished' for the current active job
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(userId)
              .collection('Employee')
              .doc('Active')
              .update({'JobStatus': 'Finished'});


          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Job Marked As: FINISHED'), backgroundColor: Colors.green,),
          );

          print("Job marked as finished successfully.");
        } catch (e) {
          print("Error finishing job: $e");
        }
      }
    Future<void> _cancelJob(String? userId) async {
        try {
          // Update the JobStatus to 'Cancelled' for the current active job
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(userId)
              .collection('Employee')
              .doc('Active')
              .update({'JobStatus': 'Cancelled'});

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Job Marked As: CANCELLED'), backgroundColor: Colors.red,),
          );

          print("Job marked as cancelled successfully.");
        } catch (e) {
          print("Error cancelling job: $e");
        }
      }
  

  @override
  void initState() {
    super.initState();
    fetchJobData();
    fetchApplications();
  }

  void FindNewJob() {
    // Navigate to a job creation page or implement job creation logic here
    print("Navigating to Create New Job screen...");
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16.0), // Optional padding inside the border
            decoration: BoxDecoration(
              border: Border.all(
                color: _getBorderColor(jobStatus), // Border color
                width: 2.0,         // Border width
              ),
              borderRadius: BorderRadius.circular(8.0), // Optional rounded corners
            ),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Active Job: $jobName",
                    style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF004AAD)),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Job Description: $jobDesc",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  // Show Finish and Cancel buttons if there is an active job
                  if (jobName != "No Current Active Job") ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Finish Button
                        ElevatedButton(
                          onPressed: () {
                            _finishJob(user?.uid);
                          },
                          child: Text("Finish", style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green, // Green button for Finish
                          ),
                        ),
                        const SizedBox(width: 50),
                        // Cancel Button
                        ElevatedButton(
                          onPressed: () {
                            _cancelJob(user?.uid);
                          },
                          child: Text("Cancel", style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red, // Red button for Cancel
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (jobName == "No Current Active Job")
                    Center(
                      child: ElevatedButton(
                        onPressed: FindNewJob,
                        child: const Text("Go to Find Jobs"),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24), // Space between the container and the new text
          Center(
            child: Text(
              "Applications",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF004AAD),
              ),
            ),
          ),
          const SizedBox(height: 8), // Add some space between the header and list
          Expanded(
            child: ListView.builder(
              itemCount: applicationJobNames.length,
              itemBuilder: (context, index) {
                final application = applicationJobNames[index];
                // Check if the application matches the active job
                final isCurrentJob = jobName == application['jobName'];

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isCurrentJob ? Colors.green.withOpacity(0.2) : Colors.transparent, // Highlight current job
                      border: Border.all(
                        color: isCurrentJob ? Colors.green : Colors.grey, // Border color based on condition
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Display Job Name and Employer ID
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Job Name: ${application['jobName']}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: isCurrentJob ? FontWeight.bold : FontWeight.normal,
                                    color: isCurrentJob ? Colors.green : Colors.black,
                                  ),
                                ),
                                Text(
                                  "Employer ID: ${application['employerId']}",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Conditional icons based on whether it's the active job or not
                        IconButton(
                          icon: isCurrentJob
                              ? const Icon(Icons.check_circle, color: Colors.green)  // Active job: check-circle icon
                              : const Icon(Icons.cancel, color: Colors.red),        // Not the active job: cancel icon
                          onPressed: () {
                            if (isCurrentJob) {
                              print("CurrentJob");
                            } else {
                              _confirmAndRemoveApplication(application['employerId']);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}
}

// Helper method to return the border color based on job status
Color _getBorderColor(String jobStatus) {
  if (jobStatus == 'Finished') {
    return Colors.green; // Green for finished
  } else if (jobStatus == 'Cancelled') {
    return Colors.red; // Red for cancelled
  } else {
    return Color(0xFF004AAD); // Default color for available jobs
  }
}