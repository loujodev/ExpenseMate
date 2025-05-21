import 'package:expense_mate/src/features/auth/data/auth_repository.dart';
import 'package:expense_mate/src/shared/extension/custom_theme_extension.dart';
import 'package:expense_mate/src/shared/utils/firebase_exception_utils.dart';
import 'package:expense_mate/src/shared/utils/form_validators.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final AuthRepository _authRepository = AuthRepository();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _authRepository.resetPassword(_emailController.text.trim());

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('You got sent an email to reset your password'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      setState(() {
        if (e is FirebaseAuthException) {
          _errorMessage = getFirebaseAuthErrorMessage(e);
        } else {
          _errorMessage = 'Unexpected error occured';
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme?.textColor),
          onPressed: () => Navigator.pop(context),
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
                  Text(
                    'Reset password',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: theme?.textColor,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: screenSize.height * 0.04),

                  Text(
                    "You'll get sent a link to reset your password",
                    style: TextStyle(fontSize: 16, color: theme?.textColor),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: screenSize.height * 0.04),

                  Container(
                    decoration: BoxDecoration(
                      color: theme!.secondaryBackgroundColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(color: theme.textColor),
                      decoration: InputDecoration(
                        labelText: 'E-Mail',
                        labelStyle: TextStyle(color: theme.textColor),
                        prefixIcon: Icon(Icons.email, color: theme.textColor),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                      ),
                      validator: FormValidators.validateEmail,
                    ),
                  ),

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

                  ElevatedButton(
                    //delete all the data
                    onPressed: _isLoading ? null : _resetPassword,

                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.buttonColor,

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
                              'Reset password',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                  ),

                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
