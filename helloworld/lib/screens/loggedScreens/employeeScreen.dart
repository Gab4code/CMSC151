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
                  color: Color(0xFF004AAD), // Border color
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
                      "Job Status: $jobStatus",
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Job Description: $jobDesc",
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
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
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Job Name: ${application['jobName']}",
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        "Employer ID: ${application['employerId']}",
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              },
            ),
          )
          ],
        ),
      ),
    );
  }
}
