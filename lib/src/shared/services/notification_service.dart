import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService extends ChangeNotifier {
  final notificationsPlugin = FlutterLocalNotificationsPlugin();

  // ignore: prefer_final_fields
  bool _isInitialized = false;
  bool _notificationsEnabled = true;

  bool get isInitialzied => _isInitialized;
  bool get notificationsEnabled => _notificationsEnabled;

  //Init
  Future<void> initializeNotification() async {
    if (_isInitialized) return;

    tz_data.initializeTimeZones();
    final String currentTimeZONE = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimeZONE));

    const initSettingsiOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(iOS: initSettingsiOS);

    await notificationsPlugin.initialize(initSettings);
  }

  //Setup
  NotificationDetails notificationDetails() {
    return const NotificationDetails(iOS: DarwinNotificationDetails());
  }

  Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
  }) async {
    return notificationsPlugin.show(
      id,
      title,
      body,
      const NotificationDetails(),
    );
  }

  Future<void> requestPermissions() async {
    if (Platform.isIOS) {
      await notificationsPlugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    }
  }

  Future<void> scheduleNotification({
    int id = 1,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    //Get current date/time
    final now = tz.TZDateTime.now(tz.local);

    //Create a date and time for today at the specified hour/min
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    //Schedule the notification
    await notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      const NotificationDetails(),

      //androidscheduleMode is required even though it is an iOS App
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,

      //repeat the notification daily at the same time
      matchDateTimeComponents: DateTimeComponents.time,
    );
    //print("notificationScheduled");
  }

  Future<void> cancelAllNotifications() async {
    await notificationsPlugin.cancelAll();
  }

  Future<void> enableNotifications() async {
    _notificationsEnabled = true;
    // You might want to re-schedule notifications here if needed
  }

  Future<void> disableNotifications() async {
    _notificationsEnabled = false;
    await cancelAllNotifications();
  }

  Future<void> toggleNotifications() async {
    _notificationsEnabled = !_notificationsEnabled;
    notifyListeners();
  }
}
