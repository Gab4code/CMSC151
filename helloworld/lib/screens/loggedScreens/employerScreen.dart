import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helloworld/screens/loggedScreens/createJobScreen.dart';

class EmployerScreen extends StatefulWidget {
  const EmployerScreen({super.key});

  @override
  State<EmployerScreen> createState() => _EmployerScreenState();
}

class _EmployerScreenState extends State<EmployerScreen> {
  String jobDesc = "";
  String jobName = "";
  String jobStatus = "";

  final user = FirebaseAuth.instance.currentUser;

  List<Map<String, dynamic>> applicationJobNames = []; // To store jobName and employerId

  // Function to fetch username
  Future<String?> fetchApplicantUsername(String applicantId) async {
      try {
        DocumentSnapshot applicantSnapshot = await FirebaseFirestore.instance
            .collection('Users')
            .doc(applicantId)
            .get();

        if (applicantSnapshot.exists) {
          Map<String, dynamic> applicantData = applicantSnapshot.data() as Map<String, dynamic>;

          return applicantData['username'] ?? 'Unknown User';
        } else {
          print("Applicant document does not exist for ID: $applicantId");
          return null;
        }
      } catch (e) {
        print("Error fetching applicant username: $e");
        return null;
      }
    }

  // Function to fetch JobStatus
  Future<String?> fetchJobStatus(String applicantId) async {
    try {
      DocumentSnapshot jobStatusSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(applicantId)
          .collection('Employee')
          .doc('Active')
          .get();

      if (jobStatusSnapshot.exists) {
        Map<String, dynamic> jobStatusData = jobStatusSnapshot.data() as Map<String, dynamic>;

        return jobStatusData['JobStatus'] ?? 'Available'; // Default to 'Available'
      } else {
        print("Job status document does not exist for ID: $applicantId");
        return 'Available';
      }
    } catch (e) {
      print("Error fetching job status: $e");
      return 'Available';
    }
  }


  Future<void> fetchJobData() async {
    final userId = user?.uid;

    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .collection('Employer')
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


  void createNewJob() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateJobScreen()),
    );
    print("Navigating to Create New Job screen...");
  }

  Future<void> fetchApplications() async {
    final userId = user?.uid;

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .collection('Employer')
          .doc('Active')
          .collection('Applicants')
          .get();

       List<Map<String, dynamic>> fetchedApplications = querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return {
        'email': data['email'] ?? 'No Email',
        'applicantId': data['applicantId'] ?? 'No ApplicantID', // Assuming the document ID is the employerId
      };
    }).toList();

      setState(() {
        applicationJobNames = fetchedApplications;
      });
    } catch (e) {
      print("Error fetching applications: $e");
    }
  }

  Set<String> employedApplicants = {}; // To store IDs of employed applicants

  void _handleEmploymentToggle(String applicantId, bool isEmployed) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isEmployed ? "Remove Employment" : "Confirm Employment"),
          content: Text(
            isEmployed
                ? "Are you sure you want to remove this applicant's employment?"
                : "Are you sure you want to employ this applicant?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                if (!isEmployed) {
                  // Employ the applicant
                  await _employApplicant(applicantId);
                } else {
                  // Remove employment
                  await _removeEmployment(applicantId);
                }
              },
              child: Text(
                isEmployed ? "Remove" : "Confirm",
                style: TextStyle(color: isEmployed ? Colors.red : Colors.green),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _removeEmployment(String applicantId) async {
    try {
      // Update Firestore: Set fields to empty strings
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(applicantId)
          .collection('Employee')
          .doc("Active")
          .set({
        'JobName': '',
        'JobDesc': '',
        'JobStatus': '',
      });

      // Show Snackbar response
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Job removed successfully!'),
        backgroundColor: Colors.red, // Change color to red for removal
      ),
    );

      // Update UI
      setState(() {
        employedApplicants.remove(applicantId);
      });

      print("Employment removed and data reset successfully.");
    } catch (e) {
      print("Error removing employment: $e");
    }
  }

  Future<void> _successEmployment(String applicantId) async {
    try {
      // Update Firestore: Set fields to empty strings
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(applicantId)
          .collection('Employee')
          .doc("Active")
          .set({
        'JobName': '',
        'JobDesc': '',
        'JobStatus': '',
      });

      // Show Snackbar response
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Job finished successfully!'),
        backgroundColor: Colors.green, // Change color to green for success
      ),
    );

      // Update UI
      setState(() {
        employedApplicants.remove(applicantId);
      });

      print("Employment marked as successful and data updated successfully.");
    } catch (e) {
      print("Error removing employment: $e");
    }
  }


  Future<void> _employApplicant(String applicantId) async {
    try {
      // Fetch Job Data
      await fetchJobData(); // This updates jobDesc, jobName, and jobStatus in state

      // Write to Firestore
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(applicantId)
          .collection('Employee')
          .doc("Active")
          .set({
        'JobName': jobName,
        'JobDesc': jobDesc,
        'JobStatus': jobStatus,
      });

      // Update UI
      setState(() {
        employedApplicants.add(applicantId);
      });

      print("Applicant employed and data written successfully.");
    } catch (e) {
      print("Error employing applicant: $e");
    }
  }

  Future<void> checkEmploymentStatus() async {
  final userId = user?.uid;
  if (userId == null) return;

  // Ensure we have the employer's active job data
  await fetchJobData();

  final employerJobData = {
    'JobName': jobName,
    'JobDesc': jobDesc,
    'JobStatus': jobStatus,
  };

  Set<String> updatedEmployedApplicants = {};

  for (var application in applicationJobNames) {
    final applicantId = application['applicantId'];

    try {
      DocumentSnapshot applicantActiveDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(applicantId)
          .collection('Employee')
          .doc('Active')
          .get();

      if (applicantActiveDoc.exists) {
        final applicantJobData = applicantActiveDoc.data() as Map<String, dynamic>;

        // Compare job data
        if (applicantJobData['JobName'] == employerJobData['JobName'] &&
            applicantJobData['JobDesc'] == employerJobData['JobDesc'] ) {
          updatedEmployedApplicants.add(applicantId);
        }
      }
    } catch (e) {
      print("Error checking employment status for $applicantId: $e");
    }
  }


  

  setState(() {
    employedApplicants = updatedEmployedApplicants;
  });
}

  @override
