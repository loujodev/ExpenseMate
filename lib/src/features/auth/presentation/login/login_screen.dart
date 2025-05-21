import 'package:expense_mate/src/features/auth/data/auth_repository.dart';
import 'package:expense_mate/src/shared/extension/custom_theme_extension.dart';
import 'package:expense_mate/src/shared/utils/firebase_exception_utils.dart';
import 'package:expense_mate/src/shared/utils/form_validators.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthRepository _authRepository = AuthRepository();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _authRepository.signInWithEmailPassword(
        _emailController.text.trim(),
        _passwordController.text,
      );
    } catch (e) {
      setState(() {
        if (e is FirebaseAuthException) {
          _errorMessage = getFirebaseAuthErrorMessage(e);
        } else {
          _errorMessage = 'An unknown error occured';
        }
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<CustomThemeColorsExtension>();
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: theme?.mainBackGroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: screenSize.height * 0.08),

                  // App title
                  Center(
                    child: Text(
                      'ExpenseMate',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: theme?.textColor,
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  // Tagline
                  Center(
                    child: Text(
                      'Welcome Back',
                      style: TextStyle(fontSize: 18, color: theme?.textColor),
                    ),
                  ),

                  SizedBox(height: screenSize.height * 0.08),

                  // email field
                  Container(
                    decoration: BoxDecoration(
                      color: theme?.secondaryBackgroundColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(color: theme?.textColor),
                      decoration: InputDecoration(
                        labelText: 'Mail',
                        labelStyle: TextStyle(color: theme?.textColor),
                        prefixIcon: Icon(Icons.email, color: theme?.textColor),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                      ),
                      validator: FormValidators.validateEmail,
                    ),
                  ),

                  SizedBox(height: 20),

                  // Passwort Feld
                  Container(
                    decoration: BoxDecoration(
                      color: theme?.secondaryBackgroundColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      style: TextStyle(color: theme?.textColor),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(color: theme?.textColor),
                        prefixIcon: Icon(Icons.lock, color: theme?.textColor),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: theme?.textColor,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                      ),
                      validator: FormValidators.validatePassword,
                    ),
                  ),

                  // Fehlermeldung
                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(color: Colors.red[200], fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ),

                  // Passwort vergessen Link
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                          context,
                          '/reset-password',
                        );
                      },
                      child: Text(
                        'Forgot your password?',
                        style: TextStyle(color: theme?.textColor, fontSize: 14),
                      ),
                    ),
                  ),

                  SizedBox(height: 30),

                  // Login Button
                  ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme!.purpleThemeColor,
                      foregroundColor: theme.iconColor,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 2,
                    ),
                    child:
                        _isLoading
                            ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: theme.iconColor,
                              ),
                            )
                            : Text(
                              'Login',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                  ),

                  SizedBox(height: 30),

                  // Registrieren Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have account yet?",
                        style: TextStyle(color: theme.textColor),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/signup');
                        },
                        child: Text(
                          'Register here',
                          style: TextStyle(
                            color: theme.textColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
