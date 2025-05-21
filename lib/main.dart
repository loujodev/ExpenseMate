import 'package:expense_mate/src/app.dart';
import 'package:expense_mate/src/shared/services/notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().initializeNotification();
  await Firebase.initializeApp();
  runApp(const App());
}
