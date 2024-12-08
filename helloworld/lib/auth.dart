import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> signUp({
    required String email,
    required String password,
    required String username, // Include any additional user details
    required BuildContext context,
  }) async {
    try {
      // Attempt to create a user with email and password
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
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
      });

      await _firestore.collection('Users').doc(userId).collection('Active').doc("Job").set({
        'JobName': '',
        'JobDesc': '',
      });

      await _firestore.collection('Users').doc(userId).collection('History').doc("Job").set({
        'JobName': '',
        'JobDesc': '',
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Signup successful!'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate to another screen, if necessary
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
    } catch (e) {
      // Catch any other errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
