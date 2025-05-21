import 'package:expense_mate/src/features/auth/data/auth_repository.dart';
import 'package:expense_mate/src/features/auth/presentation/login/login_screen.dart';
import 'package:expense_mate/src/shared/extension/custom_theme_extension.dart';
import 'package:expense_mate/src/shared/utils/firebase_exception_utils.dart';
import 'package:expense_mate/src/shared/utils/form_validators.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final AuthRepository _authRepository = AuthRepository();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signup() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _authRepository.signUpWithEmailPassword(
        _emailController.text.trim(),
        _passwordController.text,
      );

      await _authRepository.currentUser?.updateDisplayName(
        _nameController.text.trim(),
      );

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    } catch (e) {
      setState(() {
        if (e is FirebaseAuthException) {
          _errorMessage = getFirebaseAuthErrorMessage(e);
        } else {
          _errorMessage = 'Unexpected Error occured';
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme?.textColor),
          onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Titel
                  Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: theme?.textColor,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: screenSize.height * 0.04),

                  // Name Feld
                  Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 121, 121, 121),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      controller: _nameController,
                      style: TextStyle(color: theme?.textColor),
                      decoration: InputDecoration(
                        labelText: 'Name',
                        labelStyle: TextStyle(color: theme?.textColor),
                        prefixIcon: Icon(Icons.person, color: theme?.textColor),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                      ),
                      validator: FormValidators.validateName,
                    ),
                  ),

                  SizedBox(height: 16),

                  // Email Feld
                  Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 121, 121, 121),
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

                  SizedBox(height: 16),

                  // Passwort Feld
                  Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 121, 121, 121),
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

                  SizedBox(height: 16),

                  // Passwort bestätigen Feld
                  Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 121, 121, 121),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      style: TextStyle(color: theme?.textColor),
                      decoration: InputDecoration(
                        labelText: 'Confirm password ',
                        labelStyle: TextStyle(color: theme?.textColor),
                        prefixIcon: Icon(
                          Icons.lock_outline,
                          color: theme?.textColor,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: theme?.textColor,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword =
                                  !_obscureConfirmPassword;
                            });
                          },
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                      ),
                      validator:
                          (value) =>
                              FormValidators.validatePasswordConfirmation(
                                value,
                                _passwordController.text,
                              ),
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

                  SizedBox(height: 30),

                  // Registrieren Button
                  ElevatedButton(
                    onPressed: _isLoading ? null : _signup,
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
                                color: theme?.iconColor,
                              ),
                            )
                            : Text(
                              'Register',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                  ),

                  SizedBox(height: 20),

                  // Anmelden Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Do you already have an account?',
                        style: TextStyle(color: theme.textColor),
                      ),
                      TextButton(
                        onPressed:
                            () => Navigator.pushReplacementNamed(
                              context,
                              '/login',
                            ),
                        child: Text(
                          'Login here',
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
