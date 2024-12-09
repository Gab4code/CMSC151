import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tindercard_plus/flutter_tindercard_plus.dart';

class FindPage extends StatefulWidget {
  const FindPage({super.key});

  @override
  State<FindPage> createState() => _FindPageState();
}

class _FindPageState extends State<FindPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> jobs = []; // List to store jobs dynamically
  final List<Map<String, dynamic>> swipedCards = []; // Track swiped cards
  bool isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();
    // Fetch jobs when the page is loaded
    Future.delayed(Duration.zero, () async {
      await fetchJobsAcrossUsers();
    });
  }

  // Fetch jobs across users from Firestore
  Future<void> fetchJobsAcrossUsers() async {
  try {
    final userDocs = await _firestore.collection('Users').get();

    List<Map<String, dynamic>> fetchedJobs = [];

    for (var userDoc in userDocs.docs) {
      // Fetch the 'Active' document within the 'Employer' collection
      final activeDoc = await _firestore
          .collection('Users')
          .doc(userDoc.id)
          .collection('Employer')
          .doc('Active')
          .get();

      // Check if the 'JobStatus' in the 'Active' document is 'Available'
      if (activeDoc.exists && activeDoc.data()?['JobStatus'] == 'Available') {
        // If 'JobStatus' is 'Available', fetch the job data from this document
        final jobData = {
          'JobName': activeDoc.data()?['JobName'] ?? 'Unnamed Job',
          'JobDescription': activeDoc.data()?['JobDesc'] ?? 'No description provided',
        };

        // Add the job data to the fetchedJobs list
        fetchedJobs.add(jobData);
      }
    }

    setState(() {
      jobs = fetchedJobs;
      isLoading = false;
    });
  } catch (e) {
    print('Error fetching jobs: $e');
    setState(() {
      isLoading = false;
    });
  }
}

  // Method to go back to the previous swiped card
  void goBackToPreviousCard() {
    if (swipedCards.isNotEmpty) {
      final lastCard = swipedCards.removeLast(); // Remove the last swiped card
      setState(() {
        jobs.insert(0, lastCard); // Reinsert it to the top of the stack
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No card to undo!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Jobs'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.undo),
            onPressed: goBackToPreviousCard,
          ),
        ],
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator() // Show loading spinner
            : jobs.isNotEmpty
                ? TinderSwapCard(
                    swipeUp: false,
                    swipeDown: false,
                    orientation: AmassOrientation.top,
                    totalNum: jobs.length,
                    stackNum: 3,
                    maxWidth: MediaQuery.of(context).size.width * 0.9,
                    maxHeight: MediaQuery.of(context).size.height * 0.7,
                    minWidth: MediaQuery.of(context).size.width * 0.8,
                    minHeight: MediaQuery.of(context).size.height * 0.6,
                    cardBuilder: (context, index) => Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Job Name: ${jobs[index]['JobName']}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Job Description: ${jobs[index]['JobDescription']}',
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    swipeCompleteCallback: (CardSwipeOrientation orientation, int index) {
                      if (orientation == CardSwipeOrientation.left) {
                        print('Swiped Left: ${jobs[index]['JobName']}');
                        swipedCards.add(jobs[index]); // Add swiped card to the list
                      } else if (orientation == CardSwipeOrientation.right) {
                        print('Swiped Right: ${jobs[index]['JobName']}');
                        swipedCards.add(jobs[index]);
                      }
                      setState(() {
                        jobs.removeAt(index); // Remove the card from the stack
                      });
                    },
                  )
                : const Text('No jobs available!'),
      ),
    );
  }
}