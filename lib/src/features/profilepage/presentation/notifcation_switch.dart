import 'package:expense_mate/src/shared/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationSwitch extends StatefulWidget {
  const NotificationSwitch({super.key});

  @override
  State<NotificationSwitch> createState() => _NotificationSwitchState();
}

class _NotificationSwitchState extends State<NotificationSwitch> {
  @override
  Widget build(BuildContext context) {
    // Get the existing NotificationService instance
    final notificationService = Provider.of<NotificationService>(context);

    return Row(
      children: [
        Switch(
          value: notificationService.notificationsEnabled,
          onChanged: (bool value) async {
            await notificationService.toggleNotifications();
            setState(() {});
          },
        ),
      ],
    );
  }
}
