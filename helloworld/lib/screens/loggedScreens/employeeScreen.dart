import 'package:cloud_firestore/cloud_firestore.dart';
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

  Future<void> fetchJobData() async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc('nKJW1wVMbWSvOxlkKsNOg9frgYv2')
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

  @override
  void initState() {
    super.initState();
    fetchJobData();
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
        child: Container(
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
      ),
    );
  }
}
