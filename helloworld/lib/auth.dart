import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Signup Method
  static Future<bool> signUp({
    required String email,
    required String password,
    required String username,
    required BuildContext context,
  }) async {
    try {
      // Attempt to create a user with email and password
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get the newly created user ID
      String userId = userCredential.user!.uid;

      // Save user details to Firestore
      await _firestore.collection('Users').doc(userId).set({
        'email': email,
        'username': username,
        'createdAt': FieldValue.serverTimestamp(),
        'mobileNumber': "",
        'address': "",
      });

      await _firestore
          .collection('Users')
          .doc(userId)
          .collection('Employee')
          .doc("Active")
          .set({
        'JobName': '',
        'JobDesc': '',
        'JobStatus': '',
      });
      await _firestore
          .collection('Users')
          .doc(userId)
          .collection('Employee')
          .doc("History")
          .set({
        'JobName': '',
        'JobDesc': '',
        'JobStatus': '',
      });

      await _firestore
          .collection('Users')
          .doc(userId)
          .collection('Employer')
          .doc("Active")
          .set({
        'JobName': '',
        'JobDesc': '',
        'JobStatus': '',
      });
      await _firestore
          .collection('Users')
          .doc(userId)
          .collection('Employer')
          .doc("History")
          .set({
        'JobName': '',
        'JobDesc': '',
        'JobStatus': '',
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Signup successful!'),
          backgroundColor: Colors.green,
        ),
      );

      return true; // Indicate success
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'This email is already in use.';
          break;
        case 'invalid-email':
          errorMessage = 'This email address is invalid.';
          break;
        case 'weak-password':
          errorMessage = 'The password is too weak.';
          break;
        default:
          errorMessage = 'An unknown error occurred.';
      }

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
      return false; // Indicate failure
    } catch (e) {
      // Catch any other errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
      return false; // Indicate failure
    }
  }

// =============================================================================
  // Login method
  static Future<bool> login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      // Attempt to sign in the user with Firebase
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      // If successful, return true
      return true;
    } on FirebaseAuthException catch (e) {
      // Print error code to debug
      print('FirebaseAuthException: ${e.code}');
      String errorMessage;

      // Handle Firebase login errors
      switch (e.code) {
        case 'invalid-credential':
          errorMessage = 'Incorrect email or password. Please try again.';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email address.';
          break;
        default:
          errorMessage = 'An unknown error occurred.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
      return false; // Login failed
    } catch (e) {
      // Handle general errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
      return false; // Login failed
    }
  }

  // ===========================================================================

  // Logout method
  static Future<void> logout({required BuildContext context}) async {
    try {
      await _auth.signOut(); // Sign out the user

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Logout successful!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      // Handle errors during logout
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error during logout: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  // ===========================================================================
}

class UserDataService {
  // Function to fetch user data using the logged-in user's email
  Future<Map<String, String?>> fetchUserData() async {
    try {
      // Get the current logged-in user
      //User? user = FirebaseAuth.instance.currentUser;
      String user = FirebaseAuth.instance.currentUser!.uid;

      // Use the user's email or UID to query Firestore
      //String userEmail = user.email ?? '';

      // Retrieve the user data from Firestore
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('Users') // The Firestore collection name
          .doc(
              user) // Use the email as the document ID (or use user.uid for UID-based document)
          .get();
      if (snapshot.exists) {
        // Return user data as a Map
        return {
          'username': snapshot['username'] ?? '',
          'email': snapshot['email'] ?? '',
          'mobileNumber': snapshot['mobileNumber'] ?? '',
          'address': snapshot['address'] ?? '',
        };
      } else {
        print("No user found for the email: $user");
        return {};
      }
    } catch (e) {
      print("Error fetching user data: $e");
      return {};
    }
  }
}
