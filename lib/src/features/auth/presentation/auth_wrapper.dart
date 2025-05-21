import 'package:expense_mate/src/features/auth/data/auth_repository.dart';
import 'package:expense_mate/src/features/auth/presentation/login/login_screen.dart';
import 'package:expense_mate/src/features/auth/presentation/reset_password/reset_password_screen.dart';
import 'package:expense_mate/src/features/auth/presentation/signup/signup_screen.dart';
import 'package:expense_mate/src/features/rooting/root.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthRepository authRepository = AuthRepository();

    ///AuthWrapper that uses a StreamBuilder to listen to authentication state
    return StreamBuilder<User?>(
      stream: authRepository.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('An error occured'));
        }

        if (snapshot.hasData && snapshot.data != null) {
          return const MainScreen();
        }

        return AuthNavigator();
      },
    );
  }
}

class AuthNavigator extends StatelessWidget {
  const AuthNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: '/login',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/login':
            return MaterialPageRoute(builder: (_) => const LoginScreen());
          case '/signup':
            return MaterialPageRoute(builder: (_) => const SignupScreen());
          case '/reset-password':
            return MaterialPageRoute(
              builder: (_) => const ResetPasswordScreen(),
            );
          default:
            return MaterialPageRoute(builder: (_) => const LoginScreen());
        }
      },
    );
  }
}
