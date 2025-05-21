import 'package:firebase_auth/firebase_auth.dart';

/// Handles all authentication operations using Firebase Authentication.
/// /// This repository provides:
/// - User state monitoring
/// - Email/password authentication
/// - Account management
/// - Password reset functionality
///
/// Source for some of the code: https://www.youtube.com/watch?v=QSokvlp1o8U
/// +  https://firebase.google.com/docs/auth/flutter/start
class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  User? get currentUser => _firebaseAuth.currentUser;

  Future<bool> signUpWithEmailPassword(String email, String password) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> signInWithEmailPassword(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> signOut() async {
    try {
      await _firebaseAuth.signOut();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteUser({
    required String email,
    required String password,
  }) async {
    AuthCredential credential = EmailAuthProvider.credential(
      email: email,
      password: password,
    );
    try {
      //Ensure the user enters the right email and password
      await currentUser!.reauthenticateWithCredential(credential);

      //delete + signout
      await currentUser!.delete();
      await _firebaseAuth.signOut();
      return true;
    } catch (e) {
      return false;
    }
  }
}
