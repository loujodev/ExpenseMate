import 'package:expense_mate/src/shared/presentation/widgets/header_widget.dart';
import 'package:flutter/material.dart';

///Back button used inside the [HeaderWidget] to redirect the user to the previously visited page
class CustomBackButton extends StatelessWidget {
  final Color iconColor;
  final VoidCallback? onPressed;

  const CustomBackButton({
    super.key,
    this.iconColor = Colors.white,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: iconColor),
            onPressed: onPressed ?? () => Navigator.pop(context),
          ),
        ),
      ),
    );
  }
}
