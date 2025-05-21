import 'package:flutter/material.dart';

//Controller to provide the currently selected theme throughout UI
class ThemeController extends ChangeNotifier {
  bool _isDark = false;

  bool get isDark => _isDark;

  void toggleTheme() {
    _isDark = !_isDark;
    notifyListeners();
  }
}
