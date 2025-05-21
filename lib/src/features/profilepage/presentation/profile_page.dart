import 'dart:io';
import 'package:expense_mate/src/features/auth/data/auth_repository.dart';
import 'package:expense_mate/src/features/auth/presentation/delete_account/delete_account.dart';
import 'package:expense_mate/src/features/auth/presentation/reset_password/reset_password_screen.dart';
import 'package:expense_mate/src/features/profilepage/presentation/notifcation_switch.dart';
import 'package:expense_mate/src/features/profilepage/presentation/theme_switch.dart';
import 'package:expense_mate/src/shared/controllers/cashflow_controller.dart';
import 'package:expense_mate/src/shared/controllers/category_controller.dart';
import 'package:expense_mate/src/shared/controllers/theme_controller.dart';
import 'package:expense_mate/src/shared/extension/custom_theme_extension.dart';
import 'package:expense_mate/src/shared/services/camera_sevice.dart';
import 'package:expense_mate/src/shared/services/database_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

/// ProfilePage is the third of the three main pages in the app.
/// and personalization settings.
///
/// This widget provides:
/// - User profile display with editable profile picture (via camera or gallery using [CameraService])
/// - Theme switching functionality (light/dark mode) using [CustomThemeColorsExtension]
/// - Account management options:
///   - Password reset functionality - redirecting to [ResetPasswordScreen]
///   - Privacy policy access
///   - Logout capability with local data cleanup
///
///
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthRepository _authRepository = AuthRepository();
  final CameraService _cameraService = CameraService();
  // ignore: unused_field
  bool _isLoading = false;

  // a key to force refresh the FutureBuilder of the image
  // (to tell flutter this is a completely new image, don't reuse the old one)
  Key _profileImageKey = UniqueKey();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<CustomThemeColorsExtension>();
    final themeController = Provider.of<ThemeController>(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final TextStyle styling = GoogleFonts.roboto(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: theme?.iconColor,
    );

    return Scaffold(
      backgroundColor: theme?.mainBackGroundColor,

      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.only(bottom: screenHeight * 0.2),
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.1),
              Text(
                "Profile",
                style: GoogleFonts.roboto(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                  color: theme!.textColor,
                ),
              ),
              SizedBox(height: screenHeight * 0.04),
              Container(
                width: screenWidth * 0.4,
                height: screenWidth * 0.4,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: theme.iconColor ?? Colors.grey,
                    width: 2,
                  ),
                ),
                child: GestureDetector(
                  onTap: () {
                    _showActionSheet(context, themeController);
                  },
                  child: FutureBuilder<String?>(
                    key: _profileImageKey,
                    future: DatabaseService.instance.getProfilePicturePath(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data != null) {
                        return CircleAvatar(
                          backgroundImage: FileImage(File(snapshot.data!)),
                          radius: 50,
                        );
                      } else {
                        return CircleAvatar(child: Icon(Icons.person));
                      }
                    },
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Text(
                _authRepository.currentUser?.displayName ?? 'Benutzer',
                style: styling,
              ),
              Text(
                _authRepository.currentUser?.email ?? 'E-Mail',
                style: styling,
              ),
              SizedBox(height: screenHeight * 0.04),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    //ThemeSwitch
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("🌙   Theme", style: styling),
                          ThemeSwitch(),
                        ],
                      ),
                    ),
                    //Turn notifications on/off
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("🔔  Notifications", style: styling),
                          NotificationSwitch(),
                        ],
                      ),
                    ),
                    //Change password
                    _buildProfileOption(
                      icon: Icons.lock,
                      title: 'Change Password',
                      styling: styling,

                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ResetPasswordScreen(),
                          ),
                        );
                      },
                      theme: theme!,
                    ),
                    //Privacy policy
                    _buildProfileOption(
                      icon: Icons.notifications,
                      title: 'Privacy Policy',
                      styling: styling,
                      onTap: () {
                        _launchPrivacyPolicy();
                      },
                      theme: theme,
                    ),
                    //logout
                    _buildProfileOption(
                      icon: Icons.logout,
                      title: 'Logout',
                      onTap: () => _showAlertDialog(context, themeController),
                      theme: theme,
                      styling: styling,
                    ),
                    _buildProfileOption(
                      icon: Icons.delete,
                      title: "Delete your Profile",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DeleteAccountScreen(),
                          ),
                        );
                      },
                      theme: theme,
                      styling: styling,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///Builds a clickable widget that triggers an action when tapped
  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required CustomThemeColorsExtension theme,
    required TextStyle styling,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: theme.iconColor),
        title: Text(title, style: styling),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }

  ///Due to bad time managment and the requirements of the assessment (local Database) the users data will be deleted when logging out.
  ///In the future this will not be the case anymore and will be changed by using a cloud-based data storage via firebase.
  ///------------------------------------------------------------------------------------------------------
  ///
  ///Popup to inform the user about the consequence of all his data being deleted if he logs out.
  ///Deletes the local database if the user proceeds and triggers the [_handleLogout]
  ///
  ///If an error occurs another popup is shown [_showDatabaseDeletionAlertDialog]
  void _showAlertDialog(BuildContext context, ThemeController themeController) {
    final cashflowController = Provider.of<CashflowController>(
      context,
      listen: false,
    );
    final categoryController = Provider.of<CategoryController>(
      context,
      listen: false,
    );

    showCupertinoDialog<void>(
      context: context,
      builder:
          (BuildContext context) => CupertinoTheme(
            data: CupertinoThemeData(
              brightness:
                  themeController.isDark ? Brightness.dark : Brightness.light,
            ),
            child: CupertinoAlertDialog(
              title: Text(
                'If you log out, all your locally saved data will be erased.',
              ),
              content: const Text('Do you want to procceed?'),
              actions: <CupertinoDialogAction>[
                CupertinoDialogAction(
                  isDefaultAction: true,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('No'),
                ),
                CupertinoDialogAction(
                  isDestructiveAction: true,
                  onPressed: () async {
                    try {
                      await DatabaseService.instance.deleteDatabaseFile(
                        categoryController: categoryController,
                        cashflowController: cashflowController,
                      );
                      _handleLogout();
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                    } catch (e) {
                      // ignore: use_build_context_synchronously
                      _showDatabaseDeletionAlertDialog(
                        // ignore: use_build_context_synchronously
                        context,
                        themeController,
                      );
                    }
                  },

                  child: const Text('Yes'),
                ),
              ],
            ),
          ),
    );
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

  ///Method used for the profile picture
  ///uses showCupertinoModalPopup to display three options:
  /// -use the camera to take a picture and save its path to the database and trigger a refresh
  /// -use the gallery to take a picture and save its path to the database and trigger a refresh
  /// -delete the current picutre from the database and and trigger a refresh
  void _showActionSheet(BuildContext context, ThemeController themeController) {
    showCupertinoModalPopup<void>(
      context: context,
      builder:
          (BuildContext context) => CupertinoTheme(
            data: CupertinoThemeData(
              brightness:
                  themeController.isDark ? Brightness.dark : Brightness.light,
            ),
            child: CupertinoActionSheet(
              title: const Text('Choose an option'),
              actions: <CupertinoActionSheetAction>[
                CupertinoActionSheetAction(
                  isDefaultAction: true,
                  onPressed: () async {
                    await _cameraService.captureAndSaveProfilePictureCamera();
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                    setState(() {
                      _profileImageKey = UniqueKey();
                    });
                  },
                  child: const Text('Take a picture'),
                ),
                CupertinoActionSheetAction(
                  onPressed: () async {
                    await _cameraService.captureAndSaveProfilePictureGallery();
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                    setState(() {
                      _profileImageKey = UniqueKey();
                    });
                  },
                  child: const Text('Import from library'),
                ),
                CupertinoActionSheetAction(
                  isDestructiveAction: true,
                  onPressed: () async {
                    await DatabaseService.instance.removeProfilePicture();
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                    setState(() {
                      _profileImageKey = UniqueKey();
                    });
                  },
                  child: const Text('Delete picture'),
                ),
              ],
            ),
          ),
    );
  }

  //Redirects the user to the privacy policy
  void _launchPrivacyPolicy() async {
    final Uri url = Uri.parse('https://www.expense-mate.com/privacy/');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  //Method to tell the user that his data could not be deleted therefore the log out didnt work
  void _showDatabaseDeletionAlertDialog(
    BuildContext context,
    ThemeController themeController,
  ) {
    showCupertinoDialog<void>(
      context: context,
      builder:
          (BuildContext context) => CupertinoTheme(
            data: CupertinoThemeData(
              brightness:
                  themeController.isDark ? Brightness.dark : Brightness.light,
            ),
            child: CupertinoAlertDialog(
              title: const Text('Could not log out of the account'),
              content: const Text(
                'You data could not be deleted, please try again',
              ),
              actions: <CupertinoDialogAction>[
                CupertinoDialogAction(
                  isDefaultAction: true,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Okay'),
                ),
              ],
            ),
          ),
    );
  }
}
