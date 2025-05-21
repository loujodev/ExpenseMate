import 'package:firebase_auth/firebase_auth.dart';

String? getFirebaseAuthErrorMessage(FirebaseAuthException e) {
  switch (e.code) {
    case 'user-not-found':
    case 'wrong-password':
      return 'Falsche E-Mail oder Passwort';
    case 'invalid-email':
      return 'Ungültige E-Mail-Adresse';
    case 'user-disabled':
      return 'Dieser Account wurde deaktiviert';
    case 'email-already-in-use':
      return 'Diese E-Mail wird bereits verwendet';
    case 'weak-password':
      return 'Das Passwort ist zu schwach';
    default:
      return 'Ein Fehler ist aufgetreten: ${e.message}';
  }
}
