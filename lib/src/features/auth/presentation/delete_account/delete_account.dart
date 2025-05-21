import 'package:expense_mate/src/features/auth/data/auth_repository.dart';
import 'package:expense_mate/src/features/profilepage/presentation/profile_page.dart';
import 'package:expense_mate/src/shared/controllers/cashflow_controller.dart';
import 'package:expense_mate/src/shared/controllers/category_controller.dart';
import 'package:expense_mate/src/shared/extension/custom_theme_extension.dart';
import 'package:expense_mate/src/shared/services/database_service.dart';
import 'package:expense_mate/src/shared/utils/firebase_exception_utils.dart';
import 'package:expense_mate/src/shared/utils/form_validators.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

///The delete account screen allows users to delete their account and all associated data.
///It can be accessed from the [ProfilePage]
///It contains a form where users can enter their email and password to confirm the deletion.
///If the user is logged in, the app will delete the local database and the Firebase account.
class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  final AuthRepository _authRepository = AuthRepository();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogout() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _authRepository.signOut();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Logout failed: ${e.toString()}',
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteAccount() async {
    final cashflowController = Provider.of<CashflowController>(
      context,
      listen: false,
    );
    final categoryController = Provider.of<CategoryController>(
      context,
      listen: false,
    );

    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Delete local database
      await DatabaseService.instance.deleteDatabaseFile(
        categoryController: categoryController,
        cashflowController: cashflowController,
      );

      // Delete Firebase account
      final success = await _authRepository.deleteUser(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (success && mounted) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account deleted successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else if (mounted) {
        setState(() => _errorMessage = 'Failed to delete account');
      }
    } catch (e) {
      setState(() {
        _errorMessage =
            (e is FirebaseAuthException)
                ? getFirebaseAuthErrorMessage(e)
                : 'Could not delete the account';
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
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
                    'Delete Account',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: theme?.textColor,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: screenSize.height * 0.04),

                  Text(
                    "Enter your email and password to delete your account and all the data you saved inside the app",
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

                  SizedBox(height: screenSize.height * 0.04),

                  Container(
                    decoration: BoxDecoration(
                      color: theme!.secondaryBackgroundColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      controller: _passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      style: TextStyle(color: theme.textColor),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(color: theme.textColor),
                        prefixIcon: Icon(Icons.email, color: theme.textColor),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                      ),
                      validator: FormValidators.validatePassword,
                    ),
                  ),

                  SizedBox(height: screenSize.height * 0.04),

                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(color: Colors.red[200], fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ),

                  ElevatedButton(
                    //delete all the data
                    onPressed: _isLoading ? null : _deleteAccount,

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
                              'Delete Account',
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
