import 'package:expense_mate/src/features/auth/presentation/auth_wrapper.dart';
import 'package:expense_mate/src/shared/controllers/cashflow_controller.dart';
import 'package:expense_mate/src/shared/controllers/category_controller.dart';
import 'package:expense_mate/src/shared/controllers/theme_controller.dart';
import 'package:expense_mate/src/shared/services/notification_service.dart';
import 'package:expense_mate/src/shared/theme/dark_theme.dart';
import 'package:expense_mate/src/shared/theme/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        /// Zwei Punkte wenn eine Methode iniizial auf einem Object aufgerufen werden soll und das Object trotzdem zurückgegeben werden soll.
        ChangeNotifierProvider(
          create: (context) => CategoryController()..init(),
        ),
        ChangeNotifierProvider(
          create: (context) => CashflowController()..init(),
        ),
        ChangeNotifierProvider(create: (context) => ThemeController()),
        ChangeNotifierProvider(create: (context) => NotificationService()),
      ],
      child: Consumer<ThemeController>(
        builder: (context, themeController, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: themeController.isDark ? darkTheme : lightTheme,
            home: const AuthWrapper(),
          );
        },
      ),
    );
  }
}