void initState() {
  super.initState();
  fetchJobData().then((_) {
    fetchApplications().then((_) {
      checkEmploymentStatus(); // Check employment status after fetching applications
    });
  });
}

  @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Active Job Section
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xFF004AAD),
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
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
                          color: const Color(0xFF004AAD),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Job Status: $jobStatus",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: const Color(0xFF004AAD),
                            ),
                          ),
                          Switch(
                            value: jobStatus == "Available", // true if jobStatus is "Available"
                            onChanged: (bool newValue) async {
                              String updatedStatus = newValue ? "Available" : "Unavailable";
                              await FirebaseFirestore.instance
                                  .collection('Users')
                                  .doc(user?.uid) // Replace with the actual user UID
                                  .collection('Employer')
                                  .doc("Active")
                                  .update({'JobStatus': updatedStatus});

                              // Optionally update UI after Firestore update
                              setState(() {
                                jobStatus = updatedStatus;
                              });

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Job status updated to $updatedStatus!'),
                                  backgroundColor: newValue ? Colors.green : Colors.orange,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Job Description: $jobDesc",
                        style: const TextStyle(fontSize: 16),
                      ),
                      if (jobName == "No Current Active Job")
                        Center(
                          child: ElevatedButton(
                            onPressed: createNewJob,
                            child: const Text("Create New Job"),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Employed Applicants Section
              if (employedApplicants.isNotEmpty)
                Container(
                  width: MediaQuery.of(context).size.width - 32,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.green,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Employed Applicants",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Wrap the List of Applicants with SingleChildScrollView to make it scrollable
                      Container(
                      height: 60, // Limit the height of the container (you can adjust this value)
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: employedApplicants.map((applicantId) {
                            return FutureBuilder<List<dynamic>>(
                              future: Future.wait([
                                fetchApplicantUsername(applicantId),  // Fetch username
                                fetchJobStatus(applicantId),          // Fetch JobStatus
                              ]),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 4.0),
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                if (snapshot.hasError) {
                                  return const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 4.0),
                                    child: Text(
                                      "Error fetching details",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  );
                                }
                                if (!snapshot.hasData || snapshot.data == null) {
                                  return const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 4.0),
                                    child: Text(
                                      "User not found",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  );
                                }

                                final username = snapshot.data![0] as String;
                                final jobStatus = snapshot.data![1] as String;

                                // Set color based on JobStatus
                                Color textColor = _getStatusColor(jobStatus);

                               return InkWell(
  onTap: () {
    if (textColor == Colors.black)
    // Add the action you want to perform when the text is clicked
    print("Text clicked: $jobStatus - $username");
    else if(textColor == Colors.red)
    _removeEmployment(applicantId);
    else if (textColor == Colors.green)
    _successEmployment(applicantId);

  },
  child: RichText(
    text: TextSpan(
      children: [
        TextSpan(
          text: jobStatus == "Available" ? 'In Progress: ' : '$jobStatus: ', // Normal text before username
          style: TextStyle(
            fontWeight: FontWeight.bold, // Make jobStatus bold
            color: textColor, // Set the text color if needed
            fontSize: 18
          ),
        ),
        TextSpan(
          text: '$username', // Normal text for username
          style: TextStyle(
            fontWeight: FontWeight.normal, // Make username normal
            color: textColor, // Set the text color if needed
            fontSize: 18
          ),
        ),
      ],
    ),
  ),
);
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    )
                    ],
                  ),
                ),


              const SizedBox(height: 24),

              // Applicants Section
              Center(
                child: Text(
                  "Applicants",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF004AAD),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Applicant List
              Expanded(
                child: ListView.builder(
                  itemCount: applicationJobNames.length,
                  itemBuilder: (context, index) {
                    final application = applicationJobNames[index];
                    final isEmployed =
                        employedApplicants.contains(application['applicantId']);

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Applicant Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Applicant Email: ${application['email']}",
                                  style: const TextStyle(fontSize: 16),
                                ),
                                Text(
                                  "Applicant ID: ${application['applicantId']}",
                                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),

                          // Employment Toggle Button
                          IconButton(
                            icon: Icon(
                              Icons.task_alt,
                              color: isEmployed ? Colors.green : const Color(0xFF004AAD),
                            ),
                            onPressed: () => _handleEmploymentToggle(
                                application['applicantId'], isEmployed),
                          ),
                        ],
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

// Helper method to return text color based on job status
Color _getStatusColor(String jobStatus) {
  if (jobStatus == 'Finished') {
    return Colors.green; // Green for finished
  } else if (jobStatus == 'Cancelled') {
    return Colors.red; // Red for cancelled
  } else {
    return Colors.black; // Default color for available jobs
  }
}