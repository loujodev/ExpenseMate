import 'package:expense_mate/src/features/profilepage/presentation/profile_page.dart';
import 'package:expense_mate/src/shared/controllers/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

///Switch to change the current color theme used on [ProfilePage]
class ThemeSwitch extends StatefulWidget {
  const ThemeSwitch({super.key});

  @override
  State<ThemeSwitch> createState() => _ThemeSwitchState();
}

class _ThemeSwitchState extends State<ThemeSwitch> {
  bool isDark = true;

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);

    return Row(
      children: [
        Switch(
          value: isDark, // Use the state variable instead of hardcoded true
          onChanged: (bool value) {
            setState(() {
              isDark = value;
            });
            themeController.toggleTheme();
          },
        ),
      ],
    );
  }
}
