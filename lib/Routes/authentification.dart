import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

/// This class is used to manage the authentication of the user (login, register, logout)
class AuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instanceFor(
    app: Firebase.app(),
  );

  /// This method is used to sign in the user with email and password
  Future<User?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  /// This method is used to register the user with email and password
  Future<User?> registerWithEmailAndPassword(
    String email,
    String password,
    String name,
  ) async {
    try {
      final UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(result.user!.uid)
          .set(
        <String, dynamic>{
          'email': email,
          'name': name,
        },
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  /// This method is used to sign out the user
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  /// This method is used to get the user name
  Future<String> getUserName(User? user) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(user!.uid)
              .get();

      if (userSnapshot.exists) {
        final String userName = userSnapshot.data()?['name'] ?? '';
        return userName;
      } else {
        return 'User not found';
      }
    } catch (error) {
      return 'Error';
    }
  }
}
